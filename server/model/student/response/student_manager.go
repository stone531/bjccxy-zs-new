package response

import (
	"github.com/flipped-aurora/gin-vue-admin/server/model/student"
	//"github.com/flipped-aurora/gin-vue-admin/server/model/system"
)

type BSZhengShuResponse struct {
	Students student.BsStudents `json:"students"`
}
