<template>
  <div>
    <h3>微信支付二维码示例</h3>
    <el-input v-model="payUrl" placeholder="支付链接" readonly style="width: 400px;" />
    <div v-if="qrCodeSrc" style="margin-top: 20px;">
      <img :src="qrCodeSrc" alt="微信支付二维码" style="width: 250px; height: 250px;" />
    </div>
  </div>
</template>

<script setup>
import { ref, watch } from 'vue'
import QRCode from 'qrcode'

// 模拟后端返回的支付链接
const payUrl = ref('weixin://wxpay/bizpayurl?pr=0k1KkPEz1')
const qrCodeSrc = ref('')

async function generateQRCode(url) {
  try {
    qrCodeSrc.value = await QRCode.toDataURL(url, {
      errorCorrectionLevel: 'H',
      width: 250
    })
  } catch (err) {
    console.error('二维码生成失败:', err)
  }
}

// 监听payUrl变化，自动生成二维码
watch(payUrl, (newUrl) => {
  if (newUrl) {
    generateQRCode(newUrl)
  }
}, { immediate: true })
</script>

<style scoped>
h3 {
  margin-bottom: 10px;
}
</style>
