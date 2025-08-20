package config

type WeChat struct {
	AppID     string `mapstructure:"app_id" json:"app_id" yaml:"app_id"`
	MchID     string `mapstructure:"mch_id" json:"mch_id" yaml:"mch_id"`                // 商户号
	MchKey    string `mapstructure:"mch_key" json:"mch_key" yaml:"mch_key"`             // APIv3密钥
	APIV3Key    string `mapstructure:"apiV3_key" json:"apiV3_key" yaml:"apiV3_key"`             // APIv3密钥
	CertPath  string `mapstructure:"cert_path" json:"cert_path" yaml:"cert_path"`       // 证书路径
	KeyPath   string `mapstructure:"key_path" json:"key_path" yaml:"key_path"`          // 私钥路径
	RootCA    string `mapstructure:"rootca_path" json:"rootca_path" yaml:"rootca_path"` // 根证书路径
	NotifyURL string `mapstructure:"notify_url" json:"notify_url" yaml:"notify_url"`    // 回调通知地址
}
