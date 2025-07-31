package utils

import (
	"net"
	"time"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/student"
	//systemReq "github.com/flipped-aurora/gin-vue-admin/server/model/system/request"
	//"github.com/flipped-aurora/gin-vue-admin/server/model/student"
	"github.com/gin-gonic/gin"
	jwt "github.com/golang-jwt/jwt/v5"
	"github.com/google/uuid"
	"go.uber.org/zap"
)

// StudentClaims 定义 student 的 claims 结构
type StudentClaims struct {
	BaseClaims student.StudentBaseClaims
	BufferTime int64
	jwt.RegisteredClaims
}

// ClearStudentToken 清除 student-token
func ClearStudentToken(c *gin.Context) {
	host, _, err := net.SplitHostPort(c.Request.Host)
	if err != nil {
		host = c.Request.Host
	}

	if net.ParseIP(host) != nil {
		c.SetCookie("student-token", "", -1, "/", "", false, false)
	} else {
		c.SetCookie("student-token", "", -1, "/", host, false, false)
	}
}

// SetStudentToken 设置 student-token
func SetStudentToken(c *gin.Context, token string, maxAge int) {
	host, _, err := net.SplitHostPort(c.Request.Host)
	if err != nil {
		host = c.Request.Host
	}

	if net.ParseIP(host) != nil {
		c.SetCookie("student-token", token, maxAge, "/", "", false, false)
	} else {
		c.SetCookie("student-token", token, maxAge, "/", host, false, false)
	}
}

// GetStudentToken 从 header 或 cookie 中获取 student-token
func GetStudentToken(c *gin.Context) string {
	token := c.Request.Header.Get("student-token")
	if token == "" {
		j := NewJWT()
		token, _ = c.Cookie("student-token")
		claims, err := j.ParseToken(token)
		if err != nil {
			global.GVA_LOG.Error("获取 student token 失败:", zap.Error(err))
			//global.GVA_LOG.Error("获取 student token 失败:", err)
			return token
		}
		SetStudentToken(c, token, int((claims.ExpiresAt.Unix()-time.Now().Unix())/60))
	}
	return token
}

// GetStudentClaims 解析 student-token 中的 claims
func GetStudentClaims(c *gin.Context) (*student.StudentClaims, error) {
	token := GetStudentToken(c)
	j := NewJWT()
	claims, err := j.ParseStudentToken(token)
	if err != nil {
		global.GVA_LOG.Error("解析 student claims 失败:", zap.Error(err))
	}
	return claims, err
}

// 下方封装常用方法

func GetStudentID(c *gin.Context) uint {
	if claims, exists := c.Get("student_claims"); !exists {
		if cl, err := GetStudentClaims(c); err != nil {
			return 0
		} else {
			return cl.BaseClaims.ID
		}
	} else {
		return claims.(*student.StudentClaims).BaseClaims.ID
	}
}

func GetStudentUUID(c *gin.Context) uuid.UUID {
	if claims, exists := c.Get("student_claims"); !exists {
		if cl, err := GetStudentClaims(c); err != nil {
			return uuid.UUID{}
		} else {
			return cl.BaseClaims.UUID
		}
	} else {
		return claims.(*student.StudentClaims).BaseClaims.UUID
	}
}

func GetStudentAuthorityId(c *gin.Context) uint {
	if claims, exists := c.Get("student_claims"); !exists {
		if cl, err := GetStudentClaims(c); err != nil {
			return 0
		} else {
			return cl.BaseClaims.AuthorityId
		}
	} else {
		return claims.(*student.StudentClaims).BaseClaims.AuthorityId
	}
}

func GetStudentUsername(c *gin.Context) string {
	if claims, exists := c.Get("student_claims"); !exists {
		if cl, err := GetStudentClaims(c); err != nil {
			return ""
		} else {
			return cl.BaseClaims.Username
		}
	} else {
		return claims.(*student.StudentClaims).BaseClaims.Username
	}
}

/*func StudentLoginToken(user student.StudentLogin) (token string, claims systemReq.CustomClaims, err error) {
	j := NewJWT()
	claims = j.CreateStudentClaims(systemReq.BaseClaims{
		UUID:        user.GetUUID(),
		ID:          user.GetUserId(),
		NickName:    user.GetNickname(),
		Username:    user.GetUsername(),
		AuthorityId: user.GetAuthorityId(),
	})
	token, err = j.CreateStudentToken(claims)
	return
}*/
func StudentLoginToken(user *student.BsStudents) (string, *student.StudentClaims, error) {
	j := NewStudentJWT()

	// 构造基础 claims，必须保证 UUID 有值
	claims := j.CreateStudentClaims(student.StudentBaseClaims{
		ID:        user.ID,
		UUID:      user.UUID, // 这里是重点！必须从数据库带出来
		Username:      user.Name,
		NickName:  user.UserAccount,
		AuthorityId: 1, // 也可以从 user 读取
	})

	// 创建 token
	token, err := j.CreateStudentToken(claims)
	if err != nil {
		return "", nil, err
	}

	return token, &claims, nil
}