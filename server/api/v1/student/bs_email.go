package student

import (
	"crypto/rand"
	"fmt"
	"math/big"
	mcand "math/rand"
	"time"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/response"
	"github.com/flipped-aurora/gin-vue-admin/server/model/student/request"
	"github.com/flipped-aurora/gin-vue-admin/server/utils/cacheutil"

	//"github.com/flipped-aurora/gin-vue-admin/server/service"
	"github.com/flipped-aurora/gin-vue-admin/server/plugin/email/service"

	"go.uber.org/zap"

	"github.com/gin-gonic/gin"
)

const (
	lowercaseLetters = "abcdefghijklmnopqrstuvwxyz"
	uppercaseLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	digits           = "0123456789"
	specialChars     = "!@#$%^&*()-_=+[]{}<>?/|"
)

const passwordLength = 16

func (b *BsStudentApi) RegSendEmail(c *gin.Context) {
	var req request.EmailReq
	_ = c.ShouldBindJSON(&req)

	var s string
	for i := 0; i < 6; i++ {
		mcand.Seed(time.Now().UnixNano())
		s = s + fmt.Sprintf("%v", mcand.Intn(10))
	}
	//if err := servers.SendEmail(user.Email, "注册用户验证码", "你正在使用邮箱找回密码功能，本次邮箱验证码为： "+s); err != nil {

	//}
	msg := "你正在使用邮箱注册用户功能，本次邮箱验证码为： " + s
	//servers.AddMap(req.Username, s)
	//servers.ReportFormat(c, true, "已发送邮箱验证码至:"+msg, gin.H{})
	fmt.Println("send email:", req.Email, s)
	cache := cacheutil.GetInstance()
	cache.Set(req.Email, s)

	err := service.ServiceGroupApp.SendEmail(req.Email, "注册用户验证码", msg)
	if err != nil {
		global.GVA_LOG.Error("发送失败!", zap.Error(err))
		response.FailWithMessage("发送失败", c)
		return
	}
	response.OkWithMessage("发送成功", c)
}

func GenerateSecurePassword() (string, error) {
	// 全部字符集合
	allChars := lowercaseLetters + uppercaseLetters + digits + specialChars
	charsetLen := big.NewInt(int64(len(allChars)))

	password := make([]byte, passwordLength)

	// 保证至少包含每种类型的字符
	categories := []string{lowercaseLetters, uppercaseLetters, digits, specialChars}
	for i := 0; i < len(categories); i++ {
		ch, err := randomCharFrom(categories[i])
		if err != nil {
			return "", err
		}
		password[i] = ch
	}

	// 剩余位置随机填充
	for i := len(categories); i < passwordLength; i++ {
		index, err := rand.Int(rand.Reader, charsetLen)
		if err != nil {
			return "", err
		}
		password[i] = allChars[index.Int64()]
	}

	// 打乱顺序（Fisher–Yates 洗牌）
	for i := passwordLength - 1; i > 0; i-- {
		jBig, err := rand.Int(rand.Reader, big.NewInt(int64(i+1)))
		if err != nil {
			return "", err
		}
		j := int(jBig.Int64())
		password[i], password[j] = password[j], password[i]
	}

	return string(password), nil
}

func randomCharFrom(set string) (byte, error) {
	n, err := rand.Int(rand.Reader, big.NewInt(int64(len(set))))
	if err != nil {
		return 0, err
	}
	return set[n.Int64()], nil
}

func (b *BsStudentApi) InitPassword(c *gin.Context) {
	var req request.InitPasswordReq

	if err := c.ShouldBindJSON(&req); err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}

	fmt.Println("InitPassword:", req.Email, req.UserAccount)
	ok, _ := bsStudentService.CheckUserExists(req.UserAccount, req.Email)
	if !ok {
		response.FailWithMessage("用户名和邮箱不匹配 ", c)
		return
	}

	password, err := GenerateSecurePassword()
	if err != nil {
		fmt.Println("Error:", err)
		return
	}

	msg := "你正在使用邮箱注册用户功能，本次邮箱初始密码为： " + password
	fmt.Println("InitPassword 00:", msg)
	//u.Password = utils.BcryptHash(u.Password)
	err = bsStudentService.InitPassword(req, password)
	if err != nil {
		global.GVA_LOG.Error("InitPassword更新密码失败", zap.Error(err))
		response.FailWithMessage("更新密码失败", c)
		return
	}

	err = service.ServiceGroupApp.SendEmail(req.Email, "初始化用户密码", msg)
	if err != nil {
		global.GVA_LOG.Error("发送失败!", zap.Error(err))
		response.FailWithMessage("发送失败", c)
		return
	}
	response.OkWithMessage("发送成功", c)
}
