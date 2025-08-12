package request

import (
	common "github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
)

type GetOrderList struct {
	common.PageInfo
	Name         string `json:"name" form:"name"`
	Account      string `json:"useraccount" form:"useraccount"`
	OrderSn      string `json:"OrderSn" form:"OrderSn"`
	IdCardNumber string `json:"id_card_number" form:"id_card_number"`
	Status       int    `json:"status" form:"status"`
	SDate        string `json:"sdate" form:"sdate"`
	EDate        string `json:"edate" form:"edate"`
	CertType     string `json:"certType" form:"certType"`
}
