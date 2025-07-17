package business

import (
	"github.com/gin-gonic/gin"
)

type BsTrainingRouter struct{}

func (e *BsTrainingRouter) InitBsTrainingRouter(Router *gin.RouterGroup) {
	BsTrainingRouter := Router.Group("bstraining")
	{
		BsTrainingRouter.POST("create", BsTrainingApi.CreateBsTraining)                 //创建证书
		BsTrainingRouter.POST("getTrainingList", BsTrainingApi.GetBsSearchTrainingList) //查询多个证书信息
		BsTrainingRouter.DELETE("delTrainingById", BsTrainingApi.DelTrainingById)       // 删除用户
		BsTrainingRouter.PUT("setTrainingInfo", BsTrainingApi.SetTrainingInfo)          // 更新用户
		BsTrainingRouter.POST("getOneTraining", BsTrainingApi.GetOneBsTraining)         //查询一个证书信息
	}
}
