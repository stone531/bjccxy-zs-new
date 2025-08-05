<template>
  <div class="gva-container">
    <div class="gva-card">

      <!-- 毕业证书 -->
      <el-card class="cert-card">
        <div class="card-header">
          <span class="title">毕业证书</span>
          <el-button type="primary" icon="plus" @click="addCertificate('graduation')">
            增加毕业证书
          </el-button>
        </div>

        <div class="card-body">
          <template v-if="graduationCert">
            <div class="cert-item">
              <div class="cert-info">
                <p>证书名称：{{ graduationCert.name }}</p>
                <p>编号：{{ graduationCert.no }}</p>
                <p>颁发日期：{{ graduationCert.date }}</p>
              </div>
              <el-button size="small" type="primary" plain @click="viewDetails(graduationCert)">
                证书详情
              </el-button>
            </div>
          </template>
          <template v-else>
            <el-empty description="暂无毕业证书"></el-empty>
          </template>
        </div>
      </el-card>

      <!-- 结业证书（多条） -->
      <el-card class="cert-card">
        <div class="card-header">
          <span class="title">结业证书</span>
          <el-button type="primary" icon="plus" @click="addCertificate('completion')">
            增加结业证书
          </el-button>
        </div>

        <div class="card-body">
          <template v-if="completionCertList.length">
            <el-table
              :data="completionCertList"
              border
              size="small"
              style="width: 100%"
            >
              <el-table-column prop="name" label="证书名称" min-width="160" />
              <el-table-column prop="no" label="编号" min-width="120" />
              <el-table-column prop="date" label="颁发日期" min-width="120" />
              <el-table-column label="操作" width="120">
                <template #default="{ row }">
                  <el-button
                    type="primary"
                    size="small"
                    plain
                    @click="viewDetails(row)"
                  >
                    详情
                  </el-button>
                </template>
              </el-table-column>
            </el-table>
          </template>
          <template v-else>
            <el-empty description="暂无结业证书"></el-empty>
          </template>
        </div>
      </el-card>

    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
// API 方法（替换成你的接口）
import { getCertificateList } from '@/api/student'

// 数据
const graduationCert = ref(null) // 毕业证书
const completionCertList = ref([]) // 多个结业证书

// 模拟接口请求
onMounted(async () => {
  /*graduationCert.value = {
    name: '本科毕业证书',
    no: 'GRA-2023-001',
    date: '2023-07-01'
  }
  completionCertList.value = [
    { name: 'Java Web 开发结业证书', no: 'COM-2024-101', date: '2024-05-10' },
    { name: 'Vue 前端进阶结业证书', no: 'COM-2024-202', date: '2024-06-20' }
  ]*/
 try {
  const res = await getCertificateList()
  if (res.code === 0 && res.data?.certicates) {
    // 毕业证书
    if (res.data.certicates.graduationCert) {
      const grad = res.data.certicates.graduationCert
      graduationCert.value = {
        name: grad.major || '',
        no: grad.certificateNum || '',
        date: grad.date || ''
      }
    }

    // 结业证书（映射字段）
    completionCertList.value = (res.data.certicates.completionCert || []).map(item => ({
      name: item.name || '',
      no: item.certificateNum || '',
      date: item.date || ''
    }))
  } else {
    ElMessage.error(res.msg || '获取学生信息失败')
  }
 } catch (err) {
  console.error('请求证书信息列表失败', err)
  ElMessage.error('请求证书信息列表失败')
}
})

// 增加证书
function addCertificate(type) {
  ElMessage.success(`跳转到新增 ${type === 'graduation' ? '毕业证书' : '结业证书'} 页面`)
  // router.push(...)
}

// 查看详情
function viewDetails(cert) {
  ElMessage.success(`查看 ${cert.name} 详情`)
  // router.push(...)
}
</script>

<style scoped>
.gva-card {
  display: flex;
  flex-wrap: wrap;
  gap: 20px;
}
.cert-card {
  flex: 1;
  min-width: 450px;
}
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
}
.cert-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.cert-info p {
  margin: 0;
  font-size: 14px;
}
</style>
