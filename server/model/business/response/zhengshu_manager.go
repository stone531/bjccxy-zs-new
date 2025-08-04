package response

import (
	"github.com/flipped-aurora/gin-vue-admin/server/model/business"
	//"github.com/flipped-aurora/gin-vue-admin/server/model/system"
)

type BSZhengShuResponse struct {
	ZhengShu business.BsZhengshu `json:"zhengShu"`
}

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
