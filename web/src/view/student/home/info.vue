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
        <el-form
          v-else
          ref="passwordFormRef"
          :model="form"
          :rules="rules"
          label-width="0"
        >
          <el-form-item prop="oldPassword">
            <el-input v-model="form.oldPassword" type="password" placeholder="请输原密码" />
          </el-form-item>
          <el-form-item prop="password">
            <el-input v-model="form.password" type="password" placeholder="请输入新密码" />
          </el-form-item>
          <el-form-item prop="passwordConfirm">
            <el-input v-model="form.passwordConfirm" type="password" placeholder="请再次输入" />
          </el-form-item>
          <el-button type="primary" @click="saveField('password')" size="small">保存</el-button>
          <el-button @click="cancelEdit('password')" size="small">取消</el-button>
        </el-form>
      </div>
      <div class="action">
        <el-button size="small" @click="toggleEdit('password')">
          {{ editField.password ? '收起' : '修改' }}
        </el-button>
      </div>
    </div>

    <!-- 姓名 -->
    <div class="info-row">
      <div class="label required">姓名</div>
      <div class="value">
        <span v-if="!editField.name">{{ student.name || '未填写' }}</span>
        <el-form v-else ref="nameFormRef" :model="form" :rules="rules" label-width="0">
          <el-form-item prop="name">
            <el-input v-model="form.name" placeholder="请输入姓名" />
          </el-form-item>
          <el-button type="primary" @click="saveField('name')" size="small">保存</el-button>
          <el-button @click="cancelEdit('name')" size="small">取消</el-button>
        </el-form>
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
        <el-form v-else ref="emailFormRef" :model="form" :rules="rules" label-width="0">
          <el-form-item prop="email">
            <el-input v-model="form.email" placeholder="请输入邮箱" />
          </el-form-item>
          <el-button type="primary" @click="saveField('email')" size="small">保存</el-button>
          <el-button @click="cancelEdit('email')" size="small">取消</el-button>
        </el-form>
      </div>
      <div class="action">
        <el-button size="small" @click="toggleEdit('email')">
          {{ editField.email ? '收起' : '修改' }}
        </el-button>
      </div>
    </div>

    <!-- 身份证 -->
    <div class="info-row">
      <div class="label required">身份证</div>
      <div class="value">
        <span v-if="!editField.idCard">{{ student.id_card_number || '未填写' }}</span>
        <el-form v-else ref="idCardFormRef" :model="form" :rules="rules" label-width="0">
          <el-form-item prop="idCard">
            <el-input v-model="form.idCard" placeholder="请输入身份证号码" />
          </el-form-item>
          <el-button type="primary" @click="saveField('idCard')" size="small">保存</el-button>
          <el-button @click="cancelEdit('idCard')" size="small">取消</el-button>
        </el-form>
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
import { reactive, computed, onMounted, ref } from 'vue'
import { useStudentStore } from '@/pinia/modules/student'
import { ElMessage } from 'element-plus'
import { getStudentInfo ,updateStudentField,changePassword} from '@/api/student'
import MD5 from 'crypto-js/md5';

const studentStore = useStudentStore()
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
  oldPassword:'',
  password: '',
  passwordConfirm: '',
  name: '',
  email: '',
  idCard: ''
})

// 表单验证规则
const rules = {
  name: [{ required: true, message: '请输入姓名', trigger: 'blur' }],
  email: [
    { required: true, message: '请输入邮箱', trigger: 'blur' },
    { type: 'email', message: '邮箱格式不正确', trigger: 'blur' }
  ],
  idCard: [
    { required: true, message: '请输入身份证号码', trigger: 'blur' },
    { pattern: /^\d{15}$|^\d{17}[\dXx]$/, message: '身份证格式不正确', trigger: 'blur' }
  ],
  oldPassword: [
    { required: true, message: '请输入原来密码', trigger: 'blur' },
    { min: 6, message: '密码至少6位', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入新密码', trigger: 'blur' },
    { min: 6, message: '密码至少6位', trigger: 'blur' }
  ],
  passwordConfirm: [
    {
      validator: (rule, value, callback) => {
        if (value !== form.password) {
          callback(new Error('两次密码输入不一致'))
        } else {
          callback()
        }
      },
      trigger: 'blur'
    }
  ]
}

// 打开某个编辑时关闭其他编辑
const toggleEdit = (field) => {
  if (editField[field]) {
    editField[field] = false
  } else {
    Object.keys(editField).forEach(k => editField[k] = false)
    editField[field] = true
  }
}

// 取消编辑
const cancelEdit = (field) => {
  editField[field] = false
}

// 保存修改
const saveField = async (field) => {
  const formRefMap = {
    password: passwordFormRef.value,
    name: nameFormRef.value,
    email: emailFormRef.value,
    idCard: idCardFormRef.value
  }

  const formRef = formRefMap[field]
  if (!formRef) return

  try {
    const valid = await formRef.validate()
    if (!valid) return

    const fieldMap = {
      name: 'name',
      email: 'email',
      idCard: 'id_card_number'
    }

    let res
    if (field === 'password') {
      res = await changePassword({
        oldPassword: MD5(form.oldPassword).toString(),  // 旧密码 
        newPassword: MD5(form.password).toString()      // 新密码
      })
      form.oldPassword = ''
      form.password = ''
      form.passwordConfirm = ''
    } else {
      res = await updateStudentField({
        field: fieldMap[field],
        value: form[field]
      })
    }

    if (res.code === 0) {
      ElMessage.success('修改成功')
      editField[field] = false

      try {
        const infoRes = await getStudentInfo()
        if (infoRes.code === 0 && infoRes.data?.userInfo) {
          studentStore.setStudentInfo(infoRes.data.userInfo)

          // 同步到表单
          form.name = infoRes.data.userInfo.name || ''
          form.email = infoRes.data.userInfo.email || ''
          form.idCard = infoRes.data.userInfo.id_card_number || ''
        }
      } catch (e) {
        console.error('刷新学生信息失败', e)
      }
      
    } else {
      ElMessage.error(res.msg || '修改失败')
    }
  } catch (err) {
    console.error('保存失败', err)
    ElMessage.error('请求失败')
  }
}

// 表单 ref
const passwordFormRef = ref()
const nameFormRef = ref()
const emailFormRef = ref()
const idCardFormRef = ref()

// 初始化获取学生信息
onMounted(async () => {
  try {
    const res = await getStudentInfo()
    if (res.code === 0 && res.data?.userInfo) {
      studentStore.setStudentInfo(res.data.userInfo)
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
  font-size: 24px; /* 比默认 h4 大很多 */
  font-weight: bold;
  margin-bottom: 20px;
}
.info-row {
  display: flex;
  align-items: flex-start;
  margin-bottom: 16px;
}
.label {
  flex: 0 0 100px; /* 固定宽度，保证对齐 */
  font-weight: bold;
  display: flex;
  align-items: center;
}
.value {
  flex: 1;
}
.action {
  flex: 0 0 80px;
  text-align: right;
}

.label.required::before {
  content: "*";
  color: red;
  display: inline-block;
  width: 1em; /* 预留和非必填一致的宽度 */
  text-align: center;
}
.label:not(.required)::before {
  content: " ";
  display: inline-block;
  width: 1em;
}
</style>
