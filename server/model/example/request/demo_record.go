package request

import (
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/request"
)

type DemoRecordSearch struct {
	Title string `json:"title" form:"title"`
	request.PageInfo
}

type DemoRecordRequest struct {
	ID      uint   `json:"id"`
	Title   string `json:"title" binding:"required"`
	Content string `json:"content"`
}
