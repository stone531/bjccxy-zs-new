package student

import (
	//"github.com/flipped-aurora/gin-vue-admin/server/middleware"
	"github.com/gin-gonic/gin"
)

type BsStudentRouter struct{}

func (e *BsStudentRouter) InitBsStudentsRouter(public *gin.RouterGroup, private *gin.RouterGroup) {
	// 公共路由
	BsStudentPublicRouter := public.Group("student")
	{
		BsStudentPublicRouter.POST("register", BsStudentApi.CreateBsStudent)
		BsStudentPublicRouter.POST("sendEmailCode", BsStudentApi.RegSendEmail)
		BsStudentPublicRouter.POST("initPassword", BsStudentApi.InitPassword)
		BsStudentPublicRouter.POST("login", BsStudentApi.Login)

		BsStudentPublicRouter.POST("order-wechat-notify", BsStudentApi.WeChatPayNotify) // 微信支付回调（微信会调用，不需要登录权限）
	}

	// 私有路由
	BsStudentPrivateRouter := private.Group("student")
	{
		BsStudentPrivateRouter.POST("certificate-create", BsStudentApi.CreateBsZhengshu)
		BsStudentPrivateRouter.POST("training-create", BsStudentApi.CreateBsTraining)
		BsStudentPrivateRouter.GET("getInfo", BsStudentApi.GetUserInfo)
		BsStudentPrivateRouter.PUT("updateField", BsStudentApi.UpdateField)
		BsStudentPrivateRouter.POST("changePassword", BsStudentApi.ChangePassword)
		BsStudentPrivateRouter.GET("getCertificateList", BsStudentApi.GetCertificateList)

		BsStudentPrivateRouter.GET("order-my-pending", BsStudentApi.GetMyPendingOrder)    // 获取当前用户待支付订单
		BsStudentPrivateRouter.POST("order-pay/:orderSn", BsStudentApi.CreateWeChatPay)   // 创建微信支付二维码
		BsStudentPrivateRouter.GET("order-status/:orderSn", BsStudentApi.GetOrderStatus)  // 获取订单状态
		BsStudentPrivateRouter.POST("order-refresh/:orderSn", BsStudentApi.RefreshQRCode) // 刷新二维码

		BsStudentPrivateRouter.GET("order-detail/:orderSn", BsStudentApi.GetOrderDetail) // 获取订单详情

	}
}
