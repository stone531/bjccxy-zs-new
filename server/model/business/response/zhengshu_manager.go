package response

import (
	"github.com/flipped-aurora/gin-vue-admin/server/model/business"
	//"github.com/flipped-aurora/gin-vue-admin/server/model/system"
)

type BSZhengShuResponse struct {
	ZhengShu business.BsZhengshu `json:"zhengShu"`
}

