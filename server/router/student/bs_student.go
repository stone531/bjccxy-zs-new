package student

import (
	"github.com/gin-gonic/gin"
)

type BsStudentRouter struct{}

func (e *BsStudentRouter) InitBsStudentsRouter(Router *gin.RouterGroup) {
	BsStudentRouter := Router.Group("student")
	{
		BsStudentRouter.POST("create", BsStudentApi.CreateBsStudent) //创建       //查询一个证书信息
		BsStudentRouter.POST("sendEmailCode", BsStudentApi.RegSendEmail)
	}
}
