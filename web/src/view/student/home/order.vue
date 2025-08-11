<template>
  <div class="order-page">
    <el-card>
      <div class="table-header">
        <span>订单列表</span>
      </div>

      <el-table :data="orderList" border style="width: 100%">
        <el-table-column prop="orderSn" label="订单号" width="220" />
        <el-table-column prop="body" label="商品描述" />
        <el-table-column prop="totalFee" label="金额" width="100">
          <template #default="{ row }">{{ row.totalFee }} 元</template>
        </el-table-column>
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-tag type="success" v-if="row.status === 1">已支付</el-tag>
            <el-tag type="warning" v-else>待支付</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="160">
          <template #default="{ row }">
            <el-button
              v-if="row.status === 0"
              type="primary"
              size="small"
              @click="openPayDialog(row)"
            >立即支付</el-button>
            <el-button
              v-else
              type="success"
              size="small"
              disabled
            >已完成</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <!-- 支付二维码弹窗 -->
    <el-dialog
      title="微信扫码支付"
      v-model="payDialogVisible"
      width="400px"
      @close="stopPolling"
    >
      <div style="text-align: center;">
        <template v-if="qrcodeUrl && !qrcodeExpired">
          <img :src="qrcodeUrl" alt="支付二维码" style="width: 250px; height: 250px;" />
          <p>请使用微信扫码支付</p>
        </template>

        <template v-else-if="qrcodeExpired">
          <p>二维码已过期</p>
          <el-button type="primary" @click="refreshQRCode">重新生成二维码</el-button>
        </template>

        <template v-else>
          <p>正在生成二维码...</p>
        </template>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { getMyPendingOrder, createWeChatPay, getOrderStatus } from '@/api/student'
import QRCode from 'qrcode'

export default {
  name: 'OrderPage',
  data() {
    return {
      orderList: [],
      payDialogVisible: false,
      currentOrder: null,
      qrcodeUrl: '',
      qrcodeExpired: false,
      pollingTimer: null,
      expireTimer: null
    }
  },
  created() {
    this.loadOrders()
  },
  methods: {
    async loadOrders() {
      try {
        const res = await getMyPendingOrder()
        if (res.code === 0) {
          this.orderList = res.data.orders
        }
      } catch (err) {
        console.error('加载订单失败:', err)
      }
    },

    async openPayDialog(order) {
      this.currentOrder = order
      this.qrcodeUrl = ''
      this.qrcodeExpired = false
      this.payDialogVisible = true
      this.$nextTick(async () => {
        await this.generateQRCode()
        this.startPolling()
        this.startExpireTimer(order.expireTime || new Date(Date.now() + 5 * 60 * 1000))
      })
    },

    async generateQRCode() {
      try {
        const res = await createWeChatPay(this.currentOrder.orderSn)
        console.log('创建支付返回:', res)

        const payUrl = res?.data?.payUrl
        console.log('payUrl:', payUrl)

        if (res.code === 0 && payUrl) {
          const base64 = await QRCode.toDataURL(String(payUrl), {
            errorCorrectionLevel: 'H',
            width: 250
          })
          console.log("二维码Base64长度:", base64.length)
          this.qrcodeUrl = base64
          this.qrcodeExpired = false
        } else {
          this.$message.error('生成二维码失败: ' + (res.msg || '未知错误'))
        }
      } catch (err) {
        console.error("生成二维码异常:", err)
        this.$message.error('生成二维码异常')
      }
    },

    refreshQRCode() {
      this.generateQRCode()
      this.startPolling()
      this.startExpireTimer(new Date(Date.now() + 5 * 60 * 1000))
    },

    startExpireTimer(expireTime) {
      if (this.expireTimer) clearTimeout(this.expireTimer)
      const expireMs = new Date(expireTime).getTime() - Date.now()

      this.expireTimer = setTimeout(() => {
        this.qrcodeExpired = true
        //this.stopPolling()
      }, 5 * 60 * 1000)
    },

    startPolling() {
      if (this.pollingTimer) clearInterval(this.pollingTimer)
      this.pollingTimer = setInterval(async () => {
        const res = await getOrderStatus({ orderSn: this.currentOrder.orderSn })
        if (res.code === 0 && res.data.status === 1) {
          this.$message.success('支付成功！')
          this.stopPolling()
          this.payDialogVisible = false
          this.loadOrders()
        }
      }, 3000)
    },

    stopPolling() {
      if (this.pollingTimer) clearInterval(this.pollingTimer)
    }
  },
  beforeDestroy() {
    this.stopPolling()
    if (this.expireTimer) clearTimeout(this.expireTimer)
  }
}
</script>

<style scoped>
.table-header {
  font-size: 16px;
  font-weight: bold;
  padding-bottom: 10px;
}
</style>
