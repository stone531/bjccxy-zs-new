package student

import (
	"bytes"
	"fmt"
	"io"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/go-pay/gopay"
	"github.com/go-pay/gopay/wechat/v3"
	"go.uber.org/zap"
	"gorm.io/gorm"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	mstud "github.com/flipped-aurora/gin-vue-admin/server/model/student"
	"github.com/flipped-aurora/gin-vue-admin/server/utils"
)

// WeChatPayNotify 微信支付回调（适配 gopay v1.5.114）
func (b *BsStudentApi) WeChatPayNotify(c *gin.Context) {
	cfg := global.GVA_CONFIG.WeChat

	global.GVA_LOG.Info("WeChatPayNotify 001")
	// 1. 读取并备份原始 body（V3ParseNotify 会再次读取 Request.Body）
	rawBody, err := io.ReadAll(c.Request.Body)
	if err != nil {
		//xlog.Errorf("read notify body err: %v", err)
		global.GVA_LOG.Error("WeChatPayNotify read notify body err：", zap.Error(err))
		c.String(http.StatusBadRequest, "FAIL")
		return
	}
	global.GVA_LOG.Info("WeChatPayNotify 002:", zap.Any("rawBody", string(rawBody)))
	// 恢复请求体，供 V3ParseNotify 使用
	c.Request.Body = io.NopCloser(bytes.NewReader(rawBody))

	// 3. 尝试自动同步平台证书并启用自动验签（推荐）
	//    如果这个步骤失败，也可以通过 client.GetAndSelectNewestCert()/WxPublicKeyMap() 手动获取公钥
	global.GVA_LOG.Info("WeChatPayNotify 003")
	if err := global.GVA_WECHAT.AutoVerifySign(); err != nil {
		// 不一定直接 fatal，有可能是配置问题（比如 apiV3Key 长度问题），记录日志并继续尝试手动流程
		//xlog.Warnf("client.AutoVerifySign warning: %v", err)
		global.GVA_LOG.Error("WeChatPayNotify client.AutoVerifySign warning：", zap.Error(err))
	}

	global.GVA_LOG.Info("WeChatPayNotify 004")
	// 4. 解析回调内容 -> 得到 *wechat.V3NotifyReq
	notifyReq, err := wechat.V3ParseNotify(c.Request)
	if err != nil {
		//xlog.Errorf("wechat.V3ParseNotify err: %v, rawBody: %s", err, string(rawBody))
		// 返回微信指定格式（也可直接返回 plain SUCCESS/FAIL）
		global.GVA_LOG.Error("WeChatPayNotify wechat.V3ParseNotify err:", zap.Error(err), zap.String("rawBody", string(rawBody)))
		c.JSON(http.StatusOK, &wechat.V3NotifyRsp{Code: gopay.FAIL, Message: "回调内容异常"})
		return
	}

	global.GVA_LOG.Info("WeChatPayNotify 005")
	// 5. 获取微信平台公钥 map（AutoVerifySign() 成功时该 map 会被填充）
	certMap := global.GVA_WECHAT.WxPublicKeyMap()
	if len(certMap) == 0 {
		// 若为空，尝试主动拉取并选择最新证书（会自动填充 SnCertMap / WxPublicKeyMap）
		if _, _, gerr := global.GVA_WECHAT.GetAndSelectNewestCert(); gerr != nil {
			global.GVA_LOG.Warn("WeChatPayNotify GetAndSelectNewestCert err:", zap.Error(gerr))
			//xlog.Warnf("GetAndSelectNewestCert warn: %v", gerr)
		} else {
			certMap = global.GVA_WECHAT.WxPublicKeyMap()
		}
	}
	global.GVA_LOG.Info("WeChatPayNotify 006")
	// 6. 验签：使用 notifyReq 提供的方法并传入证书 Map 自动匹配证书验证
	if err := notifyReq.VerifySignByPKMap(certMap); err != nil {
		//xlog.Errorf("notifyReq.VerifySignByPKMap err: %v", err)
		global.GVA_LOG.Warn("WeChatPayNotify notifyReq.VerifySignByPKMap err:", zap.Error(err))
		c.JSON(http.StatusUnauthorized, gin.H{"code": "FAIL", "message": "签名验证失败"})
		return
	}

	// 7. 解密 resource.ciphertext -> 填充到自定义结构体
	global.GVA_LOG.Info("WeChatPayNotify 007")
	var decryptData struct {
		OutTradeNo    string `json:"out_trade_no"`
		TransactionId string `json:"transaction_id"`
		TradeState    string `json:"trade_state"`
		SuccessTime   string `json:"success_time"`
		// 你需要的其它字段可以继续加
	}
	if err := notifyReq.DecryptCipherTextToStruct(cfg.MchKey, &decryptData); err != nil {
		//xlog.Errorf("notifyReq.DecryptCipherTextToStruct err: %v", err)
		global.GVA_LOG.Warn("WeChatPayNotify notifyReq.DecryptCipherTextToStruct err:", zap.Error(err))
		c.JSON(http.StatusBadRequest, gin.H{"code": "FAIL", "message": "解密失败"})
		return
	}
	global.GVA_LOG.Info("wechat notify decrypt result: ", zap.Any("decryptData:", decryptData))

	// 8. 幂等 & 更新订单状态
	if decryptData.OutTradeNo == "" {
		//xlog.Error("empty out_trade_no in notify")
		global.GVA_LOG.Error("WeChatPayNotify empty out_trade_no in notify")
		c.JSON(http.StatusBadRequest, gin.H{"code": "FAIL", "message": "订单号为空"})
		return
	}

	global.GVA_LOG.Info("WeChatPayNotify 008")

	db := global.GVA_DB
	var order mstud.BsOrders
	if err := db.Where("order_sn = ?", decryptData.OutTradeNo).First(&order).Error; err != nil {
		if err == gorm.ErrRecordNotFound {
			// 订单不存在：记录日志并返回 SUCCESS（避免微信无限重试），或按你业务选择返回 FAIL 让微信重试
			//xlog.Warnf("order not found: %s", decryptData.OutTradeNo)
			global.GVA_LOG.Warn("WeChatPayNotify order not found:", zap.String("OutTradeNo:", decryptData.OutTradeNo))
			c.JSON(http.StatusOK, gin.H{"code": "SUCCESS", "message": "处理完毕"})
			return
		}
		//xlog.Errorf("db query order err: %v", err)
		global.GVA_LOG.Error("WeChatPayNotify db query order err:", zap.Error(err))
		c.String(http.StatusInternalServerError, "FAIL")
		return
	}
	global.GVA_LOG.Info("WeChatPayNotify 009")

	// 如果已经是支付成功，直接返回 SUCCESS（幂等）
	if order.Status == 1 {
		c.JSON(http.StatusOK, gin.H{"code": "SUCCESS", "message": "成功"})
		return
	}

	global.GVA_LOG.Info("WeChatPayNotify 010")
	// 仅在微信通知 trade_state == "SUCCESS" 时认定支付成功
	if decryptData.TradeState == "SUCCESS" {
		payTime := time.Now()
		if decryptData.SuccessTime != "" {
			if t, terr := time.Parse(time.RFC3339, decryptData.SuccessTime); terr == nil {
				payTime = t
			}
		}
		if err := db.Model(&mstud.BsOrders{}).
			Where("order_sn = ?", decryptData.OutTradeNo).
			Updates(map[string]interface{}{
				"status":         1,
				"transaction_id": decryptData.TransactionId,
				"pay_time":       payTime,
				"notify_data":    string(rawBody),
			}).Error; err != nil {
			global.GVA_LOG.Error("update order failed:", zap.Error(err))
			//xlog.Errorf("update order failed: %v", err)
			c.String(http.StatusInternalServerError, "FAIL")
			return
		}

		// TODO: 在这里触发你的业务（发放课程、发通知等），建议异步执行
		// go service.HandleSuccessfulPayment(order.ID)
	}
	global.GVA_LOG.Info("WeChatPayNotify 011")

	// 9. 返回微信成功应答（注意微信要求的 JSON 格式）
	c.JSON(http.StatusOK, gin.H{"code": "SUCCESS", "message": "成功"})
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
