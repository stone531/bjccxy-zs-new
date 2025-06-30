package business

import (
	"github.com/flipped-aurora/gin-vue-admin/server/global"
	//"gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/business"
	"github.com/flipped-aurora/gin-vue-admin/server/model/business/request"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/response"

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

	record := business.BsZhengshu{
		Name: req.Name,
		Age:  req.Age,
	}

	if err := global.GVA_DB.Create(&record).Error; err != nil {
		response.FailWithMessage("create fail", c)
		return
	}

	response.OkWithData(gin.H{"id": record.ID}, c)
}

// GetDemoRecordList
func (api *BsZhengShuApi) GetBsZhengshuList(c *gin.Context) {
	var pageInfo request.GetUserList
	if err := c.ShouldBindQuery(&pageInfo); err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}

	var records []business.BsZhengshu
	db := global.GVA_DB.Model(&business.BsZhengshu{})

	if pageInfo.Name != "" {
		db = db.Where("title LIKE ?", "%"+pageInfo.Name+"%")
	}

	if err := db.Find(&records).Error; err != nil {
		response.FailWithMessage("query fail", c)
		return
	}

	response.OkWithData(records, c)
}
