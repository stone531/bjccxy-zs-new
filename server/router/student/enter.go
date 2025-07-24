package student

import (
	api "github.com/flipped-aurora/gin-vue-admin/server/api/v1"
)

type RouterGroup struct {
	BsStudentRouter
}

var (
	BsStudentApi = api.ApiGroupApp.BsStudentApiGroup.BsStudentApi
)
