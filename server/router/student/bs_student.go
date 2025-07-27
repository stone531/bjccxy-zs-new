package student

import (
	"github.com/gin-gonic/gin"
)

type BsStudentRouter struct{}

func (e *BsStudentRouter) InitBsStudentsRouter(Router *gin.RouterGroup) {
	BsStudentRouter := Router.Group("student")
	{
		BsStudentRouter.POST("register", BsStudentApi.CreateBsStudent) //创建       //查询一个证书信息
		BsStudentRouter.POST("sendEmailCode", BsStudentApi.RegSendEmail)
		BsStudentRouter.POST("initPassword", BsStudentApi.InitPassword)
		BsStudentRouter.POST("login", BsStudentApi.Login)
		BsStudentRouter.POST("getInfo", BsStudentApi.GetUserInfo)
	}
}
