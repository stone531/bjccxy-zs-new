package response

import (
	"github.com/flipped-aurora/gin-vue-admin/server/model/student"
	//"github.com/flipped-aurora/gin-vue-admin/server/model/system"
)

type StudentResponse struct {
	User student.BsStudents `json:"user"`
}

type LoginResponse struct {
	User      student.BsStudents `json:"user"`
	Token     string             `json:"token"`
	ExpiresAt int64              `json:"expiresAt"`
}


//证书详情返回给前端的实体类
type GraduationInfo struct {
	Major          string `json:"major"`
	CertificateNum string `json:"certificateNum"`
	Date           string `json:"date"`
}

type CompletionInfo struct {
	Name           string `json:"name"`
	CertificateNum string `json:"certificateNum"`
	Date           string `json:"date"`
}

type BSCertificateRes struct {
	GraduationCert GraduationInfo   `json:"graduationCert"`
	GompletionCert []CompletionInfo `json:"completionCert"`
}
