package student

import "github.com/flipped-aurora/gin-vue-admin/server/service"

type ApiGroup struct {
	BsStudentApi
}

var (
	bsStudentService = service.ServiceGroupApp.StudentServiceGroup.BsStudentService
)
