package student

import (
	"bytes"
	"fmt"
	"io"
	"net/http"
	"os"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/go-pay/gopay"
	"github.com/go-pay/gopay/wechat/v3"
	"github.com/go-pay/xlog"
	"gorm.io/gorm"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	mstud "github.com/flipped-aurora/gin-vue-admin/server/model/student"
	"github.com/flipped-aurora/gin-vue-admin/server/utils"
)

// type BsStudentApi struct{}
var client *wechat.ClientV3

// 初始化微信支付客户端
func InitWeChatClient() {
	var err error
	cfg := global.GVA_CONFIG.WeChat
	client, err = wechat.NewClientV3(cfg.MchID, cfg.MchKey, cfg.CertPath, cfg.KeyPath)
	if err != nil {
		panic(fmt.Errorf("init wechat client error: %v", err))
	}

	// 自动获取平台证书并启用自动验签
	err = client.AutoVerifySign()
	if err != nil {
		panic(fmt.Errorf("auto verify sign error: %v", err))
	}

	fmt.Println("WeChatPay Client 初始化成功")
}

// WeChatPayNotify 微信支付回调（适配 gopay v1.5.114）
func (b *BsStudentApi) WeChatPayNotify(c *gin.Context) {
	cfg := global.GVA_CONFIG.WeChat

	// 1. 读取并备份原始 body（V3ParseNotify 会再次读取 Request.Body）
	rawBody, err := io.ReadAll(c.Request.Body)
	if err != nil {
		xlog.Errorf("read notify body err: %v", err)
		c.String(http.StatusBadRequest, "FAIL")
		return
	}
	// 恢复请求体，供 V3ParseNotify 使用
	c.Request.Body = io.NopCloser(bytes.NewReader(rawBody))

	// 2. 初始化微信 V3 客户端（示例：使用 apiclient_key.pem 的内容作为 privateKey）
	//    请确保 cfg.SerialNo 已配置（商户 API 证书序列号），否则验签/上报可能失败
	privateKeyContent := cfg.KeyPath // 优先从配置中读私钥字符串
	if privateKeyContent == "" && cfg.KeyPath != "" {
		bs, rerr := os.ReadFile(cfg.KeyPath)
		if rerr != nil {
			xlog.Errorf("read private key file err: %v", rerr)
			c.String(http.StatusInternalServerError, "FAIL")
			return
		}
		privateKeyContent = string(bs)
	}

	serialNo, err := bsOrderService.GetSerialNumber()
	if err != nil {
		panic(err)
	}
	fmt.Println("商户证书序列号:", serialNo)

	client, err := wechat.NewClientV3(cfg.MchID, serialNo, cfg.MchKey, privateKeyContent)
	if err != nil {
		xlog.Errorf("wechat.NewClientV3 err: %v", err)
		c.String(http.StatusInternalServerError, "FAIL")
		return
	}

	// 3. 尝试自动同步平台证书并启用自动验签（推荐）
	//    如果这个步骤失败，也可以通过 client.GetAndSelectNewestCert()/WxPublicKeyMap() 手动获取公钥
	if err := client.AutoVerifySign(); err != nil {
		// 不一定直接 fatal，有可能是配置问题（比如 apiV3Key 长度问题），记录日志并继续尝试手动流程
		xlog.Warnf("client.AutoVerifySign warning: %v", err)
	}

	// 4. 解析回调内容 -> 得到 *wechat.V3NotifyReq
	notifyReq, err := wechat.V3ParseNotify(c.Request)
	if err != nil {
		xlog.Errorf("wechat.V3ParseNotify err: %v, rawBody: %s", err, string(rawBody))
		// 返回微信指定格式（也可直接返回 plain SUCCESS/FAIL）
		c.JSON(http.StatusOK, &wechat.V3NotifyRsp{Code: gopay.FAIL, Message: "回调内容异常"})
		return
	}

	// 5. 获取微信平台公钥 map（AutoVerifySign() 成功时该 map 会被填充）
	certMap := client.WxPublicKeyMap()
	if len(certMap) == 0 {
		// 若为空，尝试主动拉取并选择最新证书（会自动填充 SnCertMap / WxPublicKeyMap）
		if _, _, gerr := client.GetAndSelectNewestCert(); gerr != nil {
			xlog.Warnf("GetAndSelectNewestCert warn: %v", gerr)
		} else {
			certMap = client.WxPublicKeyMap()
		}
	}
	// 6. 验签：使用 notifyReq 提供的方法并传入证书 Map 自动匹配证书验证
	if err := notifyReq.VerifySignByPKMap(certMap); err != nil {
		xlog.Errorf("notifyReq.VerifySignByPKMap err: %v", err)
		c.JSON(http.StatusUnauthorized, gin.H{"code": "FAIL", "message": "签名验证失败"})
		return
	}

	// 7. 解密 resource.ciphertext -> 填充到自定义结构体
	var decryptData struct {
		OutTradeNo    string `json:"out_trade_no"`
		TransactionId string `json:"transaction_id"`
		TradeState    string `json:"trade_state"`
		SuccessTime   string `json:"success_time"`
		// 你需要的其它字段可以继续加
	}
	if err := notifyReq.DecryptCipherTextToStruct(cfg.MchKey, &decryptData); err != nil {
		xlog.Errorf("notifyReq.DecryptCipherTextToStruct err: %v", err)
		c.JSON(http.StatusBadRequest, gin.H{"code": "FAIL", "message": "解密失败"})
		return
	}

	xlog.Infof("wechat notify decrypt result: %+v", decryptData)

	// 8. 幂等 & 更新订单状态
	if decryptData.OutTradeNo == "" {
		xlog.Error("empty out_trade_no in notify")
		c.JSON(http.StatusBadRequest, gin.H{"code": "FAIL", "message": "订单号为空"})
		return
	}

	db := global.GVA_DB
	var order mstud.BsOrders
	if err := db.Where("order_sn = ?", decryptData.OutTradeNo).First(&order).Error; err != nil {
		if err == gorm.ErrRecordNotFound {
			// 订单不存在：记录日志并返回 SUCCESS（避免微信无限重试），或按你业务选择返回 FAIL 让微信重试
			xlog.Warnf("order not found: %s", decryptData.OutTradeNo)
			c.JSON(http.StatusOK, gin.H{"code": "SUCCESS", "message": "处理完毕"})
			return
		}
		xlog.Errorf("db query order err: %v", err)
		c.String(http.StatusInternalServerError, "FAIL")
		return
	}

	// 如果已经是支付成功，直接返回 SUCCESS（幂等）
	if order.Status == 1 {
		c.JSON(http.StatusOK, gin.H{"code": "SUCCESS", "message": "成功"})
		return
	}

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
			xlog.Errorf("update order failed: %v", err)
			c.String(http.StatusInternalServerError, "FAIL")
			return
		}

		// TODO: 在这里触发你的业务（发放课程、发通知等），建议异步执行
		// go service.HandleSuccessfulPayment(order.ID)
	}

	// 9. 返回微信成功应答（注意微信要求的 JSON 格式）
	c.JSON(http.StatusOK, gin.H{"code": "SUCCESS", "message": "成功"})
}

/*func (b *BsStudentApi) WeChatPayNotify(c *gin.Context) {
	body, err := ioutil.ReadAll(c.Request.Body)
	if err != nil {
		c.String(http.StatusBadRequest, "read body error")
		return
	}

	var notify wechat.V3NotifyReq
	if err = json.Unmarshal(body, &notify); err != nil {
		c.String(http.StatusBadRequest, "unmarshal error")
		return
	}

	// 解密回调数据
	var transaction wechat.Transaction
	err = wechat.DecryptCipherTextToStruct(cfg.MchKey,
		notify.Resource.Nonce,
		notify.Resource.Ciphertext,
		notify.Resource.AssociatedData,
		&transaction)
	if err != nil {
		c.String(http.StatusBadRequest, "decrypt error")
		return
	}

	if transaction.TradeState == "SUCCESS" {
		// 更新订单状态为已支付
		fmt.Println("订单支付成功:", transaction.OutTradeNo)
	} else {
		fmt.Println("订单支付状态:", transaction.TradeState)
	}

	c.String(http.StatusOK, `{"code":"SUCCESS","message":"OK"}`)
}*/

// 刷新二维码
func (b *BsStudentApi) RefreshQRCode(c *gin.Context) {
	cfg := global.GVA_CONFIG.WeChat

	bm := make(gopay.BodyMap)
	bm.Set("appid", "你的公众号/小程序 appid").
		Set("mchid", cfg.MchID).
		Set("description", "测试商品-刷新二维码").
		Set("out_trade_no", utils.GenerateOrderNo()).
		Set("notify_url", cfg.NotifyURL).
		SetBodyMap("amount", func(b gopay.BodyMap) {
			b.Set("total", 1) // 单位分
		})

	wxRsp, err := client.V3TransactionNative(c, bm)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"code_url": wxRsp.Response.CodeUrl, // 用这个生成二维码
	})
}
