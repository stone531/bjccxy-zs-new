package student

import (
	"github.com/flipped-aurora/gin-vue-admin/server/global"
)

type BsStudents struct {
	global.GVA_MODEL
	UserAccount      string `gorm:"column:useraccount;type:varchar(50);not null;default:''" json:"usera_ccount"` //登录账号
	Name             string `gorm:"column:name;type:varchar(50);not null;default:''" json:"name"`
	PassWord         string `gorm:"column:password;type:varchar(50);not null;default:''" json:"password"`
	Email            string `gorm:"column:email;type:varchar(50);not null;default:''" json:"email"`
	VerificationCode string `gorm:"column:verificationcode;type:varchar(50);not null;default:''" json:"verification_code"`

	IDCardNumber string `gorm:"column:id_card_number;type:varchar(20);not null" json:"id_card_number"` // 身份证号
	BindId       int8   `gorm:"column:bindid;type:tinyint(1);not null" json:"bind_id"`                 // 绑定证书的Id

	ExtraField1 string `gorm:"column:extra_field1;type:varchar(255)" json:"extra_field1"` // 扩展字段
	ExtraField2 string `gorm:"column:extra_field2;type:varchar(255)" json:"extra_field2"` // 扩展字段
}

//var _ ZhengShu = new(BsZhengshu)

func (BsStudents) TableName() string {
	return "bs_students"
}

func (s *BsStudents) GetUsername() string {
	return s.Name
}

func (s *BsStudents) GetNickname() string {
	return s.Name
}

func (s *BsStudents) GetUserId() uint {
	return s.ID
}
