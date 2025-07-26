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
