<template>
  <el-container class="login-register-box">
    <vue-particle-line />
    <el-main class="login-box">

      <h1 class="title-1">
        <img class="logo" :src="logo" />
      </h1>
      <div class="main">
        <el-form
          ref="registerFormRef"
          :model="registerForm"
          :rules="rules"
          label-position="left"
          label-width="90px"
        >
          <el-form-item label="用户名" prop="userName">
            <el-input v-model="registerForm.userName" placeholder="请输入用户名" />
          </el-form-item>

          <el-form-item label="邮  箱" prop="email">
            <el-input v-model="registerForm.email" placeholder="请输入邮箱" />
          </el-form-item>

          

          <el-form-item label-width="0">
            <el-button
              type="primary"
              style="width: 100%"
              :disabled="!registerForm.agreed"
              @click="submitForm"
            >
              提交
            </el-button>
          </el-form-item>

          <el-form-item label-width="0">
            <el-button
              type="text"
              style="width: 100%"
              @click="$router.push('/student-login')"
            >
              返回登录
            </el-button>
          </el-form-item>
        </el-form>
      </div>
    </el-main>
  </el-container>
</template>

<script>

import {initPassword} from '@/api/student'
import logo from '@/assets/logo.jpg'

export default {
  name: 'RetrivevPassword',
  data() {
    return {
      logo,
      showPassword: false,
      registerForm: {
        userName: '',
        email: '',
      },
      
      rules: {
        userName: [
          { required: true, message: '请输入注册用户名', trigger: 'blur' },
          
        ],
        email: [
          { required: true, message: '请输入注册邮箱', trigger: 'blur' },
          {
            type: 'email',
            message: '邮箱格式不正确',
            trigger: ['blur', 'change'],
          },
        ],
        
        
        
      },
    }
  },
  methods: {
    async submitForm() {
      this.$refs.registerFormRef.validate(async (valid) => {
        if (valid) {
          const res = await initPassword(this.registerForm)
          if (res.success) {
            this.$message.success('密码初始化成功，密码已发送到您的邮箱，请及时登录修改')
            this.$router.push({ name: 'login' })
          } else {
            this.$message.error(res.message || '提交的用户名和邮箱不匹配')
          }
        } else {
          this.$message.error('请检查填写内容')
        }
      })
    },

    sendCode() {
      const email = this.registerForm.email
      if (!email) {
        this.$message.warning('请先输入邮箱')
        return
      }

      // 假设有API叫 sendEmailCode(email)
      sendStudentCodeApi(email)
      this.$message.success(`验证码已发送到 ${email}`)

      // 启动倒计时
      this.codeTimer = 60
      this.codeTimerInterval = setInterval(() => {
        this.codeTimer--
        if (this.codeTimer <= 0) {
          clearInterval(this.codeTimerInterval)
          this.codeTimerInterval = null
        }
      }, 1000)
    },

  },
}
</script>

<style scoped lang="scss">
.login-register-box {
  background: #fff;
  height: 100vh;
  .login-box {
    width: 90vw;
    max-width: 500px;
    margin: 0 auto;
    padding-top: 5vh;
    .logo {
      height: 14vh;
      width: auto;
    }
    .main {
      margin-top: 20px;
      width: 100%;
      max-width: 400px;
      margin-left: auto;
      margin-right: auto;
    }
  }
}

.link {
  color: #409EFF;
  text-decoration: none;
  margin: 0 2px;
}
.link:hover {
  text-decoration: underline;
}
.warning-bar-text {
  color: red;
  white-space: pre-line;
}
</style>
