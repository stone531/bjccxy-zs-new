package student

import (
	"context"
	"crypto/rand"
	"crypto/x509"
	"encoding/pem"
	"fmt"
	"io/ioutil"
	"os"
	"strconv"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/go-pay/gopay"
	"github.com/go-pay/gopay/wechat/v3"
	"go.uber.org/zap"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common"
	mstud "github.com/flipped-aurora/gin-vue-admin/server/model/student"
)

//@author: [piexlmax](https://github.com/piexlmax)
//@function: Register
//@description: 用户注册
//@param: u model.SysUser
//@return: userInter system.SysUser, err error

type OrderService struct{}

var BsServiceApp = new(OrderService)

func (s *OrderService) GetMyPendingOrder(userID int64) ([]mstud.BsOrders, error) {
	var orders []mstud.BsOrders
	err := global.GVA_DB.Where("user_id = ? AND status = ?", userID, 0).Find(&orders).Error
	return orders, err
}

func (s *OrderService) CreateWeChatPay(orderSn string) (string, error) {
	// 1. 查询订单
	var order mstud.BsOrders
	if err := global.GVA_DB.Where("order_sn = ?", orderSn).First(&order).Error; err != nil {
		return "", err
	}

	// 2. 调用微信统一下单接口（NATIVE模式）
	req := map[string]string{
		//"appid":            global.GVA_CONFIG.WeChat.AppID,
		"mch_id": global.GVA_CONFIG.WeChat.MchID,
		//"nonce_str":        utils.GenNonceStr(),
		"body":             order.Body,
		"out_trade_no":     order.OrderSN,
		"total_fee":        strconv.Itoa(order.TotalFee), // 分
		"spbill_create_ip": "127.0.0.1",
		"notify_url":       global.GVA_CONFIG.WeChat.NotifyURL,
		"trade_type":       "NATIVE",
	}

	// 3. 签名 + 发送请求（沙箱环境 URL）
	// 4. 解析响应，返回 code_url 生成二维码
	// ...

	codeURL := req["notify_url"]
	return codeURL, nil
}

func (s *OrderService) GetOrderStatus(orderSn string) (int8, error) {
	var order mstud.BsOrders
	if err := global.GVA_DB.Select("status").Where("order_sn = ?", orderSn).First(&order).Error; err != nil {
		return 0, err
	}
	return order.Status, nil
}

// 微信支付回调
func (s *OrderService) WeChatPayNotify(c *gin.Context) {
	//body, _ := io.ReadAll(c.Request.Body)

	// 验签（RSA 或 HMAC-SHA256）
	// ...

	// 解析 XML
	/*var notifyData WeChatNotify
	xml.Unmarshal(body, &notifyData)

	if notifyData.ResultCode == "SUCCESS" {
		// 更新订单状态
		global.GVA_DB.Model(&mstud.BsOrders{}).
			Where("order_sn = ?", notifyData.OutTradeNo).
			Updates(map[string]interface{}{
				"status":         1,
				"transaction_id": notifyData.TransactionID,
				"pay_time":       time.Now(),
				"notify_data":    string(body),
			})
	}*/

	// 返回给微信
	c.XML(200, gin.H{
		"return_code": "SUCCESS",
		"return_msg":  "OK",
	})
}

func (s *OrderService) GenerateOrderSN(userID uint) string {
	timestamp := time.Now().Format("20060102150405") // 精确到秒
	randomStr := s.randomString(8)                   // 8位随机字符串
	return fmt.Sprintf("%s%d%s", timestamp, userID, randomStr)
}

// randomString 生成随机字符串
func (s *OrderService) randomString(n int) string {
	const letters = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	bytes := make([]byte, n)
	_, _ = rand.Read(bytes)
	for i := range bytes {
		bytes[i] = letters[bytes[i]%byte(len(letters))]
	}
	return string(bytes)
}

func (s *OrderService) CreateOrder(orderType common.WeiChatType_Type, userID uint, totalFee int) error {
	var (
		body     string
		detail   string
		certType string
	)

	if orderType == common.Graduschool_ZhengShu {
		body = "毕业证书"
		detail = "在线毕业证书申请"
		certType = "graduation"
	} else if orderType == common.Training_ZhengShu {
		body = "培训证书"
		detail = "在线培训书申请"
		certType = "training"
	}

	order := &mstud.BsOrders{
		UserID:     int64(userID),
		OrderSN:    s.GenerateOrderSN(userID),
		TotalFee:   totalFee,
		FeeType:    "CNY",
		CertType:   certType,
		Body:       body,
		Detail:     detail,
		Status:     0, // 待支付
		PayType:    "NATIVE",
		ExpireTime: time.Now().Add(15 * time.Minute), // 默认15分钟过期
	}

	if err := global.GVA_DB.Create(order).Error; err != nil {
		return err
	}
	return nil
}

func (w *OrderService) CreateNativeOrder(orderSN string, totalFee int, description string) (string, error) {
	cfg := global.GVA_CONFIG.WeChat

	fmt.Println("CreateNativeOrder sn:", orderSN, cfg.MchID, cfg.MchKey, cfg.CertPath, cfg.KeyPath)
	// 初始化微信支付客户端
	client, err := wechat.NewClientV3(cfg.MchID, cfg.MchKey, cfg.CertPath, cfg.KeyPath)
	if err != nil {
		global.GVA_LOG.Error("CreateNativeOrder NewClientV3 获取失败!", zap.Error(err))

		return "", err
	}

	fmt.Println("CreateNativeOrder client ok")
	// 构造请求参数
	bm := make(gopay.BodyMap)
	bm.Set("appid", cfg.AppID).
		Set("mchid", cfg.MchID).
		Set("description", description).
		Set("out_trade_no", orderSN).
		Set("notify_url", cfg.NotifyURL).
		SetBodyMap("amount", func(b gopay.BodyMap) {
			b.Set("total", totalFee). // 金额，单位分
							Set("currency", "CNY")
		})

	fmt.Println("CreateNativeOrder bm:", bm)

	// 请求微信生成二维码
	resp, err := client.V3TransactionNative(context.Background(), bm)
	if err != nil {
		global.GVA_LOG.Error("CreateNativeOrder V3TransactionNative 获取失败!", zap.Error(err))
		return "", err
	}
	fmt.Println("CreateNativeOrder resp:", resp)

	//resp.Response.CodeUrl
	// 返回二维码链接
	return resp.Response.CodeUrl, nil
}
func (w *OrderService) CreateNativeOrder_test(orderSN string, totalFee int, description string) (string, error) {
	cfg := global.GVA_CONFIG.WeChat

	fmt.Println("CreateNativeOrder sn:", orderSN, cfg.MchID, cfg.MchKey, cfg.CertPath, cfg.KeyPath)
	// 初始化微信支付客户端

	keyBytes, err := os.ReadFile(cfg.KeyPath)
	if err != nil {
		global.GVA_LOG.Error("读取私钥失败", zap.Error(err))
		return "", err
	}

	//client, err := wechat.NewClientV3(cfg.MchID, cfg.MchKey, cfg.CertPath, cfg.KeyPath)

	client, err := wechat.NewClientV3(cfg.MchID, cfg.MchKey, cfg.CertPath, string(keyBytes))
	if err != nil {
		global.GVA_LOG.Error("NewClientV3 创建失败", zap.Error(err))
		return "", err
	}

	fmt.Println("CreateNativeOrder client ok")
	// 构造请求参数
	bm := make(gopay.BodyMap)
	bm.Set("appid", cfg.AppID).
		Set("mchid", cfg.MchID).
		Set("description", description).
		Set("out_trade_no", orderSN).
		Set("notify_url", cfg.NotifyURL).
		SetBodyMap("amount", func(b gopay.BodyMap) {
			b.Set("total", totalFee). // 金额，单位分
							Set("currency", "CNY")
		})

	fmt.Println("CreateNativeOrder bm:", bm)

	// 请求微信生成二维码
	resp, err := client.V3TransactionNative(context.Background(), bm)
	if err != nil {
		global.GVA_LOG.Error("CreateNativeOrder V3TransactionNative 获取失败!", zap.Error(err))
		return "", err
	}
	fmt.Println("CreateNativeOrder resp:", resp)

	//resp.Response.CodeUrl
	// 返回二维码链接
	return resp.Response.CodeUrl, nil
}

func (w *OrderService) InitWechatClient() (*wechat.ClientV3, error) {
	return wechat.NewClientV3("商户号", "证书序列号", "APIv3密钥", "私钥内容")
}

func (w *OrderService) GetSerialNumber() (string, error) {
	cfg := global.GVA_CONFIG.WeChat
	certPEM, err := ioutil.ReadFile(cfg.CertPath)
	if err != nil {
		return "", fmt.Errorf("read cert file error: %v", err)
	}
	block, _ := pem.Decode(certPEM)
	if block == nil {
		return "", fmt.Errorf("decode pem error")
	}
	cert, err := x509.ParseCertificate(block.Bytes)
	if err != nil {
		return "", fmt.Errorf("parse cert error: %v", err)
	}
	return fmt.Sprintf("%X", cert.SerialNumber), nil
}
