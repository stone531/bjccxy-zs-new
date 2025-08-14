package request

import (
	jwt "github.com/golang-jwt/jwt/v5"
	"github.com/google/uuid"
)

// CustomClaims structure
type CustomClaims struct {
	BaseClaims
	BufferTime int64
	jwt.RegisteredClaims
}

type BaseClaims struct {
	UUID        uuid.UUID
	ID          uint
	Username    string
	NickName    string
	AuthorityId uint
}


// StudentClaims 学生 token 的 claims
type StudentClaims struct {
	BaseClaims
	BufferTime int64 `json:"bufferTime"`
	jwt.RegisteredClaims
}