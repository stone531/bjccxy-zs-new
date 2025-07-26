package student

import (
	"errors"

	"github.com/flipped-aurora/gin-vue-admin/server/model/student"
	"github.com/flipped-aurora/gin-vue-admin/server/utils"

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
	err = global.GVA_DB.Where("username = ?", u.UserAccount).Preload("Authorities").Preload("Authority").First(&user).Error
	if err == nil {
		if ok := utils.BcryptCheck(u.Password, user.Password); !ok {
			return nil, errors.New("密码错误")
		}
		//MenuServiceApp.UserAuthorityDefaultRouter(&user)
	}
	return &user, err
}
