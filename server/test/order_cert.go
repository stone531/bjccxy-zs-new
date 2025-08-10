package main

import (
	"context"
	"crypto/x509"
	"encoding/pem"
	"fmt"
	"os"
	"strings"

	"github.com/go-pay/gopay"
	"github.com/go-pay/gopay/wechat/v3"
)

func CreateNativeOrder() (string, error) {
	//cfg := global.GVA_CONFIG.WeChat
	orderSN := "202508091748224H11GZO4Q"
	totalFee := 200
	description := "测试数据"

	keyPath := "../wechatCerts/apiclient_key.pem"
	certPath := "../wechatCerts/apiclient_cert.pem"
	mchId := "1724488999"
	mchKey := "wxcfd778de260fadf6bjccxy20250810"
	//mchKey := "4AC906C150066F67C07D9537F01121150DD37288"
	appid := "wxcfd778de260fadf6"
	nUrl := "https://zs.bjccxy.com/student/order-wechat-notify"

	fmt.Println("CreateNativeOrder sn:", orderSN, mchId, mchKey, certPath, keyPath)

	// ===== 证书和私钥检查 =====
	// 检查私钥
	keyData, err := os.ReadFile(keyPath)
	if err != nil {
		return "", fmt.Errorf("读取私钥失败: %w", err)
	}

	keyBlock, _ := pem.Decode(keyData)
	if keyBlock == nil {
		return "", fmt.Errorf("私钥 PEM 格式解析失败")
	}
	if _, err := x509.ParsePKCS8PrivateKey(keyBlock.Bytes); err != nil {
		if _, err2 := x509.ParsePKCS1PrivateKey(keyBlock.Bytes); err2 != nil {
			return "", fmt.Errorf("解析私钥失败: %v / %v", err, err2)
		}
	}

	// 检查证书
	certData, err := os.ReadFile(certPath)
	if err != nil {
		return "", fmt.Errorf("读取证书失败: %w", err)
	}
	certBlock, _ := pem.Decode(certData)
	if certBlock == nil {
		return "", fmt.Errorf("证书 PEM 格式解析失败")
	}
	cert, err := x509.ParseCertificate(certBlock.Bytes)
	if err != nil {
		return "", fmt.Errorf("解析证书失败: %w", err)
	}
	serialNumber := strings.ToUpper(cert.SerialNumber.Text(16))
	fmt.Printf("✅ 证书有效，序列号: %s，有效期: %s ~ %s\n",
		serialNumber, cert.NotBefore.Format("2006-01-02"), cert.NotAfter.Format("2006-01-02"))

	// ===== 初始化微信支付客户端 =====
	//client, err := wechat.NewClientV3WithPath(cfg.MchID, cfg.MchKey, cfg.CertPath, cfg.KeyPath)
	client, err := wechat.NewClientV3(mchId, mchKey, certPath, string(keyData))
	if err != nil {
		fmt.Println("aaaa003:", err)
		//global.GVA_LOG.Error("CreateNativeOrder NewClientV3WithPath 获取失败!", zap.Error(err))
		return "", err
	}

	fmt.Println("CreateNativeOrder client ok")

	// ===== 构造请求参数 =====
	bm := make(gopay.BodyMap)
	bm.Set("appid", appid).
		Set("mchid", mchId).
		Set("description", description).
		Set("out_trade_no", orderSN).
		Set("notify_url", nUrl).
		SetBodyMap("amount", func(b gopay.BodyMap) {
			b.Set("total", totalFee).
				Set("currency", "CNY")
		})

	fmt.Println("CreateNativeOrder bm:", bm)

	// ===== 请求微信生成二维码 =====
	resp, err := client.V3TransactionNative(context.Background(), bm)
	if err != nil {
		fmt.Println("aaaa004:", err)
		//global.GVA_LOG.Error("CreateNativeOrder V3TransactionNative 获取失败!", zap.Error(err))
		return "", err
	}

	fmt.Println("CreateNativeOrder resp:", resp)
	return resp.Response.CodeUrl, nil
}

func main() {
	url, err := CreateNativeOrder()
	fmt.Println("url:", url, err)

}
