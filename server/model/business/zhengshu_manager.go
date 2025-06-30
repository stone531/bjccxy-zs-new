package business

import (
	"time"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
)

type BsZhengshu struct {
	global.GVA_MODEL
	Name               string    `gorm:"column:name;type:varchar(50);not null;default:''" json:"name"`
	Sex                int8      `gorm:"column:sex;type:tinyint(1);not null;default:1" json:"sex"`
	Age                string    `gorm:"column:age;type:varchar(200);not null;default:'0'" json:"age"`
	Pic                string    `gorm:"column:pic;type:varchar(200)" json:"pic"`
	Mingzhu            string    `gorm:"column:mingzhu;type:varchar(10);not null;default:'0'" json:"mingzhu"`
	NativePlace        string    `gorm:"column:nativeplace;type:varchar(50);not null;default:'1'" json:"nativeplace"`
	Zzmm               string    `gorm:"column:zzmm;type:varchar(100)" json:"zzmm"`
	Chengchi           string    `gorm:"column:chengchi;type:varchar(100)" json:"chengchi"`
	CertificateNumber2 string    `gorm:"column:certificatenumber2;type:varchar(200);not null;default:'1212'" json:"certificatenumber2"`
	Zhuanye            string    `gorm:"column:zhuanye;type:varchar(100);default:'0'" json:"zhuanye"`
	Graduschool        string    `gorm:"column:graduschool;type:varchar(200);not null;default:'0'" json:"graduschool"`
	Graduschool2       string    `gorm:"column:graduschool2;type:varchar(200);default:'0'" json:"graduschool2"`
	Bysj               string    `gorm:"column:bysj;type:varchar(100);default:'0'" json:"bysj"`
	Zwjd               string    `gorm:"column:zwjd;type:varchar(200);not null;default:''" json:"zwjd"`
	Demo               string    `gorm:"column:demo;type:mediumtext;not null" json:"demo"`
	Editer             string    `gorm:"column:editer;type:varchar(20);not null;default:''" json:"editer"`
	Date               time.Time `gorm:"column:date;type:date;not null;default:'0000-00-00'" json:"date"`
	Publish            string    `gorm:"column:publish;type:varchar(10);default:'yes'" json:"publish"`
	Operation          string    `gorm:"column:operation;type:varchar(256)" json:"operation"`
}

type Zhengshu interface {
	GetUsername() string
	GetNickname() string
	GetUserId() uint
}

//var _ ZhengShu = new(BsZhengshu)

func (BsZhengshu) TableName() string {
	return "bs_zhengshu"
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
