package utils

import (
	"time"

	"github.com/google/uuid"
	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/model/student"
	"github.com/golang-jwt/jwt/v5"
)

type StudentJWT struct {
	SigningKey []byte
}

func NewStudentJWT() *StudentJWT {
	return &StudentJWT{
		[]byte(global.GVA_CONFIG.JWT.SigningKey), // 复用 JWT 密钥
	}
}

// CreateStudentClaims 创建 Claims
func (j *StudentJWT) CreateStudentClaims(baseClaims student.StudentBaseClaims) student.StudentClaims {
	//bufferTime := global.GVA_CONFIG.JWT.BufferTime
	//expiresTime := global.GVA_CONFIG.JWT.ExpiresTime
	if baseClaims.UUID == uuid.Nil {
		// 如果UUID没传，直接生成一个，避免全 0
		baseClaims.UUID = uuid.New()
	}
	bf, _ := ParseDuration(global.GVA_CONFIG.JWT.BufferTime)
	ep, _ := ParseDuration(global.GVA_CONFIG.JWT.ExpiresTime)
	now := time.Now()
	return student.StudentClaims{
		BaseClaims: baseClaims,
		BufferTime: int64(bf / time.Second),
		RegisteredClaims: jwt.RegisteredClaims{
			//Audience:  jwt.ClaimStrings{"GVA"},
			NotBefore: jwt.NewNumericDate(now),
			ExpiresAt: jwt.NewNumericDate(time.Now().Add(ep)),
			//ExpiresAt: jwt.NewNumericDate(now.Add(time.Duration(expiresTime) * time.Second)),
			Issuer: global.GVA_CONFIG.JWT.Issuer,
		},
	}
}

// CreateStudentToken 创建 token
func (j *StudentJWT) CreateStudentToken(claims student.StudentClaims) (string, error) {
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	return token.SignedString(j.SigningKey)
}

// ParseStudentToken 解析 token
func (j *StudentJWT) ParseStudentToken(tokenString string) (*student.StudentClaims, error) {
	token, err := jwt.ParseWithClaims(tokenString, &student.StudentClaims{}, func(token *jwt.Token) (interface{}, error) {
		return j.SigningKey, nil
	})
	if err != nil {
		return nil, err
	}
	if claims, ok := token.Claims.(*student.StudentClaims); ok && token.Valid {
		return claims, nil
	}
	return nil, jwt.ErrTokenInvalidClaims
}
