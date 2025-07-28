package student

import (
	"github.com/flipped-aurora/gin-vue-admin/server/middleware"
	"github.com/gin-gonic/gin"
)

type BsStudentRouter struct{}

func (e *BsStudentRouter) InitBsStudentsRouter(Router *gin.RouterGroup) {
	BsStudentPublicRouter := Router.Group("student") // 不需要 token
	{
		BsStudentPublicRouter.POST("register", BsStudentApi.CreateBsStudent)
		BsStudentPublicRouter.POST("sendEmailCode", BsStudentApi.RegSendEmail)
		BsStudentPublicRouter.POST("initPassword", BsStudentApi.InitPassword)
		BsStudentPublicRouter.POST("login", BsStudentApi.Login)
	}

	BsStudentPrivateRouter := Router.Group("student")
	BsStudentPrivateRouter.Use(middleware.JWTStudentAuthMiddleware()) // 需要 token
	{
		BsStudentPrivateRouter.POST("getInfo", BsStudentApi.GetUserInfo)
		// 这里可以放其他需要登录后访问的接口
	}
}
