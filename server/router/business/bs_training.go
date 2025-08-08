package business

import (
	"github.com/gin-gonic/gin"
)

type BsTrainingRouter struct{}

func (e *BsTrainingRouter) InitBsTrainingRouter(public *gin.RouterGroup, private *gin.RouterGroup) {
	

	// 公共路由
	BsTrainingPublicRouter := public.Group("bstraining")
	{
		BsTrainingPublicRouter.POST("getOneTraining", BsTrainingApi.GetOneBsTraining)         //查询一个证书信息
	}

	// 私有路由
	BsTrainingPrivateRouter := private.Group("bstraining")
	{
		BsTrainingPrivateRouter.POST("create", BsTrainingApi.CreateBsTraining)                 //创建证书
		BsTrainingPrivateRouter.POST("getTrainingList", BsTrainingApi.GetBsSearchTrainingList) //查询多个证书信息
		BsTrainingPrivateRouter.DELETE("delTrainingById", BsTrainingApi.DelTrainingById)       // 删除用户
		BsTrainingPrivateRouter.PUT("setTrainingInfo", BsTrainingApi.SetTrainingInfo)          // 更新用户
	}
}