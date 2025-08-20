package student

import (
	"bytes"
	"crypto/rsa"
	"errors"
	"fmt"
	"io"
	"net/http"
	"os"
	"reflect"
	"strings"
	"time"

	"crypto/x509"
	"encoding/pem"

	"github.com/gin-gonic/gin"
	"github.com/go-pay/gopay"
	"github.com/go-pay/gopay/wechat/v3"
	"go.uber.org/zap"
	"gorm.io/gorm"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	mstud "github.com/flipped-aurora/gin-vue-admin/server/model/student"
	"github.com/flipped-aurora/gin-vue-admin/server/utils"
)

func (b *BsStudentApi) WeChatPayNotify(c *gin.Context) {
	cfg := global.GVA_CONFIG.WeChat
	logger := global.GVA_LOG

	// 1. 接收原始回调数据
	rawBody, err := io.ReadAll(c.Request.Body)
	if err != nil {
		logger.Error("读取回调Body失败", zap.Error(err))
		c.String(http.StatusBadRequest, "FAIL")
		return
	}
	defer c.Request.Body.Close()
	c.Request.Body = io.NopCloser(bytes.NewReader(rawBody)) // 重置Body供后续解析

	// 获取关键请求头（用于动态验签）
	serial := c.GetHeader("Wechatpay-Serial")
	signature := c.GetHeader("Wechatpay-Signature")

	// 2. 解析回调通知
	notifyReq, err := wechat.V3ParseNotify(c.Request)
	if err != nil {
		logger.Error("解析回调结构失败", zap.Error(err))
		c.JSON(http.StatusOK, &wechat.V3NotifyRsp{Code: gopay.FAIL, Message: "回调解析异常"})
		return
	}

	// 3. 处理签名探测流量（微信测试请求）
	if strings.HasPrefix(signature, "WECHATPAY-SIGNATURE-TEST") {
		logger.Info("收到微信签名探测流量，直接返回成功")
		c.JSON(http.StatusOK, gin.H{"code": "SUCCESS", "message": "签名探测已处理"})
		return
	}

	// 4. 加载并解析微信支付平台公钥
	pubKeyBytes, err := os.ReadFile(cfg.RootCA)
	if err != nil {
		logger.Error("读取公钥文件失败", zap.String("path", cfg.RootCA), zap.Error(err))
		c.JSON(http.StatusInternalServerError, gin.H{"code": "FAIL", "message": "公钥读取失败"})
		return
	}
	logger.Info("公钥文件内容摘要", zap.String("pubKeyPrefix", string(pubKeyBytes[:16])))

	block, _ := pem.Decode(pubKeyBytes)
	if block == nil || block.Type != "PUBLIC KEY" {
		logger.Error("公钥格式错误", zap.String("blockType", block.Type))
		c.JSON(http.StatusInternalServerError, gin.H{"code": "FAIL", "message": "无效的公钥格式"})
		return
	}

	pubKey, err := x509.ParsePKIXPublicKey(block.Bytes)
	if err != nil {
		logger.Error("解析公钥失败", zap.Error(err))
		c.JSON(http.StatusInternalServerError, gin.H{"code": "FAIL", "message": "公钥解析异常"})
		return
	}

	rsaPubKey, ok := pubKey.(*rsa.PublicKey)
	if !ok {
		logger.Error("非RSA公钥类型", zap.Any("pubKeyType", reflect.TypeOf(pubKey)))
		c.JSON(http.StatusInternalServerError, gin.H{"code": "FAIL", "message": "公钥类型错误"})
		return
	}

	// 5. 动态构建公钥映射（关键修复点）[3](@ref)
	certMap := map[string]*rsa.PublicKey{
		serial: rsaPubKey, // 动态使用回调头中的公钥ID
	}
	logger.Info("构建验签公钥映射",
		zap.String("publicKeyID", serial),
		zap.Int("keySize", rsaPubKey.Size()*8),
	)

	// 6. 验签（修复验签逻辑）[2](@ref)
	if err := notifyReq.VerifySignByPKMap(certMap); err != nil {
		logger.Warn("验签失败",
			zap.Error(err),
			zap.String("serial", serial),
			zap.String("signature", signature),
		)
		c.JSON(http.StatusUnauthorized, gin.H{"code": "FAIL", "message": "签名验证失败"})
		return
	}
	logger.Info("验签成功")

	// 7. 解密回调数据（需确保APIv3密钥正确）[4](@ref)
	var decryptData struct {
		OutTradeNo    string `json:"out_trade_no"`
		TransactionId string `json:"transaction_id"`
		TradeState    string `json:"trade_state"`
		SuccessTime   string `json:"success_time"`
	}
	if err := notifyReq.DecryptCipherTextToStruct(cfg.APIV3Key, &decryptData); err != nil {
		logger.Warn("数据解密失败",
			zap.Error(err),
			zap.String("apiV3KeyPrefix", cfg.APIV3Key[:4]+"***"), // 避免日志泄露完整密钥
		)
		c.JSON(http.StatusBadRequest, gin.H{"code": "FAIL", "message": "解密异常"})
		return
	}
	logger.Info("回调解密成功", zap.Any("decryptData", decryptData))

	// 8. 业务处理（幂等设计）
	db := global.GVA_DB
	var order mstud.BsOrders
	result := db.Where("order_sn = ?", decryptData.OutTradeNo).First(&order)
	if result.Error != nil {
		if errors.Is(result.Error, gorm.ErrRecordNotFound) {
			logger.Warn("订单不存在", zap.String("outTradeNo", decryptData.OutTradeNo))
			c.JSON(http.StatusOK, gin.H{"code": "SUCCESS", "message": "订单不存在"})
			return
		}
		logger.Error("查询订单失败", zap.Error(result.Error))
		c.String(http.StatusInternalServerError, "FAIL")
		return
	}

	// 8.1 检查订单状态避免重复处理
	if order.Status == 1 {
		logger.Info("订单已处理，直接返回成功", zap.String("orderSn", order.OrderSN))
		c.JSON(http.StatusOK, gin.H{"code": "SUCCESS", "message": "重复通知已忽略"})
		return
	}

	// 8.2 处理支付成功逻辑
	if decryptData.TradeState == "SUCCESS" {
		payTime := time.Now()
		if decryptData.SuccessTime != "" {
			if t, terr := time.Parse(time.RFC3339, decryptData.SuccessTime); terr == nil {
				payTime = t
			} else {
				logger.Warn("解析支付时间失败", zap.String("successTime", decryptData.SuccessTime), zap.Error(terr))
			}
		}

		updateData := map[string]interface{}{
			"status":         1,
			"transaction_id": decryptData.TransactionId,
			"pay_time":       payTime,
			"notify_data":    string(rawBody),
		}

		if err := db.Model(&mstud.BsOrders{}).
			Where("id = ?", order.ID).
			Updates(updateData).Error; err != nil {
			logger.Error("更新订单状态失败",
				zap.Uint("orderID", order.ID),
				zap.Any("updateData", updateData),
				zap.Error(err),
			)
			c.String(http.StatusInternalServerError, "FAIL")
			return
		}

		logger.Info("订单支付状态更新成功",
			zap.String("orderSn", order.OrderSN),
			zap.String("transactionID", decryptData.TransactionId),
		)

		if order.CertType == "training" {
			bsZhengshuService.UpdateTrainingPublic(uint(order.GoodsID))
		} else if order.CertType == "graduation" {
			bsZhengshuService.UpdateZhengshuPublic(uint(order.GoodsID))
		}

		// 异步处理业务逻辑（例：发放课程）
		go func(orderID uint) {
			defer func() {
				if r := recover(); r != nil {
					logger.Error("异步处理异常", zap.Any("recover", r))
				}
			}()
			// service.HandleSuccessfulPayment(orderID) // 实际业务逻辑
			logger.Info("异步业务处理完成", zap.Uint("orderID", orderID))
		}(order.ID)
	}

	// 9. 返回成功响应
	c.JSON(http.StatusOK, gin.H{"code": "SUCCESS", "message": "处理成功"})
}

// 刷新二维码
func (b *BsStudentApi) RefreshQRCode(c *gin.Context) {

	orderSn := c.Param("orderSn")
	id := utils.GetStudentID(c)

	cfg := global.GVA_CONFIG.WeChat

	// 1. 先关闭原订单（防止重复订单号冲突）
	closeBM := make(gopay.BodyMap)
	closeBM.Set("mchid", cfg.MchID).Set("out_trade_no", orderSn)
	//_, err := global.GVA_WECHAT.V3TransactionClose(c, closeBM)
	_, err := global.GVA_WECHAT.V3TransactionCloseOrder(c, orderSn)
	if err != nil {
		// 这里可以忽略已关闭/订单不存在的错误
		fmt.Println("关闭订单失败：", err)
		global.GVA_LOG.Error("RefreshQRCode 关闭订单失败：!", zap.Error(err))
	}

	// 2. 生成新的订单号
	newOrderSN := bsOrderService.GenerateOrderSN(id)

	// 3. 重新下单
	bm := make(gopay.BodyMap)
	bm.Set("appid", cfg.AppID).
		Set("mchid", cfg.MchID).
		Set("description", "测试商品-刷新二维码").
		Set("out_trade_no", newOrderSN).
		Set("notify_url", cfg.NotifyURL).
		SetBodyMap("amount", func(b gopay.BodyMap) {
			b.Set("total", 1) // 单位分
		})

	wxRsp, err := global.GVA_WECHAT.V3TransactionNative(c, bm)
	if err != nil {
		global.GVA_LOG.Error("RefreshQRCode V3TransactionNative:", zap.Error(err))
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	// 4. 返回新的二维码和订单号
	c.JSON(http.StatusOK, gin.H{
		"order_sn": newOrderSN,
		"code_url": wxRsp.Response.CodeUrl,
	})
}
