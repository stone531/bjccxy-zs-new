package student

import (
	"time"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	//"github.com/google/uuid"
)

type StudentOrder interface {
	TableName() string
}

var _ StudentOrder = new(BsOrders)

type BsOrders struct {
	global.GVA_MODEL
	UserID        int64  `gorm:"column:user_id;not null;index;comment:用户ID"`
	OrderSN       string `gorm:"column:order_sn;type:varchar(32);not null;uniqueIndex;comment:商户订单号（唯一）"`
	TransactionID string `gorm:"column:transaction_id;type:varchar(32);comment:微信支付订单号"`
	PrepayID      string `gorm:"column:prepay_id;type:varchar(64);comment:预支付交易会话标识"`
	TotalFee      int    `gorm:"column:total_fee;not null;comment:订单总金额（分）"`
	FeeType       string `gorm:"column:fee_type;type:varchar(10);default:'CNY';comment:货币类型"`
	Body          string `gorm:"column:body;type:varchar(128);not null;comment:商品描述"`
	Detail        string `gorm:"column:detail;type:varchar(1024);comment:商品详情（JSON格式）"`
	Attach        string `gorm:"column:attach;type:varchar(127);comment:附加数据"`
	Status        int8   `gorm:"column:status;type:tinyint;default:0;comment:订单状态：0-待支付，1-支付成功，2-已关闭，3-已退款"`
	//CreateTime    time.Time `gorm:"column:create_time;type:datetime;not null;index;comment:订单创建时间"`
	PayTime    time.Time `gorm:"column:pay_time;type:datetime;comment:支付时间"`
	ExpireTime time.Time `gorm:"column:expire_time;type:datetime;comment:订单过期时间"`
	EndTime    time.Time `gorm:"column:end_time;type:datetime;comment:交易完成时间"`
	PayType    string    `gorm:"column:pay_type;type:varchar(20);comment:支付方式（JSAPI/APP/NATIVE）"`
	NotifyData string    `gorm:"column:notify_data;type:text;comment:支付结果通知完整内容"`
	RefundFee  int       `gorm:"column:refund_fee;default:0;comment:退款金额（分）"`
	//IsDeleted     int8      `gorm:"column:is_deleted;type:tinyint;default:0;comment:是否删除（0-未删除，1-已删除）"`

	ExtraField1 string `gorm:"column:extra_field1;type:varchar(255)" json:"extra_field1"` // 扩展字段
}

// 返回：字符串类型，表示表名
func (BsOrders) TableName() string {
	return "bs_orders"
}
