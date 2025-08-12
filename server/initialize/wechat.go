package initialize


import (
    "os"
    "myapp/global"
    "myapp/utils/wechat"
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

    global.WechatClient = client
}