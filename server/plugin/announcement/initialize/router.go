package initialize

import (
	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/middleware"
	"github.com/flipped-aurora/gin-vue-admin/server/plugin/announcement/router"
	"github.com/gin-gonic/gin"
)

/*func Router(engine *gin.Engine) {
	public := engine.Group(global.GVA_CONFIG.System.RouterPrefix).Group("")
	private := engine.Group(global.GVA_CONFIG.System.RouterPrefix).Group("")
	private.Use(middleware.JWTAuth()).Use(middleware.CasbinHandler())

	// 学生私有路由组
	studentPrivate := engine.Group(global.GVA_CONFIG.System.RouterPrefix)
	studentPrivate.Use(middleware.JWTStudentAuthMiddleware())

	router.Router.Info.Init(public, private)
	// 注册 admin 路由
}*/
func Router(engine *gin.Engine) {

	public := engine.Group(global.GVA_CONFIG.System.RouterPrefix).Group("")

	adminPrivate := engine.Group(global.GVA_CONFIG.System.RouterPrefix).Group("")
	adminPrivate.Use(
		middleware.JWTAuth(),        // 管理员 JWT 校验
		middleware.CasbinHandler(),  // RBAC 权限校验
	)

	studentPrivate := engine.Group(global.GVA_CONFIG.System.RouterPrefix).Group("")
	studentPrivate.Use(
		middleware.JWTStudentAuthMiddleware(), // 学生 JWT 校验
	)

	router.Router.Info.Init(public, adminPrivate) // 原 Info 插件可能是 admin 专用

	// 注册 admin 专用路由
	// adminRouter.InitXXXRouter(adminPrivate)

	// 注册 student 专用路由
	// studentRouter.InitBsStudentsRouter(public, studentPrivate)
}