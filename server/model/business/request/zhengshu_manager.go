package request

//import "time"
import (
	"time"

	common "github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
	//"github.com/flipped-aurora/gin-vue-admin/server/model/business"
)

type AddUser struct {
	Name               string `json:"name"`
	Sex                int8   `json:"sex"`
	Age                string `json:"age"`
	Pic                string `json:"pic"`
	Mingzhu            string `json:"mingzhu"`
	NativePlace        string `json:"nativeplace"`
	Zzmm               string `json:"zzmm"`
	Chengchi           string `json:"chengchi"`
	CertificateNumber2 string `json:"certificatenumber2"`
	Zhuanye            string `json:"zhuanye"`
	Graduschool        string `json:"graduschool"`
	Graduschool2       string `json:"graduschool2"`
	Bysj               string `json:"bysj"`
	Zwjd               string `json:"zwjd"`
	Demo               string `json:"demo"`
	Editer             string `json:"editer"`
	//Date               time.Time `json:"date"`
	Publish string `json:"publish"`
}

type GetUserList struct {
	common.PageInfo
	Name               string    `json:"name" form:"name"`
	Sex                int8      `json:"sex"`                 //性别
	NativePlace        string    ` json:"nativeplace"`        //籍贯
	CertificateNumber2 string    ` json:"certificatenumber2"` //身份证号
	Editer             string    ` json:"editer"`             //录入人员
	Date               time.Time `json:"date"`                //日期
}

type BsZhegnshuSearch struct {
	Name        string    `json:"name"`
	Graduschool string    `json:"graduschool"`
	SDate       time.Time `json:"sdate"`
	EDate       time.Time `json:"edate"`
	Editer      string    `json:"editer"`
	common.PageInfo
}

type GetById struct {
}
