package cacheutil

import (
	"sync"
	"time"

	"github.com/patrickmn/go-cache"
)

type CacheUtil struct {
	c *cache.Cache
}

var (
	once      sync.Once
	singleton *CacheUtil
)

// GetInstance 返回全局唯一的 CacheUtil 实例
func GetInstance() *CacheUtil {
	once.Do(func() {
		singleton = &CacheUtil{
			// 默认缓存 1 分钟，清理周期 5 分钟
			c: cache.New(1*time.Minute, 5*time.Minute),
		}
	})
	return singleton
}

// 提供方法
// Set 设置缓存 key-value，使用默认过期时间（1分钟）
func (cu *CacheUtil) Set(key string, value interface{}) {
	cu.c.Set(key, value, cache.DefaultExpiration)
}

// SetWithTTL 设置缓存 key-value，自定义过期时间
func (cu *CacheUtil) SetWithTTL(key string, value interface{}, ttl time.Duration) {
	cu.c.Set(key, value, ttl)
}

// Get 获取缓存值，返回 value 和是否存在
func (cu *CacheUtil) Get(key string) (interface{}, bool) {
	return cu.c.Get(key)
}

// Delete 删除缓存 key
func (cu *CacheUtil) Delete(key string) {
	cu.c.Delete(key)
}
