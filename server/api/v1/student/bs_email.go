package student

import (
	"fmt"
	"math/rand"
	"time"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/response"
	"github.com/flipped-aurora/gin-vue-admin/server/model/student/request"

	//"github.com/flipped-aurora/gin-vue-admin/server/service"
	"github.com/flipped-aurora/gin-vue-admin/server/plugin/email/service"

	"go.uber.org/zap"

	"github.com/gin-gonic/gin"
)

func (b *BsStudentApi) RegSendEmail(c *gin.Context) {
	var req request.EmailReq
	_ = c.ShouldBindJSON(&req)

	var s string
	for i := 0; i < 6; i++ {
		rand.Seed(time.Now().UnixNano())
		s = s + fmt.Sprintf("%v", rand.Intn(10))
	}
	//if err := servers.SendEmail(user.Email, "注册用户验证码", "你正在使用邮箱找回密码功能，本次邮箱验证码为： "+s); err != nil {

	//}
	msg := "你正在使用邮箱找回密码功能，本次邮箱验证码为： " + s
	//servers.AddMap(req.Username, s)
	//servers.ReportFormat(c, true, "已发送邮箱验证码至:"+msg, gin.H{})
	fmt.Println("aa:", req.Email, msg)
	err := service.ServiceGroupApp.SendEmail(req.Email, "注册用户验证码", msg)
	if err != nil {
		global.GVA_LOG.Error("发送失败!", zap.Error(err))
		response.FailWithMessage("发送失败", c)
		return
	}
	response.OkWithMessage("发送成功", c)
}
