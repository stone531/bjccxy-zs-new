package business

import (
	//"errors"
	"fmt"
	"time"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	cReq "github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/response"
	"github.com/flipped-aurora/gin-vue-admin/server/model/student"
	"github.com/flipped-aurora/gin-vue-admin/server/model/student/request"
	"github.com/flipped-aurora/gin-vue-admin/server/utils"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
	"gorm.io/gorm"
)

// 获取订单列表
func (api *BsZhengShuApi) GetBsOrderList(c *gin.Context) {
	var pageInfo request.GetOrderList

	err := c.ShouldBindJSON(&pageInfo)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	//fmt.Println("GetBsOrderList01:", pageInfo)
	err = utils.Verify(pageInfo, utils.PageInfoVerify)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	//fmt.Println("GetBsOrderList02:", pageInfo)

	list, total, err := api.getOrderList(pageInfo)
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

func (api *BsZhengShuApi) getOrderList(info request.GetOrderList) (list interface{}, total int64, err error) {
	limit := info.PageSize
	offset := info.PageSize * (info.Page - 1)
	db := global.GVA_DB.Model(&student.BsOrders{})
	var userList []student.BsOrders
	layout := "2006-01-02T15:04:05.000Z"
	loc, _ := time.LoadLocation("Asia/Shanghai")

	userId, err := api.getStudentUserId(info)
	if userId > 0 {
		fmt.Println("GetBsOrderList03:", userId)
		db = db.Where("user_id = ?", userId)
	}

	fmt.Println("enter GetUserInfoList:", info)
	if info.OrderSn != "" {
		db = db.Where("order_sn LIKE ?", "%"+info.OrderSn+"%")
	}
	if info.Status != -1 {
		db = db.Where("status = ?", info.Status)
	}
	if info.CertType != "" {
		db = db.Where("cert_type = ?", info.CertType)
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
	fmt.Println("GetBsOrderList04:", total)
	//err = db.Limit(limit).Offset(offset).Find(&userList).Error
	err = db.Order("created_at desc").Limit(limit).Offset(offset).Find(&userList).Error
	return userList, total, err
}

func (api *BsZhengShuApi) getStudentUserId(info request.GetOrderList) (userId int64, err error) {
	db := global.GVA_DB.Model(&student.BsStudents{})
	var studentUser student.BsStudents

	if info.Name == "" && info.Account == "" && info.IdCardNumber == "" {
		return -1, nil
	}

	if info.Name != "" {
		db = db.Where("name = ?", info.Name)
	}
	if info.Account != "" {
		db = db.Where("useraccount = ?", info.Account)
	}
	if info.IdCardNumber != "" {
		db = db.Where("id_card_number = ?", info.IdCardNumber)
	}

	err = db.Find(&studentUser).Error

	return int64(studentUser.ID), err
}

func (api *BsZhengShuApi) DelOrderById(c *gin.Context) {
	var reqId cReq.GetById
	fmt.Println("enter DelOrderById:")
	err := c.ShouldBindJSON(&reqId)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	fmt.Println("DelOrderById id:%d:", reqId.ID)

	err = api.deleteUser(reqId.ID)
	if err != nil {
		global.GVA_LOG.Error("删除失败!", zap.Error(err))
		response.FailWithMessage("删除失败", c)
		return
	}
	response.OkWithMessage("删除成功", c)
}

func (bzs *BsZhengShuApi) deleteUser(id int) (err error) {
	return global.GVA_DB.Transaction(func(tx *gorm.DB) error {
		if err := tx.Where("ID = ?", id).Delete(&student.BsOrders{}).Error; err != nil {
			return err
		}
		return nil
	})

}
