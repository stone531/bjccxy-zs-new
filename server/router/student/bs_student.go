package student

import (
	//"github.com/flipped-aurora/gin-vue-admin/server/middleware"
	"github.com/gin-gonic/gin"
)

type BsStudentRouter struct{}

func (e *BsStudentRouter) InitBsStudentsRouter(public *gin.RouterGroup, private *gin.RouterGroup) {
	// 公共路由
	BsStudentPublicRouter := public.Group("student")
	{
		BsStudentPublicRouter.POST("register", BsStudentApi.CreateBsStudent)
		BsStudentPublicRouter.POST("sendEmailCode", BsStudentApi.RegSendEmail)
		BsStudentPublicRouter.POST("initPassword", BsStudentApi.InitPassword)
		BsStudentPublicRouter.POST("login", BsStudentApi.Login)
	}

	// 私有路由
	BsStudentPrivateRouter := private.Group("student")
	{
		BsStudentPrivateRouter.GET("getInfo", BsStudentApi.GetUserInfo)
	}
}
