package business

import (
	api "github.com/flipped-aurora/gin-vue-admin/server/api/v1"
)

type RouterGroup struct {
	BsZhengshuRouter
	BsTrainingRouter
}

var (
	BsZhengShuApi = api.ApiGroupApp.BsZhengshuApiGroup.BsZhengShuApi
	BsTrainingApi = api.ApiGroupApp.BsZhengshuApiGroup.BsTrainingApi
)
