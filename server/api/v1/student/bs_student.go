package student

import (
	"fmt"
	"time"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/utils"

	//"github.com/gin-gonic/gin"
	//"github.com/go-pay/gopay"
	"github.com/google/uuid"

	//"github.com/go-redis/redis"
	"github.com/redis/go-redis/v9"
	"go.uber.org/zap"

	"github.com/flipped-aurora/gin-vue-admin/server/utils/cacheutil"

	//"gin-vue-admin/server/global"
	zsBusiness "github.com/flipped-aurora/gin-vue-admin/server/model/business"
	zsModel "github.com/flipped-aurora/gin-vue-admin/server/model/business/request"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common"
	"github.com/flipped-aurora/gin-vue-admin/server/model/common/response"
	"github.com/flipped-aurora/gin-vue-admin/server/model/student"
	stumodel "github.com/flipped-aurora/gin-vue-admin/server/model/student"
	"github.com/flipped-aurora/gin-vue-admin/server/model/student/request"
	"github.com/flipped-aurora/gin-vue-admin/server/model/system"

	systemReq "github.com/flipped-aurora/gin-vue-admin/server/model/student/request"
	systemRes "github.com/flipped-aurora/gin-vue-admin/server/model/student/response"

	//"github.com/flipped-aurora/gin-vue-admin/server/utils"

	//demoRecordRes "github.com/flipped-aurora/gin-vue-admin/server/model/example/response"

	"github.com/gin-gonic/gin"
	"github.com/mojocn/base64Captcha"
)

var store = base64Captcha.DefaultMemStore

type BsStudentApi struct{}

// Login
// @Tags     Base
// @Summary  用户登录
// @Produce   application/json
// @Param    data  body      systemReq.Login                                             true  "用户名, 密码, 验证码"
// @Success  200   {object}  response.Response{data=systemRes.LoginResponse,msg=string}  "返回包括用户信息,token,过期时间"
// @Router   /base/login [post]
func (b *BsStudentApi) Login(c *gin.Context) {
	fmt.Println("student login")
	var l systemReq.Login
	err := c.ShouldBindJSON(&l)
	key := c.ClientIP()
	fmt.Println("login user:", l.UserAccount, l.Password, l.CaptchaId)

	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	/*err = utils.Verify(l, utils.LoginVerify)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}*/

	// 判断验证码是否开启
	/*openCaptcha := global.GVA_CONFIG.Captcha.OpenCaptcha // 是否开启防爆次数
	openCaptchaTimeOut := global.GVA_CONFIG.Captcha.OpenCaptchaTimeOut // 缓存超时时间
	v, ok := global.BlackCache.Get(key)
	if !ok {
		global.BlackCache.Set(key, 1, time.Second*time.Duration(openCaptchaTimeOut))
	}

	var oc bool = openCaptcha == 0 || openCaptcha < interfaceToInt(v)
	*/
	//if !oc || (l.CaptchaId != "" && l.Captcha != "" && store.Verify(l.CaptchaId, l.Captcha, true)) {
	if l.CaptchaId != "" && l.Captcha != "" && store.Verify(l.CaptchaId, l.Captcha, true) {
		//u := &system.SysUser{Username: l.Username, Password: l.Password}
		u := &stumodel.BsStudents{UserAccount: l.UserAccount, Password: l.Password}

		user, err := bsStudentService.Login(u)
		if err != nil {
			global.GVA_LOG.Error("登陆失败! 用户名不存在或者密码错误!", zap.Error(err))
			// 验证码次数+1
			global.BlackCache.Increment(key, 1)
			response.FailWithMessage("用户名不存在或者密码错误", c)
			return
		}

		b.TokenNext(c, *user)
		return
	}
	// 验证码次数+1
	global.BlackCache.Increment(key, 1)
	response.FailWithMessage("验证码错误", c)
}

// TokenNext 登录以后签发jwt
func (b *BsStudentApi) TokenNext(c *gin.Context, user student.BsStudents) {
	token, claims, err := utils.StudentLoginToken(&user)
	if err != nil {
		global.GVA_LOG.Error("获取token失败!", zap.Error(err))
		response.FailWithMessage("获取token失败", c)
		return
	}
	if !global.GVA_CONFIG.System.UseMultipoint {
		utils.SetStudentToken(c, token, int(claims.RegisteredClaims.ExpiresAt.Unix()-time.Now().Unix()))
		response.OkWithDetailed(systemRes.LoginResponse{
			User:      user,
			Token:     token,
			ExpiresAt: claims.RegisteredClaims.ExpiresAt.Unix() * 1000,
		}, "登录成功", c)
		return
	}

	if jwtStr, err := jwtService.GetRedisJWT(user.UserAccount); err == redis.Nil {
		if err := utils.SetRedisJWT(token, user.UserAccount); err != nil {
			global.GVA_LOG.Error("设置登录状态失败!", zap.Error(err))
			response.FailWithMessage("设置登录状态失败", c)
			return
		}
		utils.SetStudentToken(c, token, int(claims.RegisteredClaims.ExpiresAt.Unix()-time.Now().Unix()))
		response.OkWithDetailed(systemRes.LoginResponse{
			User:      user,
			Token:     token,
			ExpiresAt: claims.RegisteredClaims.ExpiresAt.Unix() * 1000,
		}, "登录成功", c)
	} else if err != nil {
		global.GVA_LOG.Error("设置登录状态失败!", zap.Error(err))
		response.FailWithMessage("设置登录状态失败", c)
	} else {
		var blackJWT system.JwtBlacklist
		blackJWT.Jwt = jwtStr
		if err := jwtService.JsonInBlacklist(blackJWT); err != nil {
			response.FailWithMessage("jwt作废失败", c)
			return
		}
		if err := utils.SetRedisJWT(token, user.GetUsername()); err != nil {
			response.FailWithMessage("设置登录状态失败", c)
			return
		}
		utils.SetStudentToken(c, token, int(claims.RegisteredClaims.ExpiresAt.Unix()-time.Now().Unix()))
		response.OkWithDetailed(systemRes.LoginResponse{
			User:      user,
			Token:     token,
			ExpiresAt: claims.RegisteredClaims.ExpiresAt.Unix() * 1000,
		}, "登录成功", c)
	}
}

// CreateDemoRecord
func (api *BsStudentApi) CreateBsStudent(c *gin.Context) {
	var req request.AddStudent
	global.GVA_LOG.Info("CreateBsTraining 001")
	if err := c.ShouldBindJSON(&req); err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}

	ok, _ := bsStudentService.CheckUserExists(req.UserAccount, req.Email)
	if ok {
		response.FailWithMessage("用户名和邮箱已被占用 ", c)
		return
	}
	//now := time.Now()
	//currentDate := time.Date(now.Year(), now.Month(), now.Day(), 0, 0, 0, 0, now.Location())
	cache := cacheutil.GetInstance()
	code, ok := cache.Get(req.Email)
	if !ok {
		response.FailWithMessage("输入先点发送验证码到邮箱", c)
		return
	}
	fmt.Println("code0:", req.VerificationCode)
	fmt.Println("code1:", code)
	if req.VerificationCode != code {
		response.FailWithMessage("输入邮箱验证码有误", c)
		return
	}
	stuObj := student.BsStudents{
		UUID:        uuid.New(),
		UserAccount: req.UserAccount,
		Password:    req.PassWord,
		Email:       req.Email,
		//VerificationCode: req.VerificationCode,
		//ExtraField1:      req.ExtraField1,
		//ExtraField2:      req.ExtraField2,
	}

	if err := global.GVA_DB.Create(&stuObj).Error; err != nil {
		response.FailWithMessage("注册成功", c)
		return
	}

	response.OkWithData(gin.H{"id": stuObj.ID}, c)
}

// 类型转换
func interfaceToInt(v interface{}) (i int) {
	switch v := v.(type) {
	case int:
		i = v
	default:
		i = 0
	}
	return
}

func (b *BsStudentApi) GetUserInfo(c *gin.Context) {
	uuid := utils.GetStudentUUID(c)
	fmt.Println("GetUserInfo :", uuid)
	ReqUser, err := bsStudentService.GetUserInfo(uuid)
	if err != nil {
		global.GVA_LOG.Error("获取失败!", zap.Error(err))
		response.FailWithMessage("获取失败", c)
		return
	}
	response.OkWithDetailed(gin.H{"userInfo": ReqUser}, "获取成功", c)
}

// GetDemoRecordList
/*func (api *BsStudentApi) GetBsSearchTrainingList(c *gin.Context) {
	var pageInfo request.GetBsTrainingStuList

	err := c.ShouldBindJSON(&pageInfo)
	if err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}
	fmt.Println("GetBsSearchTrainingList:", pageInfo)

	//fmt.Println("GetBsSearchTrainingList 01:", pageInfo)

	list, total, err := api.GetTrainingInfoList(pageInfo)
	if err != nil {
		global.GVA_LOG.Error("获取失败!", zap.Error(err))
		response.FailWithMessage("获取失败", c)
		return
	}
	response.OkWithDetailed(response.PageResult{
		List:     list,
		Total:    total,
		Page:     pageInfo.Page,
		PageSize: pageInfo.PageSize,
	}, "获取成功", c)
}*/

func (b *BsStudentApi) UpdateField(c *gin.Context) {
	var req request.UpdateStudentFieldReq
	if err := c.ShouldBindJSON(&req); err != nil {
		response.FailWithMessage("参数错误", c)
		return
	}

	Id := utils.GetStudentID(c) // 从 JWT 或 session 获取当前登录用户 ID
	if Id <= 0 {
		response.FailWithMessage("用户不存在", c)
		return
	}
	fmt.Println("GetStudentID :", Id)

	ok, _ := bsStudentService.UpdateStuFiled(Id, req)
	if !ok {
		response.FailWithMessage("操作失败 ", c)
		return
	}

	response.OkWithDetailed(gin.H{"code": 0}, "操作成功", c)
}

func (b *BsStudentApi) ChangePassword(c *gin.Context) {
	var req request.ChangePasswordReq
	if err := c.ShouldBindJSON(&req); err != nil {
		response.FailWithMessage("参数错误", c)
		return
	}

	Id := utils.GetStudentID(c) // 从 JWT 或 session 获取当前登录用户 ID
	if Id <= 0 {
		response.FailWithMessage("用户不存在", c)
		return
	}
	fmt.Println("GetStudentID :", Id)

	ok, _ := bsStudentService.ChangePassword(Id, req)
	if !ok {
		response.FailWithMessage("旧密码错误 ", c)
		return
	}

	response.OkWithDetailed(gin.H{"code": 0}, "密码修改成功", c)
}

func (b *BsStudentApi) GetCertificateList(c *gin.Context) {

	uuid := utils.GetStudentUUID(c)
	fmt.Println("GetCertificateList :", uuid)

	stuObj, err := bsStudentService.GetUserInfo(uuid)
	if err != nil {
		global.GVA_LOG.Error("GetCertificateInfo 获取失败!", zap.Error(err))
		response.FailWithMessage("获取失败", c)
		return
	}
	//idCardNum := utils.GetStudentIdCardNum(c) // 从 JWT 或 session 获取当前登录用户 ID
	//fmt.Println("GetCertificateList idcardnum:", idCardNum)
	res, err := bsStudentService.GetCertificateInfo(stuObj.IDCardNumber)
	if err != nil {
		global.GVA_LOG.Error("GetCertificateInfo 获取失败!", zap.Error(err))
		response.FailWithMessage("获取失败", c)
		return
	}

	response.OkWithDetailed(gin.H{"certicates": res}, "获取成功", c)
}

// 获取当前用户待支付订单
func (b *BsStudentApi) GetMyPendingOrder(c *gin.Context) {
	id := utils.GetStudentID(c)
	fmt.Println("GetMyPendingOrder :", id)

	orders, err := bsOrderService.GetMyPendingOrder(int64(id))
	if err != nil {
		global.GVA_LOG.Error("GetMyPendingOrder 获取失败!", zap.Error(err))
		response.FailWithMessage("获取失败", c)
		return
	}

	response.OkWithDetailed(gin.H{"orders": orders}, "获取成功", c)
}

// 订单详情
func (b *BsStudentApi) GetOrderDetail(c *gin.Context) {
	orderSn := c.Param("orderSn") // 从URL路径取到 :orderSn
	var err error
	if orderSn == "" {
		global.GVA_LOG.Error("GetOrderStatus 获取失败!", zap.Error(err))
		response.FailWithMessage("订单号不能为空", c)
	}

	order, err := bsOrderService.OrderDetail(orderSn)
	if err != nil {
		global.GVA_LOG.Error("GetOrderDetail 获取失败!", zap.Error(err))
		response.FailWithMessage("获取失败", c)
		return
	}

	response.OkWithDetailed(order, "获取成功", c)
}

// 创建微信支付二维码
func (b *BsStudentApi) CreateWeChatPay(c *gin.Context) {
	orderSn := c.Param("orderSn")

	// 查询订单
	fmt.Println("CreateWeChatPay00 sn:", orderSn)
	var order stumodel.BsOrders
	if err := global.GVA_DB.Where("order_sn = ?", orderSn).First(&order).Error; err != nil {
		response.FailWithMessage("订单不存在", c)
		return
	}

	fmt.Println("CreateWeChatPay01 sn:", orderSn)

	payUrl, err := bsOrderService.CreateNativeOrder_test(orderSn, int(common.Graduschool_TotalFee), "毕业证书申请")
	if err != nil {
		response.FailWithMessage("返回支付码失败", c)
		return
	}
	fmt.Println("CreateWeChatPay03 url:", payUrl)
	response.OkWithDetailed(gin.H{"payUrl": payUrl}, "获取成功", c)
}

// 获取订单状态
func (b *BsStudentApi) GetOrderStatus(c *gin.Context) {
	orderSn := c.Param("orderSn") // 从URL路径取到 :orderSn
	var err error
	if orderSn == "" {
		global.GVA_LOG.Error("GetOrderStatus 获取失败!", zap.Error(err))
		response.FailWithMessage("订单号不能为空", c)
	}

	var order stumodel.BsOrders
	if err := global.GVA_DB.Where("order_sn = ?", orderSn).First(&order).Error; err != nil {
		response.FailWithMessage("订单不存在", c)
		return
	}

	response.OkWithDetailed(gin.H{"status": order.Status}, "获取成功", c)
}

func (api *BsStudentApi) CreateBsZhengshu(c *gin.Context) {
	var req zsModel.AddUser
	global.GVA_LOG.Info("BsZhengShuApi 001")
	if err := c.ShouldBindJSON(&req); err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}

	//check idcard
	ok, _ := api.checkCertifityIDCardExists(req.CertificateNumber2)
	if ok {
		response.FailWithMessage("exit the same CertificateNumber2 ", c)
		return
	}

	now := time.Now()
	currentDate := time.Date(now.Year(), now.Month(), now.Day(), 0, 0, 0, 0, now.Location())

	public := "no"
	if req.Editer != "student" {
		public = "yes"
	}
	record := zsBusiness.BsZhengshu{
		Name:               req.Name,
		Age:                req.Age,
		Sex:                req.Sex,
		Mingzhu:            req.Mingzhu,
		Pic:                req.Pic,
		NativePlace:        req.NativePlace,
		Zzmm:               req.Zzmm,
		Chengchi:           req.Chengchi,
		CertificateNumber2: req.CertificateNumber2,
		Zhuanye:            req.Zhuanye,
		Graduschool:        bsZhengshuService.GetNextGraduschoolNumber(),
		Graduschool2:       req.Graduschool2,
		Bysj:               req.Bysj,
		Zwjd:               req.Zwjd,
		Demo:               req.Demo,
		Editer:             req.Editer,
		Date:               currentDate,
		Publish:            public,
	}

	if err := global.GVA_DB.Create(&record).Error; err != nil {
		response.FailWithMessage("create fail", c)
		return
	}

	if req.Editer == "student" {
		err := bsOrderService.CreateOrder(common.Graduschool_ZhengShu, record.ID, int(common.Graduschool_TotalFee))
		if err != nil {
			response.FailWithMessage("create order fail", c)
			return
		}
	}

	response.OkWithData(gin.H{"id": record.ID}, c)
}

func (api *BsStudentApi) CreateBsTraining(c *gin.Context) {
	var req zsModel.AddTrainingStu
	global.GVA_LOG.Info("CreateBsTraining 001")
	if err := c.ShouldBindJSON(&req); err != nil {
		response.FailWithMessage(err.Error(), c)
		return
	}

	//check idcard
	ok, _ := api.checkTrainingIDCardExists(req.IDCardNumber)
	if ok {
		response.FailWithMessage("exit the same CertificateNumber2 ", c)
		return
	}

	//now := time.Now()
	//currentDate := time.Date(now.Year(), now.Month(), now.Day(), 0, 0, 0, 0, now.Location())
	public := "no"
	if req.Editer != "student" {
		public = "yes"
	}
	record := zsBusiness.BsTrainingStudent{
		Name:            req.Name,
		Gender:          req.Gender,
		IDCardNumber:    req.IDCardNumber,
		CertificateName: req.CertificateName,
		CertificateID:   bsZhengshuService.GetNextTrainingGraduschoolNumber(),
		IssueDate:       req.IssueDate,
		TrainingProgram: req.TrainingProgram,
		Grade:           req.Grade,
		Editer:          req.Editer,
		ExtraField1:     public,
	}

	if err := global.GVA_DB.Create(&record).Error; err != nil {
		response.FailWithMessage("create fail", c)
		return
	}

	if req.Editer == "student" {
		fmt.Println("student insert id:", utils.GetStudentID(c))
		//是student的id
		err := bsOrderService.CreateOrder(common.Training_ZhengShu, utils.GetStudentID(c), int(common.Training_TotalFee))
		if err != nil {
			response.FailWithMessage("create order fail", c)
			return
		}
	}

	response.OkWithData(gin.H{"id": record.ID}, c)
}

func (api *BsStudentApi) checkCertifityIDCardExists(idCard string) (bool, error) {
	var count int64
	err := global.GVA_DB.Model(&zsBusiness.BsZhengshu{}).
		Where("CertificateNumber2 = ?", idCard).
		Count(&count).Error

	if err != nil {
		return false, err
	}
	return count > 0, nil
}

func (api *BsStudentApi) checkTrainingIDCardExists(idCard string) (bool, error) {
	var count int64
	err := global.GVA_DB.Model(&zsBusiness.BsTrainingStudent{}).
		Where("id_card_number = ?", idCard).
		Count(&count).Error

	if err != nil {
		return false, err
	}
	return count > 0, nil
}
