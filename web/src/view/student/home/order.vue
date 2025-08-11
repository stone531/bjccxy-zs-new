<template>
  <div class="order-page">
    <el-card>
      <div class="table-header">
        <span>订单列表</span>
      </div>

      <el-table :data="orderList" border style="width: 100%">
        <el-table-column prop="orderSn" label="订单号" width="220" />
        <el-table-column prop="CreatedAt" label="订单创建时间" width="180" >
          <template #default="{ row }">
            {{ this.formatDate(row.CreatedAt) }}
          </template>
        </el-table-column>

        <el-table-column prop="body" label="商品描述" width="400"/>
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
              @click="orderDetail(row)"
            >订单详情</el-button>
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
 import dayjs from 'dayjs'

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
      expireTimer: null,
      // 添加重试计数器
      retryCount: 0,
      // 添加最大重试次数常量
      MAX_RETRY_COUNT: 5,
      // 添加重试定时器
      retryTimer: null
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
      // 重置重试计数器
      this.retryCount = 0
      this.payDialogVisible = true
      this.$nextTick(async () => {
        await this.generateQRCode()
        this.startPolling()
        this.startExpireTimer(order.expireTime || new Date(Date.now() + 5 * 60 * 1000))
      })
    },

    async orderDetail(order) {
      this.currentOrder = order

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
          // 重置重试计数器
          this.retryCount = 0
        } else {
          throw new Error(res.msg || '生成二维码失败')
        }
      } catch (err) {
        console.error("生成二维码异常:", err)
        this.handleQRCodeError(err)
      }
    },
    
    formatDate(dateStr) {
      return dateStr ? dayjs(dateStr).format('YYYY-MM-DD HH:mm:ss') : ''
    },

    // 新增：处理二维码生成错误
    handleQRCodeError(err) {
      // 增加重试计数器
      this.retryCount++
      
      // 检查是否达到最大重试次数
      if (this.retryCount >= this.MAX_RETRY_COUNT) {
        this.$message.error('二维码生成失败，请稍后再试')
        this.qrcodeExpired = true
        this.stopPolling()
        return
      }
      
      // 显示重试提示
      const remaining = this.MAX_RETRY_COUNT - this.retryCount
      this.$message.warning(`二维码生成失败，${remaining}秒后重试 (${this.retryCount}/${this.MAX_RETRY_COUNT})`)
      
      // 设置延迟重试（指数退避策略）
      const delay = Math.min(2000 * Math.pow(2, this.retryCount - 1), 10000)
      
      /*const formatDate = (dateStr) => {
        return dateStr ? dayjs(dateStr).format('YYYY-MM-DD HH:mm:ss') : ''
      }*/

      // 清除之前的重试定时器
      if (this.retryTimer) clearTimeout(this.retryTimer)
      
      // 设置新的重试定时器
      this.retryTimer = setTimeout(() => {
        if (this.payDialogVisible) {
          this.generateQRCode()
        }
      }, delay)
    },

    refreshQRCode() {
      // 重置状态
      this.qrcodeExpired = false
      this.retryCount = 0
      
      // 清除之前的重试定时器
      if (this.retryTimer) {
        clearTimeout(this.retryTimer)
        this.retryTimer = null
      }
      
      this.generateQRCode()
      this.startPolling()
      this.startExpireTimer(new Date(Date.now() + 5 * 60 * 1000))
    },

    startExpireTimer(expireTime) {
      if (this.expireTimer) clearTimeout(this.expireTimer)
      const expireMs = new Date(expireTime).getTime() - Date.now()

      this.expireTimer = setTimeout(() => {
        this.qrcodeExpired = true
        this.stopPolling()
      }, 5 * 60 * 1000)
    },

    startPolling() {
      if (this.pollingTimer) clearInterval(this.pollingTimer)
      this.pollingTimer = setInterval(async () => {
        // 如果二维码已过期则停止轮询
        if (this.qrcodeExpired) {
          this.stopPolling()
          return
        }
        
        const res = await getOrderStatus(this.currentOrder.orderSn)
        if (res.code === 0 && res.data.status === 1) {
          this.$message.success('支付成功！')
          this.stopAllTimers()
          this.payDialogVisible = false
          this.loadOrders()
        }
      }, 3000)
    },

    // 新增：停止所有定时器
    stopAllTimers() {
      this.stopPolling()
      if (this.expireTimer) clearTimeout(this.expireTimer)
      if (this.retryTimer) clearTimeout(this.retryTimer)
    },
    
    stopPolling() {
      if (this.pollingTimer) clearInterval(this.pollingTimer)
      this.pollingTimer = null
    }
  },
  beforeDestroy() {
    this.stopAllTimers()
  },
  // 监听弹窗关闭事件
  watch: {
    payDialogVisible(newVal) {
      if (!newVal) {
        this.stopAllTimers()
      }
    }
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
