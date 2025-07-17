package business

import "github.com/flipped-aurora/gin-vue-admin/server/service"

type ApiGroup struct {
	BsZhengShuApi
	BsTrainingApi
}

var (
	bsZhengshuService = service.ServiceGroupApp.BusinessServiceGroup.BsZhengshuService
)
