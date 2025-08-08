package business

import (
	"github.com/gin-gonic/gin"
)

type BsZhengshuRouter struct{}


func (e *BsZhengshuRouter) InitBsZhengshuRouter(public *gin.RouterGroup, private *gin.RouterGroup) {
	

	// 公共路由
	BsZhengshuPublicRouter := public.Group("bszhengshu")
	{
		BsZhengshuPublicRouter.POST("getOneZhengshu", BsZhengShuApi.GetOneBsZhengshu)         //查询一个证书信息
	}

	// 私有路由
	BsZhengshuPrivateRouter := private.Group("bszhengshu")
	{
		BsZhengshuPrivateRouter.POST("create", BsZhengShuApi.CreateBsZhengshu)                 //创建证书
		BsZhengshuPrivateRouter.POST("getZhengshuList", BsZhengShuApi.GetBsSearchZhengshuList) //查询多个证书信息
		BsZhengshuPrivateRouter.DELETE("delZhengshuById", BsZhengShuApi.DelZhengshuById)       // 删除用户
		BsZhengshuPrivateRouter.PUT("setZhengshuInfo", BsZhengShuApi.SetZhengshuInfo)          // 更新用户
	}
}