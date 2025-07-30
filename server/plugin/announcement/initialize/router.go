package initialize

import (
	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/middleware"
	"github.com/flipped-aurora/gin-vue-admin/server/plugin/announcement/router"
	"github.com/gin-gonic/gin"
)

func Router(engine *gin.Engine) {
	public := engine.Group(global.GVA_CONFIG.System.RouterPrefix).Group("")
	private := engine.Group(global.GVA_CONFIG.System.RouterPrefix).Group("")
	private.Use(middleware.JWTAuth()).Use(middleware.CasbinHandler())

	// 学生私有路由组
	studentPrivate := engine.Group(global.GVA_CONFIG.System.RouterPrefix)
	studentPrivate.Use(middleware.JWTStudentAuthMiddleware())

	router.Router.Info.Init(public, private)
	// 注册 admin 路由
}
