package request

type EmailReq struct {
	Email string `json:"email"`
}

type InitPasswordReq struct {
	UserAccount string `json:"useraccount"` //µÇÂ¼ÕËºÅ
	Email       string `json:"email"`
}
