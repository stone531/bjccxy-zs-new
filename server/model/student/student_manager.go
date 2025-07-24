package student

import (
	"time"

	"github.com/flipped-aurora/gin-vue-admin/server/global"

	common "github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
)

type bs_students struct {
	global.GVA_MODEL
	UserAccount               string    `gorm:"column:useraccount;type:varchar(50);not null;default:''" json:"useraccount"`//登录账号
	Name               string    `gorm:"column:name;type:varchar(50);not null;default:''" json:"name"`

	IDCardNumber    string `gorm:"column:id_card_number;type:varchar(20);not null" json:"id_card_number"` // 身份证号
	Bind          int8   `gorm:"column:bind;type:tinyint(1);not null" json:"bind"`                  // 绑定

	ExtraField1     string `gorm:"column:extra_field1;type:varchar(255)" json:"extra_field1"`             // 扩展字段
}

type Zhengshu interface {
	GetUsername() string
	GetNickname() string
	GetUserId() uint
}

//var _ ZhengShu = new(BsZhengshu)

func (BsZhengshu) TableName() string {
	return "bs_students"
}

func (s *BsZhengshu) GetUsername() string {
	return s.Name
}

func (s *BsZhengshu) GetNickname() string {
	return s.Name
}

func (s *BsZhengshu) GetUserId() uint {
	return s.ID
}

type GetUserList struct {
	common.PageInfo
	Name               string `json:"name" form:"name"`
	Sex                string `json:"sex" form:"sex"`
	NativePlace        string `json:"nativeplace" form:"nativeplace"`
	CertificateNumber2 string `json:"certificatenumber2" form:"certificatenumber2"`
	Graduschool        string `json:"graduschool" form:"graduschool"`
	Date               string `json:"date" form:"date"`
	Editer             string `json:"editer" form:"editer"`
}
