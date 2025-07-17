package business

import (
	//"time"
	"github.com/flipped-aurora/gin-vue-admin/server/global"

	common "github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
)

type BsTrainingStudent struct {
	global.GVA_MODEL
	Name            string `gorm:"column:name;type:varchar(50);not null" json:"name"`                     // 姓名
	Gender          int8   `gorm:"column:gender;type:tinyint(1);not null" json:"gender"`                  // 性别
	IDCardNumber    string `gorm:"column:id_card_number;type:varchar(20);not null" json:"id_card_number"` // 身份证号
	CertificateName string `gorm:"column:certificate_name;type:varchar(500)" json:"certificate_name"`     // 证书名称
	CertificateID   string `gorm:"column:certificate_id;type:varchar(80)" json:"certificate_id"`          // 证书编号
	IssueDate       string `gorm:"column:issue_date;type:varchar(100)" json:"issue_date"`                 // 发证日期
	TrainingProgram string `gorm:"column:training_program;type:varchar(800)" json:"training_program"`     // 培训项目
	Grade           string `gorm:"column:grade;type:varchar(20)" json:"grade"`                            // 成绩
	Editer          string `gorm:"column:editer;type:varchar(20);not null;default:''" json:"editer"`      // 录入者
	ExtraField1     string `gorm:"column:extra_field1;type:varchar(255)" json:"extra_field1"`             // 扩展字段

}

// TableName čŽžç˝ŽčĄ¨ĺ
func (BsTrainingStudent) TableName() string {
	return "bs_training_students"
}

type GetBsTrainingStuList struct {
	common.PageInfo
	Name            string `json:"name" form:"name"`
	Gender          int8   `json:"gender" form:"gender"`
	IDCardNumber    string `json:"id_card_number" form:"id_card_number"`      // 身份证号
	CertificateName string ` json:"certificate_name" form:"certificate_name"` // 培训名称
	CertificateID   string `json:"certificate_id" form:"certificate_id"`      // 证书编号
	IssueDate       string `json:"issue_date" form:"issue_date"`              // 发证日期
	TrainingProgram string `json:"training_program" form:"training_program"`  // 录入人
	Editer          string `json:"editer" form:"editer"`
}
