package business

import "github.com/flipped-aurora/gin-vue-admin/server/service"

type ApiGroup struct {
	BsZhengShuApi
}

var (
	bsZhengshuService = service.ServiceGroupApp.BusinessServiceGroup.BsZhengshuService
)
