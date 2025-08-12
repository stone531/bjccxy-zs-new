package common

type ClearDB struct {
	TableName    string
	CompareField string
	Interval     string
}

type WeiChatType_Type int

const (
	Graduschool_ZhengShu WeiChatType_Type = iota
	Training_ZhengShu
)

type WeiChatPay_TotalFee int

const (
	Graduschool_TotalFee WeiChatPay_TotalFee = 50000
	Training_TotalFee    WeiChatPay_TotalFee = 20000
)
