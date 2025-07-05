package business

import (
	"github.com/gin-gonic/gin"
)

type BsZhengshuRouter struct{}

func (e *BsZhengshuRouter) InitBsZhengshuRouter(Router *gin.RouterGroup) {
	BsZhengshuRouter := Router.Group("bszhengshu")
	{
		BsZhengshuRouter.POST("create", BsZhengShuApi.CreateBsZhengshu)           //
		BsZhengshuRouter.POST("getZhengshuList", BsZhengShuApi.GetBsZhengshuList) //
		BsZhengshuRouter.DELETE("delZhengshuById", BsZhengShuApi.DelZhengshuById) // 删除用户
	}
}
