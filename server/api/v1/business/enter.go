package business

import "github.com/flipped-aurora/gin-vue-admin/server/service"

type ApiGroup struct {
	BsZhengShuApi
}

var (
	customerService              = service.ServiceGroupApp.ExampleServiceGroup.CustomerService
	fileUploadAndDownloadService = service.ServiceGroupApp.ExampleServiceGroup.FileUploadAndDownloadService
	attachmentCategoryService    = service.ServiceGroupApp.ExampleServiceGroup.AttachmentCategoryService

	//demoRecordService = service.ServiceGroupApp.ExampleServiceGroup.DemoRecordService
)
