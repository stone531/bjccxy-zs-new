<!-- src/views/student/Order.vue -->
<template>
  <div class="gva-container">
    <div class="gva-card">
      <el-card v-if="order">
        <div class="order-info">
          <p>订单号：{{ order.orderSn }}</p>
          <p>证书类型：{{ order.certType === 'graduation' ? '毕业证书' : '培训证书' }}</p>
          <p>金额：<b>{{ (order.totalFee / 100).toFixed(2) }} 元</b></p>
          <p>状态：
            <el-tag v-if="order.status === 0" type="warning">待支付</el-tag>
            <el-tag v-else-if="order.status === 1" type="success">支付成功</el-tag>
          </p>
          <el-button type="primary" @click="createPayQRCode" :disabled="countdown > 0 && qrCodeUrl">
            {{ qrCodeUrl && countdown > 0 ? '支付中...' : '立即支付' }}
          </el-button>
        </div>
      </el-card>

      <!-- 微信支付二维码弹窗 -->
      <el-dialog v-model="showPayDialog" title="微信支付" width="400px" @close="stopPolling">
        <div style="text-align:center">
          <img v-if="qrCodeUrl" :src="qrCodeUrl" alt="微信支付二维码" />
          <p v-if="countdown > 0">二维码有效期：{{ countdown }} 秒</p>
          <p v-else class="expired-text">二维码已过期，请刷新</p>
          <el-button v-if="countdown === 0" type="primary" @click="createPayQRCode">刷新二维码</el-button>
        </div>
      </el-dialog>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { useRouter } from 'vue-router'

// API 方法（替换成你的接口）
import { getMyPendingOrder, createWeChatPay, getOrderStatus } from '@/api/student'

const router = useRouter()

const order = ref(null)
const qrCodeUrl = ref('')
const showPayDialog = ref(false)
const countdown = ref(0)
let countdownTimer = null
let statusTimer = null

// 获取待支付订单
const fetchOrder = async () => {
  const res = await getMyPendingOrder()
  order.value = res.data
}

// 生成支付二维码
const createPayQRCode = async () => {
  if (!order.value) return
  const res = await createWeChatPay(order.value.orderSn)
  qrCodeUrl.value = res.data.qrCodeUrl
  showPayDialog.value = true
  startCountdown(600) // 10分钟
  startPolling() // 轮询订单状态
}

// 倒计时
const startCountdown = (seconds) => {
  countdown.value = seconds
  clearInterval(countdownTimer)
  countdownTimer = setInterval(() => {
    if (countdown.value > 0) {
      countdown.value--
    } else {
      clearInterval(countdownTimer)
      stopPolling()
    }
  }, 1000)
}

// 轮询订单状态
const startPolling = () => {
  clearInterval(statusTimer)
  statusTimer = setInterval(async () => {
    const res = await getOrderStatus(order.value.orderSn)
    if (res.data.status === 1) {
      ElMessage.success('支付成功！')
      stopPolling()
      showPayDialog.value = false
      router.push({ path: '/business/certificate/certificateQuery' })
    }
  }, 3000)
}

// 停止轮询
const stopPolling = () => {
  clearInterval(statusTimer)
}

onMounted(() => {
  fetchOrder()
})
</script>

<style scoped>
.order-info p {
  margin: 6px 0;
}
.expired-text {
  color: red;
  font-weight: bold;
}
</style>

