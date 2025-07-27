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
          <el-form-item label="用户名" prop="usera_ccount">
            <el-input v-model="registerForm.usera_ccount" placeholder="请输入用户名" />
          </el-form-item>

          <el-form-item label="邮  箱" prop="email">
            <el-input v-model="registerForm.email" placeholder="请输入邮箱" />
          </el-form-item>

          <el-form-item label="密  码" prop="password">
            <el-input
              v-model="registerForm.password"
              :type="showPassword ? 'text' : 'password'"
              placeholder="请输入密码"
              suffix-icon="el-icon-view"
              @click-suffix="togglePassword"
            />
          </el-form-item>

          <el-form-item label="确认密码" prop="rePassword">
            <el-input
              v-model="registerForm.rePassword"
              :type="showPassword ? 'text' : 'password'"
              placeholder="请再次输入密码"
              suffix-icon="el-icon-view"
              @click-suffix="togglePassword"
            />
          </el-form-item>

          <el-form-item label="验证码" prop="verification_code">
            <div style="display: flex; align-items: center; width: 100%;">
              <el-input
                v-model="registerForm.verification_code"
                placeholder="请输入6位邮箱验证码"
                maxlength="6"
                style="flex: 1"
              />
              <el-button
                :disabled="codeTimer > 0 || !registerForm.email"
                @click="sendCode"
                style="margin-left: 10px; width: 110px;"
              >
                {{ codeTimer > 0 ? `${codeTimer}s后重发` : '获取验证码' }}
              </el-button>
            </div>
          </el-form-item>

          <el-form-item label-width="0">
            <el-checkbox v-model="registerForm.agreed">
              我已阅读并同意
              <a class="link" href="#/user-agreement" target="_blank">《用户协议》</a>
              和
              <a class="link" href="#/privacy-policy" target="_blank">《隐私政策》</a>
            </el-checkbox>
          </el-form-item>

          <el-form-item label-width="0">
            <el-button
              type="primary"
              style="width: 100%"
              :disabled="!registerForm.agreed"
              @click="submitForm"
            >
              立即注册
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
import {sendStudentCodeApi, register} from '@/api/student'
import MD5 from 'crypto-js/md5';
import logo from '@/assets/logo.jpg'

export default {
  name: 'Register',
  data() {
    return {
    logo,
    showPassword: false,
    registerForm: {
      usera_ccount: '',
      email: '',
      password: '',
      rePassword: '',
      agreed: false,
      verification_code: '',
    },
    codeTimer: 0,
    codeTimerInterval: null,
    rules: {}, // 先留空
   }
 },

 created() {
  this.rules = {
    usera_ccount: [
      { required: true, message: '请输入用户名', trigger: 'blur' },
      {
        min: 5,
        max: 12,
        message: '用户名长度应为 5-12 位',
        trigger: 'blur',
      },
    ],
    email: [
      { required: true, message: '请输入邮箱', trigger: 'blur' },
      {
        type: 'email',
        message: '邮箱格式不正确',
        trigger: ['blur', 'change'],
      },
    ],
    password: [
      {
        required: true,
        message: '请输入密码',
        trigger: 'blur',
      },
      {
        min: 6,
        max: 12,
        message: '密码长度应为 6-12 位',
        trigger: 'blur',
      },
    ],
    rePassword: [
      {
        required: true,
        validator: (rule, value, callback) => {
          if (value !== this.registerForm.password) {
            callback(new Error('两次输入的密码不一致'))
          } else {
            callback()
          }
        },
        trigger: 'blur'
      }
    ],
    verification_code: [
      { required: true, message: '请输入验证码', trigger: 'blur' },
      { min: 6, max: 6, message: '验证码为6位', trigger: 'blur' },
    ]
    }
 },
 
  methods: {
    togglePassword() {
      this.showPassword = !this.showPassword
    },
    
    async submitForm() {
      this.$refs.registerFormRef.validate(async (valid) => {
        if (valid) {
          // 创建表单副本，避免直接修改原数据
          const formData = { ...this.registerForm };
          
          // 对密码进行 MD5 加密
          if (formData.password) {
            formData.password = MD5(formData.password).toString();
            formData.rePassword = '';
          }

          try {
            const res = await register(formData); // 发送加密后的数据
            if (res.code == 0) {
              this.$message.success('注册成功，请登录');
              this.resetUserFunc();
              // this.$router.push({ name: 'login' });
            } else {
              this.$message.error(res.message || '注册失败');
            }
          } catch (error) {
            this.$message.error('请求失败，请稍后重试');
            console.error('注册请求错误:', error);
          }
        } else {
          this.$message.error('请检查填写内容');
        }
      });
    },

    resetUserFunc() {
      Object.assign(this.registerForm, {
        usera_ccount: '',
        email: '',
        password: '',
        rePassword: '',
        agreed: false,
        verification_code: '',
      })
    },

    sendCode() {
      const email = this.registerForm.email
      if (!email) {
        this.$message.warning('请先输入邮箱')
        return
      }

      // 假设有API叫 sendEmailCode(email)
      sendStudentCodeApi({ email })
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

    beforeDestroy() {
      if (this.codeTimerInterval) {
        clearInterval(this.codeTimerInterval)
      }
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
