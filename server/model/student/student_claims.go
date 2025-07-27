package student

import (
	"github.com/golang-jwt/jwt/v5"
	"github.com/google/uuid"
)

type StudentBaseClaims struct {
	UUID        uuid.UUID
	ID          uint
	Username    string
	NickName    string
	AuthorityId uint
}

type StudentClaims struct {
	BaseClaims StudentBaseClaims
	BufferTime int64
	jwt.RegisteredClaims
}
