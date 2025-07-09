<template>
  <div class="certificate-wrapper">
    <h1 class="title">北京长城研修学院</h1>
    <h2 class="subtitle">培训证书查询</h2>

    <el-divider content-position="left">基本信息</el-divider>
    <el-descriptions :column="3" border>
      <el-descriptions-item label="姓 名">{{ info.name }}</el-descriptions-item>
      <el-descriptions-item label="性 别">{{ getGenderLabel(info.gender) }}</el-descriptions-item>
      <el-descriptions-item label=""></el-descriptions-item>

      <el-descriptions-item label="身份证号码" :span="3">{{ info.id_card_number }}</el-descriptions-item>
    </el-descriptions>

    <el-divider content-position="left">证书信息</el-divider>
    <el-descriptions :column="3" border>
      <el-descriptions-item label="证书名称">{{ info.certificate_name }}</el-descriptions-item>
      <el-descriptions-item label="培训项目">{{ info.training_program }}</el-descriptions-item>
      <el-descriptions-item label=""></el-descriptions-item>

      <el-descriptions-item label="证书编号">{{ info.certificate_id }}</el-descriptions-item>
      <el-descriptions-item label="发证日期">{{ info.issue_date }}</el-descriptions-item>
      <el-descriptions-item label=""></el-descriptions-item>

      <el-descriptions-item label="成绩评定">{{ info.grade }}</el-descriptions-item>
    </el-descriptions>

    <div class="footer-text">
      <p>以上查询服务由北京长城研修学院</p>
      <p>国家职业资格工作网提供技术平台</p>
    </div>
  </div>
</template>

<script setup>
import { reactive } from 'vue'
import { getOneTrainStu } from '@/api/user'
import { getBaseUrl } from '@/utils/format'
import { useRoute } from 'vue-router'

// 模拟后台返回的数据结构
const info = reactive({
  name: '',                  // 姓名
  gender: '',                // 性别（1-男，2-女）
  id_card_number: '',        // 身份证号码
  certificate_name: '',      // 证书名称
  training_program: '',      // 培训项目
  certificate_id: '',        // 证书编号
  issue_date: '',            // 发证日期（如：2024年12月31日）
  grade: '',                 // 成绩评定
})

// 性别转换方法
const getGenderLabel = (val) => {
  if (val === 1 || val === '1') return '男'
  if (val === 2 || val === '2') return '女'
  return '未知'
}

const route = useRoute()
const student = reactive({ /* 初始化字段保持不变 */ })
//const loading = ref(true)
const searchInfo = ref({
  type:route.query.type,
  id: route.query.id || 0,  // 优先使用路由参数
  name: route.query.name || '',
  certificate_id: route.query.certificateNo || '',
  id_card_number: route.query.idCard || ''
})

// 获取学生数据
const getStudentData = async () => {
  try {
    loading.value = true
    console.error('recv params:', searchInfo)
    const res = await getOneTrainStu({
      ...searchInfo.value,
      id: Number(searchInfo.value.id) || 0
    })
    
    if (res.code === 0 ) {
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

onMounted(() => {
  if (Object.values(searchInfo.value).some(v => v)) {
    getStudentData()
  } else {
    ElMessage.warning('缺少查询参数')
  }
})

defineOptions({
  name: 'trainStuInfo'
})



</script>

<style scoped>
.certificate-wrapper {
  max-width: 900px;
  margin: 0 auto;
  padding: 40px 20px;
  background-color: #fff;
}

.title {
  text-align: center;
  color: #0057b7;
  font-size: 28px;
  margin-bottom: 10px;
}

.subtitle {
  text-align: center;
  font-size: 20px;
  margin-bottom: 30px;
}

.footer-text {
  text-align: center;
  margin-top: 40px;
  color: #666;
  font-size: 14px;
  line-height: 1.8;
}
</style>
