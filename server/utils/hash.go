package utils

import (
	"crypto/md5"
	"encoding/hex"

	"golang.org/x/crypto/bcrypt"

	"math/rand"
	"sort"
	"strconv"
	"strings"
	"time"
)

// BcryptHash 使用 bcrypt 对密码进行加密
func BcryptHash(password string) string {
	bytes, _ := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
	return string(bytes)
}

// BcryptCheck 对比明文密码和数据库的哈希值
func BcryptCheck(password, hash string) bool {
	err := bcrypt.CompareHashAndPassword([]byte(hash), []byte(password))
	return err == nil
}

//@author: [piexlmax](https://github.com/piexlmax)
//@function: MD5V
//@description: md5加密
//@param: str []byte
//@return: string

func MD5V(str []byte, b ...byte) string {
	h := md5.New()
	h.Write(str)
	return hex.EncodeToString(h.Sum(b))
}

// GetMD5Hash 计算字符串的 MD5 哈希值
// 参数: password string - 输入的密码字符串
// 返回: string - 32位小写的 MD5 哈希值
func GetMD5Hash(password string) string {
	// 创建 MD5 哈希对象
	hasher := md5.New()

	// 写入数据（注意：MD5 计算的是字节，不是字符串）
	hasher.Write([]byte(password))

	// 计算哈希值并转换为16进制字符串
	hashBytes := hasher.Sum(nil)
	hashString := hex.EncodeToString(hashBytes)

	return hashString
}

// 生成随机字符串
func GenNonceStr() string {
	rand.Seed(time.Now().UnixNano())
	return strconv.FormatInt(rand.Int63(), 10)
}

// MD5签名
func MD5Hash(text string) string {
	h := md5.New()
	h.Write([]byte(text))
	return hex.EncodeToString(h.Sum(nil))
}

func CreateSign(params map[string]string, apiKey string) string {
	// 1. 参数按照 key 排序
	keys := make([]string, 0, len(params))
	for k := range params {
		if params[k] != "" {
			keys = append(keys, k)
		}
	}
	sort.Strings(keys)

	// 2. 拼接成字符串
	var buf strings.Builder
	for _, k := range keys {
		if params[k] != "" {
			buf.WriteString(k + "=" + params[k] + "&")
		}
	}
	buf.WriteString("key=" + apiKey)

	// 3. MD5加密并转大写
	return strings.ToUpper(MD5Hash(buf.String()))
}
