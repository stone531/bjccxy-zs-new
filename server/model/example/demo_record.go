package example

import (
	"gorm.io/gorm"
)

type DemoRecord struct {
	gorm.Model
	Title   string `json:"title" gorm:"comment:title"`
	Content string `json:"content" gorm:"comment:content"`
}
