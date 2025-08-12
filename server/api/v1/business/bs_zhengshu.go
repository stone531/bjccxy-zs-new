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
	"github.com/flipped-aurora/gin-vue-admin/server/utils"

	//demoRecordRes "github.com/flipped-aurora/gin-vue-admin/server/model/example/response"

	"github.com/gin-gonic/gin"
)

type BsZhengShuApi struct{}

// CreateDemoRecord
func (api *BsZhengShuApi) CreateBsZhengshu(c *gin.Context) {
	var req request.AddUser
	global.GVA_LOG.Info("BsZhengShuApi 001")
	if err := c.ShouldBindJSON(&req); err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}

	//check idcard
	ok, _ := api.CheckIDCardExists(req.CertificateNumber2)
	if ok {
		response.FailWithMessage("exit the same CertificateNumber2 ", c)
		return
	}

	now := time.Now()
	currentDate := time.Date(now.Year(), now.Month(), now.Day(), 0, 0, 0, 0, now.Location())

	record := business.BsZhengshu{
		Name:               req.Name,
		Age:                req.Age,
		Sex:                req.Sex,
		Mingzhu:            req.Mingzhu,
		Pic:                req.Pic,
		NativePlace:        req.NativePlace,
		Zzmm:               req.Zzmm,
		Chengchi:           req.Chengchi,
		CertificateNumber2: req.CertificateNumber2,
		Zhuanye:            req.Zhuanye,
		Graduschool:        bsZhengshuService.GetNextGraduschoolNumber(),
		Graduschool2:       req.Graduschool2,
		Bysj:               req.Bysj,
		Zwjd:               req.Zwjd,
		Demo:               req.Demo,
		Editer:             req.Editer,
		Date:               currentDate,
		Publish:            "yes",
	}

	if err := global.GVA_DB.Create(&record).Error; err != nil {
		response.FailWithMessage("create fail", c)
		return
	}

	response.OkWithData(gin.H{"id": record.ID}, c)
}

// GetDemoRecordList
func (api *BsZhengShuApi) GetBsSearchZhengshuList(c *gin.Context) {
	var pageInfo request.GetUserList

	err := c.ShouldBindJSON(&pageInfo)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	fmt.Println("GetBsSearchZhengshuList00:", pageInfo)
	err = utils.Verify(pageInfo, utils.PageInfoVerify)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	fmt.Println("GetBsSearchZhengshuList01:", pageInfo)

	list, total, err := bsZhengshuService.GetUserInfoList(pageInfo)
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

func (api *BsZhengShuApi) GetOneBsZhengshu(c *gin.Context) {

	var reqInfo request.BsZhegnshuOneSearch
	if err := c.ShouldBindJSON(&reqInfo); err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}

	var record business.BsZhengshu
	db := global.GVA_DB.Model(&business.BsZhengshu{})

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
	} else if reqInfo.Graduschool != "" && reqInfo.Name != "" {
		if err := db.Where("graduschool = ? AND name = ?", reqInfo.Graduschool, reqInfo.Name).
			First(&record).Error; err != nil {
			if errors.Is(err, gorm.ErrRecordNotFound) {
				response.FailWithMessage("记录不存在", c)
			} else {
				response.FailWithMessage("查询失败: "+err.Error(), c)
			}
			return
		}
	} else if reqInfo.CertificateNumber2 != "" && reqInfo.Name != "" {
		if err := db.Where("certificatenumber2 = ? AND name = ?", reqInfo.CertificateNumber2, reqInfo.Name).
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

	response.OkWithData(record, c)
}

func (api *BsZhengShuApi) DelZhengshuById(c *gin.Context) {
	var reqId cReq.GetById
	fmt.Println("enter DelZhengshuById:")
	err := c.ShouldBindJSON(&reqId)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	fmt.Println("DelZhengshuById id:%d:", reqId.ID)

	err = bsZhengshuService.DeleteUser(reqId.ID)
	if err != nil {
		global.GVA_LOG.Error("删除失败!", zap.Error(err))
		response.FailWithMessage("删除失败", c)
		return
	}
	response.OkWithMessage("删除成功", c)
}

func (api *BsZhengShuApi) SetZhengshuInfo(c *gin.Context) {
	var user request.ChangeZhengShuInfo
	err := c.ShouldBindJSON(&user)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	fmt.Println("SetZhengshuInfo user:", user)

	err = utils.Verify(user, utils.IdVerify)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}

	err = bsZhengshuService.SetZhengShuInfo(request.ChangeZhengShuInfo{
		GVA_MODEL: global.GVA_MODEL{
			ID: user.ID,
		},
		Name:               user.Name,
		Pic:                user.Pic,
		Age:                user.Age,
		Bysj:               user.Bysj,
		Sex:                user.Sex,
		Mingzhu:            user.Mingzhu,
		NativePlace:        user.NativePlace,
		Zhuanye:            user.Zhuanye,
		CertificateNumber2: user.CertificateNumber2,
	})
	if err != nil {
		global.GVA_LOG.Error("设置失败!", zap.Error(err))
		response.FailWithMessage("设置失败", c)
		return
	}
	response.OkWithMessage("设置成功", c)
}

func (api *BsZhengShuApi) CheckIDCardExists(idCard string) (bool, error) {
	var count int64
	err := global.GVA_DB.Model(&business.BsZhengshu{}).
		Where("CertificateNumber2 = ?", idCard).
		Count(&count).Error

	if err != nil {
		return false, err
	}
	return count > 0, nil
}
