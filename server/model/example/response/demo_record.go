package response

import "github.com/flipped-aurora/gin-vue-admin/server/model/example"

type DemoRecordResponse struct {
	DemoRecord example.DemoRecord `json:"demo_record"`
}
