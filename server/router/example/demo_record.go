package example

import (
	"github.com/gin-gonic/gin"
)

type DemoRecordRouter struct{}

func (e *DemoRecordRouter) InitDemoRecordRouter(Router *gin.RouterGroup) {
	DemoRecordRouter := Router.Group("demoRecord")
	{
		DemoRecordRouter.POST("create", demoRecordApi.CreateDemoRecord) //
		DemoRecordRouter.GET("list", demoRecordApi.GetDemoRecordList)   //
	}
}
