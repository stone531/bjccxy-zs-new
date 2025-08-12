package initialize


import (
    "os"
    "github.com/flipped-aurora/gin-vue-admin/server/global"
    "github.com/go-pay/gopay/wechat/v3"
    "go.uber.org/zap"
)

func Wechat() {
    cfg := global.GVA_CONFIG.WeChat

    keyBytes, err := os.ReadFile(cfg.KeyPath)
    if err != nil {
        global.GVA_LOG.Error("读取私钥失败", zap.Error(err))
        return
    }

    client, err := wechat.NewClientV3(cfg.MchID, cfg.MchKey, cfg.CertPath, string(keyBytes))
    if err != nil {
        global.GVA_LOG.Error("NewClientV3 创建失败", zap.Error(err))
        return
    }

    global.GVA_WECHAT = client
}