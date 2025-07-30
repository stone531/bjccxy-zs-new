<!-- src/views/student/Info.vue -->
<template>
  <div class="student-info">
    <h2 class="title">学生账号信息</h2>

    <!-- 账号（不可修改） -->
    <div class="info-row">
      <div class="label">账号</div>
      <div class="value">{{ student.useraccount }}</div>
      <div class="action">
        <el-button size="small" disabled>不可修改</el-button>
      </div>
    </div>

    <!-- 密码 -->
    <div class="info-row">
      <div class="label">密码</div>
      <div class="value">
        <span v-if="!editField.password">********</span>
        <div v-else>
          <el-input v-model="form.oldPassword" type="password" placeholder="请输入新密码" />
          <el-input v-model="form.password" type="password" placeholder="请输入新密码" />
          <el-input v-model="form.passwordConfirm" type="password" placeholder="请再次输入" style="margin-top: 8px" />
          <el-button type="primary" @click="saveField('password')" size="small">保存</el-button>
          <el-button @click="cancelEdit('password')" size="small">取消</el-button>
        </div>
      </div>
      <div class="action">
        <el-button size="small" @click="toggleEdit('password')">
          {{ editField.password ? '收起' : '修改' }}
        </el-button>
      </div>
    </div>

    <!-- 姓名 -->
    <div class="info-row">
      <div class="label">姓名</div>
      <div class="value">
        <span v-if="!editField.name">{{ student.name || '未填写' }}</span>
        <div v-else>
          <el-input v-model="form.name" placeholder="请输入姓名" />
          <el-button type="primary" @click="saveField('name')" size="small">保存</el-button>
          <el-button @click="cancelEdit('name')" size="small">取消</el-button>
        </div>
      </div>
      <div class="action">
        <el-button size="small" @click="toggleEdit('name')">
          {{ editField.name ? '收起' : '修改' }}
        </el-button>
      </div>
    </div>

    <!-- 邮箱 -->
    <div class="info-row">
      <div class="label">邮箱</div>
      <div class="value">
        <span v-if="!editField.email">{{ student.email || '未填写' }}</span>
        <div v-else>
          <el-input v-model="form.email" placeholder="请输入邮箱" />
          <el-button type="primary" @click="saveField('email')" size="small">保存</el-button>
          <el-button @click="cancelEdit('email')" size="small">取消</el-button>
        </div>
      </div>
      <div class="action">
        <el-button size="small" @click="toggleEdit('email')">
          {{ editField.email ? '收起' : '修改' }}
        </el-button>
      </div>
    </div>

    <!-- 身份证 -->
    <div class="info-row">
      <div class="label">身份证</div>
      <div class="value">
        <span v-if="!editField.idCard">{{ student.id_card_number || '未填写' }}</span>
        <div v-else>
          <el-input v-model="form.idCard" placeholder="请输入身份证号码" />
          <el-button type="primary" @click="saveField('idCard')" size="small">保存</el-button>
          <el-button @click="cancelEdit('idCard')" size="small">取消</el-button>
        </div>
      </div>
      <div class="action">
        <el-button size="small" @click="toggleEdit('idCard')">
          {{ editField.idCard ? '收起' : '修改' }}
        </el-button>
      </div>
    </div>
  </div>
</template>


<script setup>
import { reactive, computed, onMounted } from 'vue'
import { useStudentStore } from '@/pinia/modules/student'
import { ElMessage } from 'element-plus'
import { getStudentInfo } from '@/api/student'

const studentStore = useStudentStore()

// 直接用 computed 绑定 store，保证刷新数据时会更新
const student = computed(() => studentStore.studentInfo)

// 控制哪些字段处于编辑状态
const editField = reactive({
  password: false,
  name: false,
  email: false,
  idCard: false
})

// 表单数据
const form = reactive({
  oldPassword: '',
  password: '',
  passwordConfirm: '',
  name: '',
  email: '',
  idCard: ''
})

// 切换编辑状态
const toggleEdit = (field) => {
  editField[field] = !editField[field]
}

// 取消编辑
const cancelEdit = (field) => {
  editField[field] = false
}

// 保存修改
const saveField = async (field) => {
  if (field === 'password') {
    if (!form.password || !form.passwordConfirm) {
      return ElMessage.error('请输入新密码并确认')
    }
    if (form.password !== form.passwordConfirm) {
      return ElMessage.error('两次密码输入不一致')
    }
    // TODO: 调用修改密码接口
  }
  // TODO: 其他修改接口
  ElMessage.success('修改成功')
  editField[field] = false
}

// 页面加载时获取学生信息
onMounted(async () => {
  try {
    const res = await getStudentInfo()
    if (res.code === 0 && res.data?.userInfo) {
      // 存到 store
      studentStore.setStudentInfo(res.data.userInfo)

      // 同步到表单
      form.name = res.data.userInfo.name || ''
      form.email = res.data.userInfo.email || ''
      form.idCard = res.data.userInfo.id_card_number || ''
    } else {
      ElMessage.error(res.msg || '获取学生信息失败')
    }
  } catch (err) {
    console.error('请求学生信息失败', err)
    ElMessage.error('请求学生信息失败')
  }
})
</script>


<style scoped>
.student-info {
  max-width: 600px;
  margin: auto;
  padding: 20px;
}
.title {
  margin-bottom: 20px;
}
.info-row {
  display: flex;
  align-items: flex-start;
  margin-bottom: 16px;
}
.label {
  flex: 0 0 100px;
  font-weight: bold;
}
.value {
  flex: 1;
}
.action {
  flex: 0 0 80px;
  text-align: right;
}
</style>
