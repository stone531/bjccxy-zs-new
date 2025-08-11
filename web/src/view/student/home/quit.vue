<template>
  <div class="order-container">
    <el-card class="box-card">
      <div class="header">
        <el-button type="primary" @click="getPayQrCode">获取二维码</el-button>
      </div>

      <div class="qrcode-box" v-if="qrCodeUrl">
        <img :src="qrCodeUrl" alt="支付二维码" />
        <p class="tip">请使用微信扫描二维码进行支付</p>
      </div>

      <div v-else class="placeholder">
        <p>点击上方按钮生成二维码</p>
      </div>
    </el-card>
  </div>
</template>

<script>
import QRCode from 'qrcode'
import request from '@/utils/request' // gin-vue-admin 默认 axios 封装

export default {
  name: 'Order',
  data() {
    return {
      qrCodeUrl: '', // 生成的二维码图片 base64
    }
  },
  methods: {
    async getPayQrCode() {
      try {
        const res = await request({
          url: '/order/create-qrcode', // 你的后端二维码生成接口
          method: 'get',
        })
        if (res.code === 0 && res.data?.payUrl) {
          // 用 qrcode 生成 base64 图片
          this.qrCodeUrl = await QRCode.toDataURL(res.data.payUrl, {
            width: 200,
            margin: 2,
          })
        } else {
          this.$message.error(res.msg || '获取二维码失败')
        }
      } catch (err) {
        console.error(err)
        this.$message.error('接口请求失败')
      }
    },
  },
}
</script>

<style scoped>
.order-container {
  padding: 20px;
}

.header {
  margin-bottom: 20px;
}

.qrcode-box {
  text-align: center;
}

.qrcode-box img {
  width: 200px;
  height: 200px;
}

.tip {
  margin-top: 10px;
  font-size: 14px;
  color: #666;
}

.placeholder {
  text-align: center;
  color: #999;
}
</style>
