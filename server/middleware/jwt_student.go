package middleware

import (
	"errors"
	"time"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	"github.com/flipped-aurora/gin-vue-admin/server/utils"
	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v5"
)

func JWTStudentAuthMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		token := c.Request.Header.Get("student-token")
		if token == "" {
			token, _ = c.Cookie("student-token")
			if token == "" {
				global.GVA_LOG.Error("student-token 不存在")
				c.AbortWithStatusJSON(401, gin.H{"msg": "未登录，请先登录"})
				return
			}
		}

		j := utils.NewStudentJWT()
		claims, err := j.ParseStudentToken(token)
		if err != nil {
			/*var vErr *jwt.ValidationError
			if errors.As(err, &vErr) {
				if strings.Contains(vErr.Error(), "expired") {
					c.AbortWithStatusJSON(401, gin.H{"msg": "授权已过期，请重新登录"})
					return
				}
			}
			c.AbortWithStatusJSON(401, gin.H{"msg": "无效的 student-token"})
			return*/
			if errors.Is(err, jwt.ErrTokenExpired) {
				c.AbortWithStatusJSON(401, gin.H{"msg": "授权已过期，请重新登录"})
				return
			}
			c.AbortWithStatusJSON(401, gin.H{"msg": "无效的 student-token"})
			return
		}

		// 刷新 token：若过期前 buffer 时间内，重新签发
		if time.Until(claims.ExpiresAt.Time) < time.Duration(claims.BufferTime)*time.Second {
			newClaims := j.CreateStudentClaims(claims.BaseClaims)
			newToken, _ := j.CreateStudentToken(newClaims)
			dr, _ := utils.ParseDuration(global.GVA_CONFIG.JWT.ExpiresTime)
			//utils.SetStudentToken(c, newToken, global.GVA_CONFIG.JWT.ExpiresTime)
			utils.SetStudentToken(c, newToken, int(dr.Seconds()))
		}

		// 将 claims 设置到 context 中
		c.Set("student_claims", claims)
		c.Next()
	}
}
