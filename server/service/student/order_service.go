package student

import (
	"errors"
	"time"

	"github.com/flipped-aurora/gin-vue-admin/server/model/business"
	"github.com/flipped-aurora/gin-vue-admin/server/model/student"
	emailreq "github.com/flipped-aurora/gin-vue-admin/server/model/student/request"
	stureq "github.com/flipped-aurora/gin-vue-admin/server/model/student/request"
	"github.com/flipped-aurora/gin-vue-admin/server/model/student/response"
	"github.com/flipped-aurora/gin-vue-admin/server/utils"
	"github.com/google/uuid"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"gorm.io/gorm"
)

//@author: [piexlmax](https://github.com/piexlmax)
//@function: Register
//@description: 用户注册
//@param: u model.SysUser
//@return: userInter system.SysUser, err error

type OrderService struct{}

var BsServiceApp = new(OrderService)

func (s *OrderService) GetMyPendingOrder(userID int64) ([]BsOrders, error) {
    var orders []BsOrders
    err := global.GVA_DB.Where("user_id = ? AND status = ?", userID, 0).Find(&orders).Error
    return orders, err
}

func (s *OrderService) CreateWeChatPay(orderSn string) (string, error) {
    // 1. 查询订单
    var order BsOrders
    if err := global.GVA_DB.Where("order_sn = ?", orderSn).First(&order).Error; err != nil {
        return "", err
    }

    // 2. 调用微信统一下单接口（NATIVE模式）
    req := map[string]string{
        "appid":            global.GVA_CONFIG.WeChat.AppID,
        "mch_id":           global.GVA_CONFIG.WeChat.MchID,
        "nonce_str":        utils.GenNonceStr(),
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

    return codeURL, nil
}

func (s *OrderService) GetOrderStatus(orderSn string) (int8, error) {
    var order BsOrders
    if err := global.GVA_DB.Select("status").Where("order_sn = ?", orderSn).First(&order).Error; err != nil {
        return 0, err
    }
    return order.Status, nil
}

//微信支付回调
func (s *OrderService) WeChatPayNotify(c *gin.Context) {
    body, _ := io.ReadAll(c.Request.Body)

    // 验签（RSA 或 HMAC-SHA256）
    // ...

    // 解析 XML
    var notifyData WeChatNotify
    xml.Unmarshal(body, &notifyData)

    if notifyData.ResultCode == "SUCCESS" {
        // 更新订单状态
        global.GVA_DB.Model(&BsOrders{}).
            Where("order_sn = ?", notifyData.OutTradeNo).
            Updates(map[string]interface{}{
                "status":         1,
                "transaction_id": notifyData.TransactionID,
                "pay_time":       time.Now(),
                "notify_data":    string(body),
            })
    }

    // 返回给微信
    c.XML(200, gin.H{
        "return_code": "SUCCESS",
        "return_msg":  "OK",
    })
}