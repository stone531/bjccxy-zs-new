package business

import (
	"database/sql"
	"errors"
	"fmt"
	"strconv"
	"time"

	"github.com/flipped-aurora/gin-vue-admin/server/model/business"
	systemReq "github.com/flipped-aurora/gin-vue-admin/server/model/business/request"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"gorm.io/gorm"
)

//@author: [piexlmax](https://github.com/piexlmax)
//@function: Register
//@description: 用户注册
//@param: u model.SysUser
//@return: userInter system.SysUser, err error

type BsZhengshuService struct{}

var BsServiceApp = new(BsZhengshuService)

func (bzs *BsZhengshuService) Register(u business.BsZhengshu) (userInter business.BsZhengshu, err error) {
	var user business.BsZhengshu
	if !errors.Is(global.GVA_DB.Where("username = ?", u.Name).First(&user).Error, gorm.ErrRecordNotFound) { // 判断用户名是否注册
		return userInter, errors.New("用户名已注册")
	}
	// 否则 附加uuid 密码hash加密 注册
	//u.Password = utils.BcryptHash(u.Password)
	//u.UUID = uuid.New()
	err = global.GVA_DB.Create(&u).Error
	return u, err
}

func (bzs *BsZhengshuService) DeleteUser(id int) (err error) {
	//fmt.Println("DeleteUser id:%d:", id)
	return global.GVA_DB.Transaction(func(tx *gorm.DB) error {
		if err := tx.Where("ID = ?", id).Delete(&business.BsZhengshu{}).Error; err != nil {
			return err
		}
		return nil
	})
	/*var record business.BsZhengshu
	return global.GVA_DB.Transaction(func(tx *gorm.DB) error {
		if err := tx.Where("id = ?", id).First(&record).Error; err != nil {
			if errors.Is(err, gorm.ErrRecordNotFound) {
				return fmt.Errorf("记录不存在")
			}
			return fmt.Errorf("查询失败: %v", err)
		}

		// 2. 执行删除（打印生成的SQL用于调试）
		stmt := tx.Session(&gorm.Session{DryRun: true}).Where("ID = ?", id).Delete(&business.BsZhengshu{})
		fmt.Println("删除SQL:", stmt.Statement.SQL.String())
		fmt.Println("参数:", stmt.Statement.Vars)

		// 3. 实际执行删除
		result := tx.Where("ID = ?", id).Delete(&business.BsZhengshu{})
		if result.Error != nil {
			return fmt.Errorf("删除失败: %v", result.Error)
		}

		// 4. 检查影响的行数
		if result.RowsAffected == 0 {
			return fmt.Errorf("删除未影响任何行，可能条件不匹配")
		}
		return nil
	})*/

	//return nil
}

func (userService *BsZhengshuService) GetUserInfoList(info systemReq.GetUserList) (list interface{}, total int64, err error) {
	limit := info.PageSize
	offset := info.PageSize * (info.Page - 1)
	db := global.GVA_DB.Model(&business.BsZhengshu{})
	var userList []business.BsZhengshu
	layout := "2006-01-02T15:04:05.000Z"
	loc, _ := time.LoadLocation("Asia/Shanghai")

	fmt.Println("enter GetUserInfoList:", info)
	if info.Name != "" {
		db = db.Where("name LIKE ?", "%"+info.Name+"%")
	}
	if info.Graduschool != "" {
		db = db.Where("graduschool LIKE ?", "%"+info.Graduschool+"%")
	}
	if info.Editer != "" {
		db = db.Where("editer LIKE ?", "%"+info.Editer+"%")
	}

	if info.SDate != "" {
		//db = db.Where("created_at > ?", "%"+info.SDate+"%")
		t, err := time.Parse(layout, info.SDate)
		if err == nil {
			db = db.Where("created_at >= ?", t.In(loc))
		}
	}
	if info.SDate != "" {
		//db = db.Where("created_at < ?", "%"+info.EDate+"%")
		t, err := time.Parse(layout, info.EDate)
		if err == nil {
			db = db.Where("created_at <= ?", t.In(loc))
		}
	}

	err = db.Count(&total).Error
	if err != nil {
		return
	}

	//err = db.Limit(limit).Offset(offset).Find(&userList).Order("created_at desc").Error
	err = db.Order("created_at desc").Limit(limit).Offset(offset).Find(&userList).Error

	return userList, total, err
}

func (userService *BsZhengshuService) SetZhengShuInfo(req systemReq.ChangeZhengShuInfo) error {
	return global.GVA_DB.Model(&business.BsZhengshu{}).
		Select("updated_at", "name", "age", "sex", "mingzhu", "pic", "nativeplace", "bysj", "zhuanye", "certificatenumber2").
		Where("id=?", req.ID).
		Updates(map[string]interface{}{
			"updated_at":         time.Now(),
			"name":               req.Name,
			"age":                req.Age,
			"sex":                req.Sex,
			"mingzhu":            req.Mingzhu,
			"pic":                req.Pic,
			"nativeplace":        req.NativePlace,
			"bysj":               req.Bysj,
			"zhuanye":            req.Zhuanye,
			"certificatenumber2": req.CertificateNumber2,
		}).Error
}

func (api *BsZhengshuService) GetNextGraduschoolNumber() string {
	// 1. 查询最新的证书号
	//var latestNumber string
	//query := "SELECT CertificateNumber2 FROM your_table_name ORDER BY id DESC LIMIT 1" // 假设按id降序排列，根据你的实际表结构调整
	db := global.GVA_DB.Model(&business.BsZhengshu{})
	var userObj business.BsZhengshu //graduschool
	err := db.Order("created_at desc").Limit(1).Find(&userObj).Error
	if err != nil {
		if err == sql.ErrNoRows {
			// 如果没有记录，可以从一个默认值开始
			return "114158200206030001"
		}
		return ""
	}

	// 2. 将字符串转换为数字并加1
	num, err := strconv.ParseUint(userObj.Graduschool, 10, 64)
	if err != nil {
		return ""
	}
	nextNum := num + 1

	// 3. 转换回字符串
	return strconv.FormatUint(nextNum, 10)
}

func (api *BsZhengshuService) GetNextTrainingGraduschoolNumber() string {
	// 1. 查询最新的证书号
	//var latestNumber string
	//query := "SELECT CertificateNumber2 FROM your_table_name ORDER BY id DESC LIMIT 1" // 假设按id降序排列，根据你的实际表结构调整
	db := global.GVA_DB.Model(&business.BsTrainingStudent{})
	var userObj business.BsTrainingStudent //graduschool
	err := db.Order("created_at desc").Limit(1).Find(&userObj).Error
	if err != nil {
		if err == sql.ErrNoRows {
			// 如果没有记录，可以从一个默认值开始
			return "114158200206030001"
		}
		return ""
	}

	// 2. 将字符串转换为数字并加1
	num, err := strconv.ParseUint(userObj.CertificateID, 10, 64)
	if err != nil {
		return ""
	}
	nextNum := num + 1

	// 3. 转换回字符串
	return strconv.FormatUint(nextNum, 10)
}

func (api *BsZhengshuService) UpdateZhengshuPublic(publish string, id uint) (bool, error) {
	if err := global.GVA_DB.Model(&business.BsZhengshu{}).
		Where("id = ?", id).
		Update("publish", publish).Error; err != nil {
		return false, err
	}

	return true, nil
}
