package student

import (
	"github.com/flipped-aurora/gin-vue-admin/server/global"

	//"gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/response"
	"github.com/flipped-aurora/gin-vue-admin/server/model/student"
	"github.com/flipped-aurora/gin-vue-admin/server/model/student/request"

	//"github.com/flipped-aurora/gin-vue-admin/server/utils"

	//demoRecordRes "github.com/flipped-aurora/gin-vue-admin/server/model/example/response"

	"github.com/gin-gonic/gin"
)

type BsStudentApi struct{}

// CreateDemoRecord
func (api *BsStudentApi) CreateBsStudent(c *gin.Context) {
	var req request.AddStudent
	global.GVA_LOG.Info("CreateBsTraining 001")
	if err := c.ShouldBindJSON(&req); err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}

	//now := time.Now()
	//currentDate := time.Date(now.Year(), now.Month(), now.Day(), 0, 0, 0, 0, now.Location())

	record := student.BsStudents{
		Name:             req.Name,
		UserAccount:      req.UserAccount,
		IDCardNumber:     req.IDCardNumber,
		PassWord:         req.PassWord,
		Email:            req.Email,
		VerificationCode: req.VerificationCode,
		BindId:           req.BindId,
		ExtraField1:      req.ExtraField1,
		ExtraField2:      req.ExtraField2,
	}

	if err := global.GVA_DB.Create(&record).Error; err != nil {
		response.FailWithMessage("create fail", c)
		return
	}

	response.OkWithData(gin.H{"id": record.ID}, c)
}

// GetDemoRecordList
/*func (api *BsStudentApi) GetBsSearchTrainingList(c *gin.Context) {
	var pageInfo request.GetBsTrainingStuList

	err := c.ShouldBindJSON(&pageInfo)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	fmt.Println("GetBsSearchTrainingList:", pageInfo)

	//fmt.Println("GetBsSearchTrainingList 01:", pageInfo)

	list, total, err := api.GetTrainingInfoList(pageInfo)
	if err != nil {
		global.GVA_LOG.Error("获取失败!", zap.Error(err))
		response.FailWithMessage("获取失败", c)
		return
	}
	response.OkWithDetailed(response.PageResult{
		List:     list,
		Total:    total,
		Page:     pageInfo.Page,
		PageSize: pageInfo.PageSize,
	}, "获取成功", c)
}*/
