package business

import (
	"errors"
	"fmt"
	"time"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"go.uber.org/zap"
	"gorm.io/gorm"

	//"gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/business"
	"github.com/flipped-aurora/gin-vue-admin/server/model/business/request"
	cReq "github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/response"

	//"github.com/flipped-aurora/gin-vue-admin/server/utils"

	//demoRecordRes "github.com/flipped-aurora/gin-vue-admin/server/model/example/response"

	"github.com/gin-gonic/gin"
)

type BsTrainingApi struct{}

// CreateDemoRecord
func (api *BsTrainingApi) CreateBsTraining(c *gin.Context) {
	var req request.AddTrainingStu
	global.GVA_LOG.Info("CreateBsTraining 001")
	if err := c.ShouldBindJSON(&req); err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}

	//check idcard
	ok, _ := api.CheckIDCardExists(req.IDCardNumber)
	if ok {
		response.FailWithMessage("exit the same CertificateNumber2 ", c)
		return
	}

	//now := time.Now()
	//currentDate := time.Date(now.Year(), now.Month(), now.Day(), 0, 0, 0, 0, now.Location())
	record := business.BsTrainingStudent{
		Name:            req.Name,
		Gender:          req.Gender,
		IDCardNumber:    req.IDCardNumber,
		CertificateName: req.CertificateName,
		CertificateID:   bsZhengshuService.GetNextTrainingGraduschoolNumber(),
		IssueDate:       req.IssueDate,
		TrainingProgram: req.TrainingProgram,
		Grade:           req.Grade,
		Editer:          req.Editer,
		ExtraField1:     "yes",
	}

	if err := global.GVA_DB.Create(&record).Error; err != nil {
		response.FailWithMessage("create fail", c)
		return
	}

	response.OkWithData(gin.H{"id": record.ID}, c)
}

// GetDemoRecordList
func (api *BsTrainingApi) GetBsSearchTrainingList(c *gin.Context) {
	var pageInfo request.GetBsTrainingStuList

	err := c.ShouldBindJSON(&pageInfo)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	fmt.Println("GetBsSearchTrainingList:", pageInfo)
	/*err = utils.Verify(pageInfo, utils.PageInfoVerify)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}*/
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
}

func (api *BsTrainingApi) GetOneBsTraining(c *gin.Context) {

	var reqInfo request.BsTrainingStuOneSearch
	if err := c.ShouldBindJSON(&reqInfo); err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}

	var record business.BsTrainingStudent
	db := global.GVA_DB.Model(&business.BsTrainingStudent{})

	// 根据不同条件构建查询
	if reqInfo.ID != 0 {
		if err := db.Where("id = ?", reqInfo.ID).First(&record).Error; err != nil {
			if errors.Is(err, gorm.ErrRecordNotFound) {
				response.FailWithMessage("记录不存在", c)
			} else {
				response.FailWithMessage("查询失败: "+err.Error(), c)
			}
			return
		}
	} else if reqInfo.CertificateID != "" && reqInfo.Name != "" {
		if err := db.Where("certificate_id = ? AND name = ?", reqInfo.CertificateID, reqInfo.Name).
			First(&record).Error; err != nil {
			if errors.Is(err, gorm.ErrRecordNotFound) {
				response.FailWithMessage("记录不存在", c)
			} else {
				response.FailWithMessage("查询失败: "+err.Error(), c)
			}
			return
		}
	} else if reqInfo.IDCardNumber != "" && reqInfo.Name != "" {
		if err := db.Where("id_card_number = ? AND name = ?", reqInfo.IDCardNumber, reqInfo.Name).
			First(&record).Error; err != nil {
			if errors.Is(err, gorm.ErrRecordNotFound) {
				response.FailWithMessage("记录不存在", c)
			} else {
				response.FailWithMessage("查询失败: "+err.Error(), c)
			}
			return
		}
	} else {
		response.FailWithMessage("请提供查询条件(ID 或 Graduschool+Name)", c)
		return
	}

	if record.ExtraField1 != "yes" {
		response.FailWithMessage("请您及时支付", c)
		return
	}

	response.OkWithData(record, c)
}

func (api *BsTrainingApi) DelTrainingById(c *gin.Context) {
	var reqId cReq.GetById
	fmt.Println("enter DelTrainingById")
	err := c.ShouldBindJSON(&reqId)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	fmt.Println("DelTrainingById id:%:", reqId.ID)

	/*err = bsZhengshuService.DeleteUser(reqId.ID)
	if err != nil {
		global.GVA_LOG.Error("删除失败!", zap.Error(err))
		response.FailWithMessage("删除失败", c)
		return
	}*/

	err = global.GVA_DB.Transaction(func(tx *gorm.DB) error {
		if err = tx.Where("ID = ?", reqId.ID).Delete(&business.BsTrainingStudent{}).Error; err != nil {
			return err
		}
		return nil
	})

	if err != nil {
		global.GVA_LOG.Error("删除失败!", zap.Error(err))
		response.FailWithMessage("删除失败", c)
		return
	}

	response.OkWithMessage("删除成功", c)
}

func (api *BsTrainingApi) SetTrainingInfo(c *gin.Context) {
	var user request.ChangeTrainingStuInfo
	err := c.ShouldBindJSON(&user)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	fmt.Println("SetTrainingInfo user:", user)

	/*err = utils.Verify(user, utils.IdVerify)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}*/

	err = api.SetZhengShuInfo(request.ChangeTrainingStuInfo{
		GVA_MODEL: global.GVA_MODEL{
			ID: user.ID,
		},
		Name:            user.Name,
		Gender:          user.Gender,
		IDCardNumber:    user.IDCardNumber,
		CertificateName: user.CertificateName,
		CertificateID:   user.CertificateID,
		TrainingProgram: user.TrainingProgram,
		Grade:           user.Grade,
		IssueDate:       user.IssueDate,
	})
	if err != nil {
		global.GVA_LOG.Error("设置失败!", zap.Error(err))
		response.FailWithMessage("设置失败", c)
		return
	}
	response.OkWithMessage("设置成功", c)
}

func (api *BsTrainingApi) CheckIDCardExists(idCard string) (bool, error) {
	var count int64
	err := global.GVA_DB.Model(&business.BsTrainingStudent{}).
		Where("id_card_number = ?", idCard).
		Count(&count).Error

	if err != nil {
		return false, err
	}
	return count > 0, nil
}

func (userService *BsTrainingApi) GetTrainingInfoList(info request.GetBsTrainingStuList) (list interface{}, total int64, err error) {
	limit := info.PageSize
	offset := info.PageSize * (info.Page - 1)
	db := global.GVA_DB.Model(&business.BsTrainingStudent{})
	var userList []business.BsTrainingStudent
	layout := "2006-01-02T15:04:05.000Z"
	loc, _ := time.LoadLocation("Asia/Shanghai")

	fmt.Println("enter GetUserInfoList:", info)
	if info.Name != "" {
		db = db.Where("name LIKE ?", "%"+info.Name+"%")
	}
	if info.CertificateID != "" {
		db = db.Where("certificate_id LIKE ?", "%"+info.CertificateID+"%")
	}
	if info.Editer != "" {
		db = db.Where("editer LIKE ?", "%"+info.Editer+"%")
	}

	if info.SDate != "" {
		//db = db.Where("CreatedAt > ?", "%"+info.SDate+"%")
		t, err := time.Parse(layout, info.SDate)
		if err == nil {
			db = db.Where("created_at >= ?", t.In(loc))
		}
	}
	if info.SDate != "" {
		//db = db.Where("CreatedAt < ?", "%"+info.EDate+"%")
		t, err := time.Parse(layout, info.EDate)
		if err == nil {
			db = db.Where("created_at <= ?", t.In(loc))
		}
	}

	err = db.Count(&total).Error
	if err != nil {
		return
	}

	//err = db.Limit(limit).Offset(offset).Find(&userList).Error
	err = db.Order("created_at desc").Limit(limit).Offset(offset).Find(&userList).Error
	return userList, total, err
}

func (userService *BsTrainingApi) SetZhengShuInfo(req request.ChangeTrainingStuInfo) error {
	return global.GVA_DB.Model(&business.BsTrainingStudent{}).
		Select("updated_at", "name", "gender", "id_card_number", "certificate_name", "certificate_id", "training_program", "grade", "zhuanye", "issue_date").
		Where("id=?", req.ID).
		Updates(map[string]interface{}{
			"updated_at":       time.Now(),
			"name":             req.Name,
			"gender":           req.Gender,
			"id_card_number":   req.IDCardNumber,
			"certificate_name": req.CertificateName,
			"certificate_id":   req.CertificateID,
			"training_program": req.TrainingProgram,
			"grade":            req.Grade,
			"issue_date":       req.IssueDate,
		}).Error
}
