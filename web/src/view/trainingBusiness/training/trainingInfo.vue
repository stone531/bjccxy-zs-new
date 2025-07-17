<template>
  <div class="certificate-wrapper">
    <h1 class="title">北京长城研修学院</h1>
    <h2 class="subtitle">培训证书查询</h2>
    
    <!-- 基本信息 -->
    <div class="custom-divider">
      <span class="divider-title">基本信息</span>
      <div class="divider-line" />
    </div>
    
    <!-- 使用网格布局确保完美对齐 -->
    <div class="grid-table">
      <!-- 第一行 -->
      <div class="grid-label">姓 名</div>
      <div class="grid-content">{{ info.name }}</div>
      <div class="grid-label">性 别</div>
      <div class="grid-content">{{ getGenderLabel(info.gender) }}</div>
      
      <!-- 第二行 -->
      <div class="grid-label">身份证号码</div>
      <div class="grid-content">{{ info.id_card_number }}</div>
      <div class="grid-label"></div>
      <div class="grid-content"></div>
   
    </div>

    <!-- 证书信息 -->
    <div class="custom-divider">
      <span class="divider-title">证书信息</span>
      <div class="divider-line" />
    </div>
    
    <!-- 使用完全相同的网格布局 -->
    <div class="grid-table">
      <!-- 第一行 -->
      <div class="grid-label">证书名称</div>
      <div class="grid-content">{{ info.certificate_name }}</div>
      <div class="grid-label">培训项目</div>
      <div class="grid-content">{{ info.training_program }}</div>
      
      <!-- 第二行 -->
      <div class="grid-label">证书编号</div>
      <div class="grid-content">{{ info.certificate_id }}</div>
      <div class="grid-label">发证日期</div>
      <div class="grid-content">{{ info.issue_date }}</div>
      
      <!-- 第三行 -->
      <div class="grid-label">成绩评定</div>
      <div class="grid-content">{{ info.grade }}</div>
      <div class="grid-label"></div>
      <div class="grid-content"></div>
    </div>

    <div class="footer-text">
      <p>以上查询服务由北京长城研修学院</p>
      <p>国家职业资格工作网提供技术平台</p>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
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
const loading = ref(true)
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
      Object.assign(info, res.data)
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

.custom-divider {
  margin: 30px 0 20px;
  position: relative;
}

.divider-title {
  font-size: 20px;
  font-weight: bold;
  color: #0057b7;
  background: white;
  padding: 0 15px;
  position: relative;
  z-index: 2;
}

.divider-line {
  position: absolute;
  top: 50%;
  left: 0;
  width: 100%;
  height: 2px;
  background-color: #409EFF;
  z-index: 1;
}

/* 完美对齐的网格布局解决方案 */
.grid-table {
  display: grid;
  grid-template-columns: 120px 1fr 120px 1fr; /* 固定标签宽度 + 弹性内容宽度 */
  border: 1px solid #EBEEF5;
  border-bottom: none;
  margin-bottom: 16px;
}

.grid-label, .grid-content {
  padding: 12px 15px;
  border-bottom: 1px solid #EBEEF5;
}

/* 标签列样式 - 完全统一 */
.grid-label {
  background-color: #f0f7ff;
  font-weight: 600;
  color: #1e3a8a;
  text-align: center;
  
  /* 确保所有标签列宽度一致 */
  width: 120px;
  min-width: 120px;
  max-width: 120px;
}

/* 内容列样式 - 完全统一 */
.grid-content {
  padding-left: 20px;
  
  /* 确保所有内容列宽度一致 */
  width: 100%;
  min-width: 0; /* 允许内容收缩 */
}

/* 为右侧标签添加左边框 */
.grid-label:nth-child(3) {
  border-left: 1px solid #EBEEF5;
}

/* 为右侧内容添加左边框 */
.grid-content:nth-child(4) {
  border-left: 1px solid #EBEEF5;
}

/* 确保最后一行边框完整 */
.grid-table > :nth-last-child(-n+4) {
  border-bottom: 1px solid #EBEEF5;
}

</style>
