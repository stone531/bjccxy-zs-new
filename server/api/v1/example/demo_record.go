package example

import (
	"github.com/flipped-aurora/gin-vue-admin/server/global"
	//"gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/response"
	"github.com/flipped-aurora/gin-vue-admin/server/model/example"
	"github.com/flipped-aurora/gin-vue-admin/server/model/example/request"

	//demoRecordRes "github.com/flipped-aurora/gin-vue-admin/server/model/example/response"

	"github.com/gin-gonic/gin"
)

type DemoRecordApi struct{}

// CreateDemoRecord
func (api *DemoRecordApi) CreateDemoRecord(c *gin.Context) {
	var req request.DemoRecordRequest
	global.GVA_LOG.Info("CreateDemoRecord 001")
	if err := c.ShouldBindJSON(&req); err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}

	record := example.DemoRecord{
		Title:   req.Title,
		Content: req.Content,
	}

	if err := global.GVA_DB.Create(&record).Error; err != nil {
		response.FailWithMessage("create fail", c)
		return
	}

	response.OkWithData(gin.H{"id": record.ID}, c)
}

// GetDemoRecordList
func (api *DemoRecordApi) GetDemoRecordList(c *gin.Context) {
	var pageInfo request.DemoRecordSearch
	if err := c.ShouldBindQuery(&pageInfo); err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}

	var records []example.DemoRecord
	db := global.GVA_DB.Model(&example.DemoRecord{})

	if pageInfo.Title != "" {
		db = db.Where("title LIKE ?", "%"+pageInfo.Title+"%")
	}

	if err := db.Find(&records).Error; err != nil {
		response.FailWithMessage("query fail", c)
		return
	}

	response.OkWithData(records, c)
}
