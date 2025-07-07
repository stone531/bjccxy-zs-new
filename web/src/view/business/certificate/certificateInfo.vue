<template>
  <div class="student-detail-container">
    <div class="title-box">
      <p class="main-title">为方便用人单位核实毕业证，我院推出电子注册毕业证查询系统。</p>
      <p class="sub-title">请认真填写下面的各项内容，查询系统将按照您填写的资料进行数据库搜索。</p>
    </div>

    <el-row justify="center" class="info-box">
      <el-col :xs="24" :sm="18" :md="16">
        <el-descriptions column="2" border class="info-descriptions">
          <!-- 所有描述项保持原结构 -->
          <el-descriptions-item label="姓名">{{ student.name }}</el-descriptions-item>
          <el-descriptions-item label="性别">{{ formatGender(student.sex) }}</el-descriptions-item>
          
          <el-descriptions-item label="出生年月">{{ student.age }}</el-descriptions-item>
          <el-descriptions-item label="民族">{{ student.mingzhu }}</el-descriptions-item>

          <el-descriptions-item label="政治面貌">{{ student.zzmm }}</el-descriptions-item>
          <el-descriptions-item label="籍贯">{{ student.nativeplace }}</el-descriptions-item>

          <el-descriptions-item label="层次">{{ student.chengchi }}</el-descriptions-item>
          <el-descriptions-item label="身份证号">{{ student.certificatenumber2 }}</el-descriptions-item>

          <el-descriptions-item label="专业">{{ student.zhuanye }}</el-descriptions-item>
          <el-descriptions-item label="毕业证号">{{ student.graduschool }}</el-descriptions-item>

          <el-descriptions-item label="毕业院校">{{ student.graduschool2 }}</el-descriptions-item>
          <el-descriptions-item label="毕业时间">{{ student.bysj }}</el-descriptions-item>
          
          <el-descriptions-item label="自我鉴定" :span="2">
            {{ student.zwjd }}
          </el-descriptions-item>
        </el-descriptions>
      </el-col>
      
      <el-col :xs="24" :sm="6" :md="6" class="avatar-box">
        <el-image
          :src="getFullImageUrl(student.pic)"
          fit="cover"
          class="student-avatar"
        />
      </el-col>
    </el-row>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { getOneZhengshu } from '@/api/user'
import { getBaseUrl } from '@/utils/format'
//import defaultAvatar from '@/assets/default-avatar.png' // 添加默认头像

const route = useRoute()
const student = reactive({ /* 初始化字段保持不变 */ })
const loading = ref(true)
const searchInfo = ref({
  id: route.query.id || 0,  // 优先使用路由参数
  name: route.query.name || '',
  graduschool: route.query.certificateNo || '',
  certificatenumber2: route.query.idCard || ''
})

// 格式化性别显示
const formatGender = (val) => {
  return val === 1 ? '男' : val === 2 ? '女' : '未知'
}

// 获取学生数据
const getStudentData = async () => {
  try {
    loading.value = true
    const res = await getOneZhengshu({
      //page: 1,
      //pageSize: 1,
      ...searchInfo.value,
      id: Number(searchInfo.value.id) || 0
    })
    
    if (res.code === 0 ) {
      //console.log("Composition API 调试信息pic:",res.data.list[0].pic);
      //Object.assign(student, res.data.list[0])
      Object.assign(student, res.data)
    }
  } catch (error) {
    console.error('获取证书信息失败:', error)
    ElMessage.error('数据加载失败，请稍后重试')
  } finally {
    loading.value = false
  }
}

const getFullImageUrl = (url) => {
  if (!url) return '' // 防止空值报错
  if (/^https?:\/\//.test(url)) return url
  return `${getBaseUrl()}/` + url
}

onMounted(() => {
  if (Object.values(searchInfo.value).some(v => v)) {
    getStudentData()
  } else {
    ElMessage.warning('缺少查询参数')
  }
})

defineOptions({
  name: 'CertificateInfo'
})
</script>

<style scoped>
.student-detail-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
  background: #fff;
  border: 1px solid #ebedf0;
  border-radius: 4px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.05);
}

.title-box {
  text-align: center;
  margin-bottom: 30px;
  padding: 15px;
  background: #f8f9fa;
  border-radius: 4px;
}

.main-title {
  font-size: 20px;
  color: #e53935;
  font-weight: bold;
  margin: 10px 0;
}

.sub-title {
  color: #f56c6c;
  font-weight: 500;
  font-size: 15px;
}

.info-box {
  margin-top: 20px;
  display: flex;

}

.avatar-box {
  display: flex;
  justify-content: flex-start;
  margin-top: 20px;
  margin-left: -5px; 
}

.student-avatar {
  width: 150px;
  height: 200px;
  border: 1px solid #dcdfe6;
  border-radius: 4px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

/* 响应式调整 */
@media (min-width: 768px) {
  .avatar-box {
    margin-top: 0;
    justify-content: flex-end;
  }
  
  .info-descriptions {
    margin-right: 20px;
  }
}

/* 优化描述列表样式 */
:deep(.el-descriptions__body) {
  background-color: #fafafa;
}

:deep(.el-descriptions__label) {
  width: 100px;
  font-weight: 500;
  color: #606266;
}

:deep(.el-descriptions__content) {
  color: #303133;
}
</style>