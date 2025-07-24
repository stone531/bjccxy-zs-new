package student

import (
	"github.com/gin-gonic/gin"
)

type BsStudentRouter struct{}

func (e *BsStudentRouter) InitBsStudentRouter(Router *gin.RouterGroup) {
	BsStudentRouter := Router.Group("student")
	{
		BsStudentRouter.POST("create", BsStudentApi.CreateBsStudent) //创建证书        //查询一个证书信息
	}
}
