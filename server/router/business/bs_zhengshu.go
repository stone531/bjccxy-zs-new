package business

import (
	"github.com/gin-gonic/gin"
)

type BsZhengshuRouter struct{}

func (e *BsZhengshuRouter) InitBsZhengshuRouter(Router *gin.RouterGroup) {
	BsZhengshuRouter := Router.Group("bszhengshu")
	{
		BsZhengshuRouter.POST("create", BsZhengShuApi.CreateBsZhengshu)                 //创建证书
		BsZhengshuRouter.POST("getZhengshuList", BsZhengShuApi.GetBsSearchZhengshuList) //查询多个证书信息
		BsZhengshuRouter.DELETE("delZhengshuById", BsZhengShuApi.DelZhengshuById)       // 删除用户
		BsZhengshuRouter.PUT("setZhengshuInfo", BsZhengShuApi.SetZhengshuInfo)          // 更新用户
		BsZhengshuRouter.POST("getOneZhengshu", BsZhengShuApi.GetOneBsZhengshu)         //查询一个证书信息
	}
}
