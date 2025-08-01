package student

import (
	"errors"
	"time"

	"github.com/flipped-aurora/gin-vue-admin/server/model/student"
	emailreq "github.com/flipped-aurora/gin-vue-admin/server/model/student/request"
	stureq "github.com/flipped-aurora/gin-vue-admin/server/model/student/request"
	"github.com/flipped-aurora/gin-vue-admin/server/utils"
	"github.com/google/uuid"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"gorm.io/gorm"
)

//@author: [piexlmax](https://github.com/piexlmax)
//@function: Register
//@description: 用户注册
//@param: u model.SysUser
//@return: userInter system.SysUser, err error

type BsStudentService struct{}

var BsServiceApp = new(BsStudentService)

func (bzs *BsStudentService) Register(u student.BsStudents) (userInter student.BsStudents, err error) {
	var user student.BsStudents
	if !errors.Is(global.GVA_DB.Where("username = ?", u.Name).First(&user).Error, gorm.ErrRecordNotFound) { // 判断用户名是否注册
		return userInter, errors.New("用户名已注册")
	}
	// 否则 附加uuid 密码hash加密 注册
	//u.Password = utils.BcryptHash(u.Password)
	//u.UUID = uuid.New()
	err = global.GVA_DB.Create(&u).Error
	return u, err
}

func (bzs *BsStudentService) DeleteUser(id int) (err error) {
	//fmt.Println("DeleteUser id:%d:", id)
	return global.GVA_DB.Transaction(func(tx *gorm.DB) error {
		if err := tx.Where("ID = ?", id).Delete(&student.BsStudents{}).Error; err != nil {
			return err
		}
		return nil
	})

}

func (userService *BsStudentService) Login(u *student.BsStudents) (userInter *student.BsStudents, err error) {
	/*if nil == global.GVA_DB {
		return nil, fmt.Errorf("db not init")
	}*/

	var user student.BsStudents
	err = global.GVA_DB.Where("useraccount = ? and password = ?", u.UserAccount,u.Password).First(&user).Error
	if err == nil {
		/*if ok := utils.BcryptCheck(u.Password, user.Password); !ok {
			return nil, errors.New("密码错误")
		}*/
		//MenuServiceApp.UserAuthorityDefaultRouter(&user)
	}
	return &user, err
}

func (bzs *BsStudentService) InitPassword(u emailreq.InitPasswordReq, pwd string) (err error) {
	//var user student.BsStudents
	/*if !errors.Is(global.GVA_DB.Where("useraccount = ? and email = ?", u.UserAccount, u.Email).First(&user).Error, gorm.ErrRecordNotFound) { // 判断用户名是否注册
		return userInter, errors.New("用户名已注册")
	}*/

	return global.GVA_DB.Model(&student.BsStudents{}).
		Select("updated_at", "password").
		Where("useraccount=? and email=?", u.UserAccount, u.Email).
		Updates(map[string]interface{}{
			"updated_at": time.Now(),
			"password":   utils.GetMD5Hash(pwd),
		}).Error
}

func (api *BsStudentService) CheckUserExists(uaccount string, uEmail string) (bool, error) {
	var count int64
	err := global.GVA_DB.Model(&student.BsStudents{}).
		Where("useraccount = ? and email = ?", uaccount, uEmail).
		Count(&count).Error

	if err != nil {
		return false, err
	}
	return count > 0, nil
}

func (us *BsStudentService) GetUserInfo(uuid uuid.UUID) (user student.BsStudents, err error) {
	var reqUser student.BsStudents
	err = global.GVA_DB.Model(&student.BsStudents{}).First(&reqUser, "uuid = ?", uuid).Error
	if err != nil {
		return reqUser, err
	}

	return reqUser, err
}

func (api *BsStudentService) ChangePassword(id uint, pwd stureq.ChangePasswordReq) (bool, error) {

	var reqUser student.BsStudents
	err := global.GVA_DB.Model(&student.BsStudents{}).First(&reqUser, "id = ? and password = ?", id,pwd.OldPassword).Error
	if err != nil {
		return false, err
	}

	if err := global.GVA_DB.Model(&student.BsStudents{}).Where("id = ? ", id).Update("password", pwd.NewPassword).Error; err != nil {
        return false, err
    }

	return true, nil
}

func (api *BsStudentService) UpdateStuFiled(id uint, obj stureq.UpdateStudentFieldReq) (bool, error) {

	if err := global.GVA_DB.Model(&student.BsStudents{}).
    	Where("id = ?", id).
    	Update(obj.Field, obj.Value).Error; err != nil {
    	return false, err
	}

	return true, nil
}