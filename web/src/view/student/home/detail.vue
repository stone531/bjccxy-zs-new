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
        <el-descriptions-item label="订单号">{{ order.orderSn }}</el-descriptions-item>
        <el-descriptions-item label="交易号">{{ order.transactionId }}</el-descriptions-item>
        <el-descriptions-item label="用户ID">{{ order.userId }}</el-descriptions-item>
        <el-descriptions-item label="用户名">{{ order.user_name }}</el-descriptions-item>
        <el-descriptions-item label="金额(元)">{{ (order.totalFee / 100).toFixed(2) }}</el-descriptions-item>
        <el-descriptions-item label="支付方式">{{ order.payType }}</el-descriptions-item>
        <el-descriptions-item label="订单状态">
          <el-tag :type="statusType(order.status)">{{ statusText(order.status) }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="创建时间">{{ order.createdAt }}</el-descriptions-item>
        <el-descriptions-item label="支付时间">{{ order.paid_at || '-' }}</el-descriptions-item>
        <el-descriptions-item label="备注">{{ order.extra_field1 || '-' }}</el-descriptions-item>
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
const searchInfo = ref({
  id: route.query.id || 0,  // 优先使用路由参数
  sn: route.query.sn || ''
})

const fetchOrderDetail = async () => {
  const orderSn = searchInfo.value.sn
  if (!orderSn) {
    ElMessage.error('订单号缺失')
    return router.push('/student/order')
    console.error("fetchOrderDetail:",orderSn)
    return
  }
  loading.value = true
  try {
    const res = await getOrderDetail(orderSn)
    if (res.code === 0) {
      order.value = res.data
    } else {
      ElMessage.error(res.msg || '获取订单详情失败')
    }
  } catch (err) {
    ElMessage.error('请求失败')
  } finally {
    loading.value = false
  }
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
  if (Object.values(searchInfo.value).some(v => v)) {
    console.error("detail:",searchInfo.value.id,searchInfo.value.sn)
    fetchOrderDetail()
  } else {
    ElMessage.warning('缺少查询参数')
  }

  
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
