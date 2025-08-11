<template>
  <div class="order-detail-container">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>订单详情</span>
          <el-button type="primary" size="small" @click="goBack">返回</el-button>
        </div>
      </template>

      <el-descriptions
        v-loading="loading"
        :column="2"
        border
        label-class-name="desc-label"
        content-class-name="desc-content"
      >
        <el-descriptions-item label="订单号">{{ order.order_sn }}</el-descriptions-item>
        <el-descriptions-item label="交易号">{{ order.transaction_id }}</el-descriptions-item>
        <el-descriptions-item label="用户ID">{{ order.user_id }}</el-descriptions-item>
        <el-descriptions-item label="用户名">{{ order.user_name }}</el-descriptions-item>
        <el-descriptions-item label="金额(元)">{{ (order.amount / 100).toFixed(2) }}</el-descriptions-item>
        <el-descriptions-item label="支付方式">{{ order.pay_type }}</el-descriptions-item>
        <el-descriptions-item label="订单状态">
          <el-tag :type="statusType(order.status)">{{ statusText(order.status) }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="创建时间">{{ order.created_at }}</el-descriptions-item>
        <el-descriptions-item label="支付时间">{{ order.paid_at || '-' }}</el-descriptions-item>
        <el-descriptions-item label="备注">{{ order.remark || '-' }}</el-descriptions-item>
      </el-descriptions>
    </el-card>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { getOrderDetail } from '@/api/student' // 你需要创建这个 API 方法

const route = useRoute()
const router = useRouter()

const loading = ref(false)
const order = ref({})

const fetchOrderDetail = async () => {
  /*const orderSn = route.params.orderSn
  if (!orderSn) {
    ElMessage.error('订单号缺失')
    return router.push('/order')
  }
  loading.value = true
  try {
    const res = await getOrderDetail({ order_sn: orderSn })
    if (res.code === 0) {
      order.value = res.data
    } else {
      ElMessage.error(res.msg || '获取订单详情失败')
    }
  } catch (err) {
    ElMessage.error('请求失败')
  } finally {
    loading.value = false
  }*/
}

const goBack = () => {
  router.back()
}

const statusText = (status) => {
  const map = {
    0: '未支付',
    1: '已支付',
    2: '已取消',
    3: '已退款'
  }
  return map[status] || '未知'
}

const statusType = (status) => {
  const map = {
    0: 'info',
    1: 'success',
    2: 'danger',
    3: 'warning'
  }
  return map[status] || 'info'
}

onMounted(() => {
  fetchOrderDetail()
})
</script>

<style scoped>
.order-detail-container {
  padding: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.desc-label {
  font-weight: bold;
}

.desc-content {
  color: #333;
}
</style>
