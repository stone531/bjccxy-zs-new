package initialize

import (
	"net/http"
	"os"

	"github.com/flipped-aurora/gin-vue-admin/server/docs"
	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/middleware"
	"github.com/flipped-aurora/gin-vue-admin/server/router"
	"github.com/gin-gonic/gin"
	swaggerFiles "github.com/swaggo/files"
	ginSwagger "github.com/swaggo/gin-swagger"
)

type justFilesFilesystem struct {
	fs http.FileSystem
}

func (fs justFilesFilesystem) Open(name string) (http.File, error) {
	f, err := fs.fs.Open(name)
	if err != nil {
		return nil, err
	}

	stat, err := f.Stat()
	if stat.IsDir() {
		return nil, os.ErrPermission
	}

	return f, nil
}

// 初始化总路由

func Routers() *gin.Engine {
	Router := gin.New()
	Router.Use(gin.Recovery())
	if gin.Mode() == gin.DebugMode {
		Router.Use(gin.Logger())
	}

	// 注册 MCP SSE 服务
	sseServer := McpRun()
	Router.GET(global.GVA_CONFIG.MCP.SSEPath, func(c *gin.Context) {
		sseServer.SSEHandler().ServeHTTP(c.Writer, c.Request)
	})
	Router.POST(global.GVA_CONFIG.MCP.MessagePath, func(c *gin.Context) {
		sseServer.MessageHandler().ServeHTTP(c.Writer, c.Request)
	})

	systemRouter := router.RouterGroupApp.System
	exampleRouter := router.RouterGroupApp.Example
	businessRouter := router.RouterGroupApp.Business
	studentRouter := router.RouterGroupApp.Student

	// 静态文件托管
	Router.StaticFS(global.GVA_CONFIG.Local.StorePath,
		justFilesFilesystem{http.Dir(global.GVA_CONFIG.Local.StorePath)})

	// Swagger 文档
	docs.SwaggerInfo.BasePath = global.GVA_CONFIG.System.RouterPrefix
	Router.GET(global.GVA_CONFIG.System.RouterPrefix+"/swagger/*any", ginSwagger.WrapHandler(swaggerFiles.Handler))

	// 公共组
	PublicGroup := Router.Group(global.GVA_CONFIG.System.RouterPrefix)

	// 管理员私有组
	PrivateGroup := Router.Group(global.GVA_CONFIG.System.RouterPrefix)
	PrivateGroup.Use(middleware.JWTAuth()).Use(middleware.CasbinHandler())

	// 学生私有组
	StudentPrivateGroup := Router.Group(global.GVA_CONFIG.System.RouterPrefix)
	StudentPrivateGroup.Use(middleware.JWTStudentAuthMiddleware())

	// 健康检查
	PublicGroup.GET("/health", func(c *gin.Context) {
		c.JSON(http.StatusOK, "ok")
	})

	// 系统公共路由
	systemRouter.InitBaseRouter(PublicGroup)
	systemRouter.InitInitRouter(PublicGroup)

	// 系统私有路由（管理员）
	systemRouter.InitApiRouter(PrivateGroup, PublicGroup)
	systemRouter.InitJwtRouter(PrivateGroup)
	systemRouter.InitUserRouter(PrivateGroup)
	systemRouter.InitMenuRouter(PrivateGroup)
	systemRouter.InitSystemRouter(PrivateGroup)
	systemRouter.InitCasbinRouter(PrivateGroup)
	systemRouter.InitAutoCodeRouter(PrivateGroup, PublicGroup)
	systemRouter.InitAuthorityRouter(PrivateGroup)
	systemRouter.InitSysDictionaryRouter(PrivateGroup)
	systemRouter.InitAutoCodeHistoryRouter(PrivateGroup)
	systemRouter.InitSysOperationRecordRouter(PrivateGroup)
	systemRouter.InitSysDictionaryDetailRouter(PrivateGroup)
	systemRouter.InitAuthorityBtnRouterRouter(PrivateGroup)
	systemRouter.InitSysExportTemplateRouter(PrivateGroup, PublicGroup)
	systemRouter.InitSysParamsRouter(PrivateGroup, PublicGroup)

	// 示例模块
	exampleRouter.InitCustomerRouter(PrivateGroup)
	exampleRouter.InitFileUploadAndDownloadRouter(PrivateGroup)
	exampleRouter.InitAttachmentCategoryRouterRouter(PrivateGroup)
	exampleRouter.InitDemoRecordRouter(PrivateGroup)

	// 业务模块（管理员）
	//businessRouter.InitBsZhengshuRouter(PrivateGroup)
	businessRouter.InitBsZhengshuRouter(PublicGroup, PrivateGroup)

	businessRouter.InitBsTrainingRouter(PublicGroup, PrivateGroup)

	// 学生模块
	studentRouter.InitBsStudentsRouter(PublicGroup, StudentPrivateGroup)

	// 插件路由
	InstallPlugin(PrivateGroup, PublicGroup, Router)

	// 业务路由注册
	initBizRouter(PrivateGroup, PublicGroup)

	global.GVA_ROUTERS = Router.Routes()
	global.GVA_LOG.Info("router register success")
	return Router
}
