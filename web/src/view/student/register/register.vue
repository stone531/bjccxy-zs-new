<template>
  <div class="register-container">
    <el-card class="register-card">
      <h2 style="text-align: center;">学生注册</h2>

      <el-form :model="form" :rules="rules" ref="registerForm" label-width="80px">
        <el-form-item label="邮箱" prop="email">
          <el-input v-model="form.email" placeholder="请输入邮箱"></el-input>
        </el-form-item>

        <el-form-item label="验证码" prop="code">
          <el-row :gutter="10">
            <el-col :span="14">
              <el-input v-model="form.code" placeholder="请输入验证码"></el-input>
            </el-col>
            <el-col :span="10">
              <el-button :disabled="countdown > 0" @click="sendCode">
                {{ countdown > 0 ? `${countdown}s后重试` : '获取验证码' }}
              </el-button>
            </el-col>
          </el-row>
        </el-form-item>

        <el-form-item label="密码" prop="password">
          <el-input v-model="form.password" show-password placeholder="设置密码"></el-input>
        </el-form-item>

        <el-form-item label="密码确认" prop="repassword">
          <el-input v-model="form.repassword" show-password placeholder="重新输入密码"></el-input>
        </el-form-item>

        <el-form-item>
          <el-checkbox v-model="form.agreed">
            我已阅读并同意
            <a href="/student/user-agreement" target="_blank">《用户协议》</a>
            和
            <a href="/student/privacy-policy" target="_blank">《隐私政策》</a>
          </el-checkbox>
        </el-form-item>

        <el-form-item>
          <el-button
            type="primary"
            :disabled="!form.agreed"
            @click="handleRegister"
            style="width: 100%;"
          >
            立即注册
          </el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { ElMessage } from 'element-plus'
import { sendStudentCodeApi, registerStudentApi } from '@/api/student'
import { useRouter } from 'vue-router'

const router = useRouter()
const registerForm = ref()

const form = reactive({
  email: '',
  code: '',
  password: '',
  repassword:'',
  agreed: false
})

const countdown = ref(0)
let timer = null

const sendCode = async () => {
  if (!form.email || !/^.+@.+\..+$/.test(form.email)) {
    ElMessage.warning('请输入有效的邮箱')
    return
  }

  try {
    await sendStudentCodeApi({ email: form.email })
    ElMessage.success('验证码已发送')
    countdown.value = 60
    timer = setInterval(() => {
      countdown.value--
      if (countdown.value <= 0) clearInterval(timer)
    }, 1000)
  } catch (e) {
    ElMessage.error(e.msg || '验证码发送失败')
  }
}

const handleRegister = async () => {
  await registerForm.value.validate()
  if (!form.agreed) {
    ElMessage.warning('请先阅读并同意相关协议')
    return
  }
  try {
    await registerStudentApi(form)
    ElMessage.success('注册成功，请前往登录')
    router.push('/student/login')
  } catch (e) {
    ElMessage.error(e.msg || '注册失败')
  }
}

const rules = {
  email: [{ required: true, message: '请输入邮箱', trigger: 'blur' }],
  code: [{ required: true, message: '请输入验证码', trigger: 'blur' }],
  password: [{ required: true, message: '请输入密码', trigger: 'blur' }]
}
</script>

<style scoped>
.register-container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
}
.register-card {
  width: 420px;
  padding: 24px;
}
a {
  color: #409eff;
  margin: 0 4px;
  text-decoration: none;
}
a:hover {
  text-decoration: underline;
}
</style>
