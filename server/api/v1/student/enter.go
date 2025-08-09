package student

import "github.com/flipped-aurora/gin-vue-admin/server/service"

type ApiGroup struct {
	BsStudentApi
}

var (
	jwtService       = service.ServiceGroupApp.SystemServiceGroup.JwtService
	bsStudentService = service.ServiceGroupApp.StudentServiceGroup.BsStudentService
	bsOrderService   = service.ServiceGroupApp.StudentServiceGroup.OrderService
)
