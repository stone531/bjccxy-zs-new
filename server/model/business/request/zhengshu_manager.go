package request

//import "time"
import (
	"github.com/flipped-aurora/gin-vue-admin/server/global"
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

/*type GetUserList struct {
	common.PageInfo
	Name               string    `json:"name" form:"name"`
	Sex                int8      `json:"sex"`                 //性别
	NativePlace        string    ` json:"nativeplace"`        //籍贯
	CertificateNumber2 string    ` json:"certificatenumber2"` //身份证号
	Editer             string    ` json:"editer"`             //录入人员
	Date               time.Time `json:"date"`                //日期
}*/

type GetUserList struct {
	common.PageInfo
	Name               string `json:"name" form:"name"`
	Sex                string `json:"sex" form:"sex"`
	NativePlace        string `json:"nativeplace" form:"nativeplace"`
	CertificateNumber2 string `json:"certificatenumber2" form:"certificatenumber2"`
	Graduschool        string `json:"graduschool" form:"graduschool"`
	SDate              string `json:"sdate" form:"sdate"`
	EDate              string `json:"edate" form:"edate"`
	Editer             string `json:"editer" form:"editer"`
}

type BsZhegnshuOneSearch struct {
	//global.GVA_MODEL
	ID                 uint   `json:"ID" form:"ID"`
	Name               string `json:"name" form:"name"`
	Graduschool        string `json:"graduschool" form:"graduschool"`
	CertificateNumber2 string `json:"certificatenumber2" form:"certificatenumber2"`
}

type GetById struct {
}

type ChangeZhengShuInfo struct {
	global.GVA_MODEL
	//ID                 uint   `gorm:"primarykey"`                                                   // 主键ID
	Name               string `gorm:"column:name;type:varchar(50);not null;default:''" json:"name"` // 用户昵称
	Age                string `gorm:"column:age;type:varchar(200);not null;default:'0'" json:"age"` // 用户手机号
	Sex                int8   `gorm:"column:sex;type:tinyint(1);not null;default:1" json:"sex"`
	Mingzhu            string `gorm:"column:mingzhu;type:varchar(10);not null;default:'0'" json:"mingzhu"` // 角色ID
	Pic                string `gorm:"column:pic;type:varchar(200)" json:"pic"`                             // 用户邮箱
	NativePlace        string `gorm:"column:nativeplace;type:varchar(50);not null;default:'1'" json:"nativeplace"`
	Bysj               string `gorm:"column:bysj;type:varchar(100);default:'0'" json:"bysj"` // 用户侧边主题
	Zhuanye            string `gorm:"column:zhuanye;type:varchar(100);default:'0'" json:"zhuanye"`
	CertificateNumber2 string `gorm:"column:certificatenumber2;type:varchar(200);not null;default:'1212'" json:"certificatenumber2"`
}
