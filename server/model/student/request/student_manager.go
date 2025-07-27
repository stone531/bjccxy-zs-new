package request

type AddStudent struct {
	//Name string `json:"name"`

	UserAccount      string `json:"usera_ccount"`      // 身份证号
	PassWord         string `json:"password"`          // 证书名称
	Email            string `json:"email"`             // 证书编号
	VerificationCode string `json:"verification_code"` // 发证日期
	//IDCardNumber     string `json:"id_card_number"`    // 培训项目
	//BindId           int8   ` json:"bind_id"`          // 成绩评定
	//ExtraField1 string ` json:"extra_file1"` // 编辑者
	//ExtraField2 string ` json:"extra_file2"` // 编辑者
}

// Login User login structure
type Login struct {
	UserAccount string `json:"useraccount"` // 用户名
	Password    string `json:"password"`    // 密码
	Captcha     string `json:"captcha"`     // 验证码
	CaptchaId   string `json:"captchaId"`   // 验证码ID
}
