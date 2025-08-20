<template>
  <div id="userLayout" class="w-full h-full relative">
    <div
      class="rounded-lg flex items-center justify-evenly w-full h-full md:w-screen md:h-screen md:bg-[#194bfb] bg-white"
    >
      <div class="md:w-3/5 w-10/12 h-full flex items-center justify-evenly">
        <div
          class="oblique h-[130%] w-3/5 bg-white dark:bg-slate-900 transform -rotate-12 absolute -ml-52"
        />
        <!-- 分割斜块 -->
        <div
          class="z-[999] pt-12 pb-10 md:w-96 w-full rounded-lg flex flex-col justify-between box-border"
        >
          <div>
            
            <div class="flex items-center justify-center">
              <img class="w-[500px] h-[200px] object-contain" :src="myLogo" alt="logo" />
            </div>
            <div class="mb-9">
              <p class="text-center text-3xl font-bold">
                {{ $GIN_VUE_ADMIN.appName }} 
              </p>
              <p class="text-center text-sm font-normal text-gray-500 mt-2.5">
                欢迎来到在线申请证书系统
              </p>
            </div>
            <el-form
              ref="loginForm"
              :model="loginFormData"
              :rules="rules"
              :validate-on-rule-change="false"
              @keyup.enter="submitForm"
            >
              <el-form-item prop="useraccount" class="mb-6">
                <el-input
                  v-model="loginFormData.useraccount"
                  size="large"
                  placeholder="请输入用户名"
                  suffix-icon="user"
                />
              </el-form-item>
              <el-form-item prop="password" class="mb-6">
                <el-input
                  v-model="loginFormData.password"
                  show-password
                  size="large"
                  type="password"
                  placeholder="请输入密码"
                />
              </el-form-item>
              <el-form-item
                v-if="loginFormData.openCaptcha"
                prop="captcha"
                class="mb-6"
              >
                <div class="flex w-full justify-between">
                  <el-input
                    v-model="loginFormData.captcha"
                    placeholder="请输入验证码"
                    size="large"
                    class="flex-1 mr-5"
                  />
                  <div class="w-1/3 h-11 bg-[#c3d4f2] rounded">
                    <img
                      v-if="picPath"
                      class="w-full h-full"
                      :src="picPath"
                      alt="请输入验证码"
                      @click="loginVerify()"
                    />
                  </div>
                </div>
              </el-form-item>
              <el-form-item>
                <div class="flex justify-between items-center w-full">
                  <el-checkbox v-model="checked">记住密码</el-checkbox>
                  
                  <el-link @click="() => $router.push('/student-retrivev-password')" type="primary">
                    找回密码
                  </el-link>
                </div>
              </el-form-item>
              
              <el-form-item class="mb-6">
                <el-button
                  class="shadow shadow-active h-11 w-full"
                  type="primary"
                  size="large"
                  @click="submitForm"
                  >登 录</el-button
                >
              </el-form-item>
              <el-form-item class="mb-6">
                <el-button
                  class="shadow shadow-active h-11 w-full"
                  type="primary"
                  size="large"
                  @click="$router.push('/student-register')"
                  >注 册</el-button
                >
              </el-form-item>
            </el-form>
          </div>
        </div>
      </div>
      <div class="hidden md:block w-1/2 h-full float-right bg-[#194bfb]">
        <img
          class="h-full"
          src="@/assets/login_right_banner.jpg"
          alt="banner"
        />
      </div>
    </div>

    <BottomInfo class="left-0 right-0 absolute bottom-3 mx-auto w-full z-20">
      <!--
      <div class="links items-center justify-center gap-2 hidden md:flex">
        <a href="https://www.gin-vue-admin.com/" target="_blank">
          <img src="@/assets/docs.png" class="w-8 h-8" alt="文档" />
        </a>
        <a href="https://support.qq.com/product/371961" target="_blank">
          <img src="@/assets/kefu.png" class="w-8 h-8" alt="客服" />
        </a>
        <a
          href="https://github.com/flipped-aurora/gin-vue-admin"
          target="_blank"
        >
          <img src="@/assets/github.png" class="w-8 h-8" alt="github" />
        </a>
        <a href="https://space.bilibili.com/322210472" target="_blank">
          <img src="@/assets/video.png" class="w-8 h-8" alt="视频站" />
        </a>
      </div>
      -->
    </BottomInfo>
  </div>
</template>

<script setup>
  import { captcha } from '@/api/user'
  import { checkDB } from '@/api/initdb'
  import BottomInfo from '@/components/bottomInfo/bottomInfo.vue'
  import { onMounted,reactive, ref } from 'vue'
  import { ElMessage } from 'element-plus'
  import { useRouter } from 'vue-router'
  //import { useUserStore } from '@/pinia/modules/user'
  import { useStudentStore } from '@/pinia/modules/student'
  //import { login } from '@/api/student'
  import MD5 from 'crypto-js/md5';
  import myLogo from '@/assets/logo.png'

  defineOptions({
    name: 'StudentLogin'
  })

  const router = useRouter()
  // 验证函数
  const checkUsername = (rule, value, callback) => {
    if (value.length < 5) {
      return callback(new Error('请输入正确的用户名'))
    } else {
      callback()
    }
  }
  const checkPassword = (rule, value, callback) => {
    if (value.length < 6) {
      return callback(new Error('请输入正确的密码'))
    } else {
      callback()
    }
  }

  // 获取验证码
  const loginVerify = async () => {
    const ele = await captcha()
    rules.captcha.push({
      max: ele.data.captchaLength,
      min: ele.data.captchaLength,
      message: `请输入${ele.data.captchaLength}位验证码`,
      trigger: 'blur'
    })
    picPath.value = ele.data.picPath
    loginFormData.captchaId = ele.data.captchaId
    loginFormData.openCaptcha = ele.data.openCaptcha
  }
  loginVerify()

  // 登录相关操作
  const loginForm = ref(null)
  const picPath = ref('')
  const loginFormData = reactive({
    useraccount: '',
    password: '',
    captcha: '',
    captchaId: '',
    openCaptcha: false,
    checked: false,
  })
  const rules = reactive({
    useraccount: [{ validator: checkUsername, trigger: 'blur' }],
    password: [{ validator: checkPassword, trigger: 'blur' }],
    captcha: [
      {
        message: '验证码格式不正确',
        trigger: 'blur'
      }
    ]
  })

  const studentStore = useStudentStore()
  const login = async () => {
    //return await studentStore.LoginIn(loginFormData)
    const payload = { ...loginFormData }
    if (payload.password) {
      payload.password = MD5(payload.password).toString()
    }

    return await studentStore.LoginIn(payload)
  }

  const submitForm = () => {
    loginForm.value.validate(async (v) => {
      if (!v) {
        // 未通过前端静态验证
        ElMessage({
          type: 'error',
          message: '请正确填写登录信息',
          showClose: true
        })
        console.error('submitForm 01')
        await loginVerify()
        return false
      }
  

      // 通过验证，请求登陆
      const flag = await login()
      // 登陆失败，刷新验证码
      if (!flag) {
        console.error('submitForm 04')
        await loginVerify()
        return false
      }
  

      cookieValid()  // 判断是否保存
  
      //const uuid = "aabbccdd"
      /*const uuid = res.data.user.uuid
      if (!uuid) {
        ElMessage.error('未获取到学生 UUID')
        return false
      }*/
      router.push('/student/info')
      //console.error('submitForm 07')
      // 登陆成功
      return true
    })
  }

  // 跳转初始化
  const checkInit = async () => {
    const res = await checkDB()
    if (res.code === 0) {
      if (res.data?.needInit) {
        userStore.NeedInit()
        await router.push({ name: 'Init' })
      } else {
        ElMessage({
          type: 'info',
          message: '已配置数据库信息，无法初始化'
        })
      }
    }
  }

  const register = () => {
      this.$router.push({ name: "register" });
  }

  const forgetPass = ()  => {
      //this.dialogFormVisible = !this.dialogFormVisible;
  }

  // 设置 cookie
const setCookie = (c_name, c_pwd, exdays) => {
  const exdate = new Date()
  exdate.setTime(exdate.getTime() + 24 * 60 * 60 * 1000 * exdays)
  document.cookie = `userName=${c_name};path=/;expires=${exdate.toGMTString()}`
  document.cookie = `userPwd=${c_pwd};path=/;expires=${exdate.toGMTString()}`
}

// 获取 cookie
const getCookie = () => {
  const cookieStr = document.cookie
  if (cookieStr.length > 0) {
    const arr = cookieStr.split('; ')
    for (let i = 0; i < arr.length; i++) {
      const [key, value] = arr[i].split('=')
      if (key === 'userName') loginForm.value.useraccount = value
      if (key === 'userPwd') loginForm.value.password = value
    }
  }
}

// 清除 cookie
const clearCookie = () => {
  setCookie('', '', -1)
}

// 校验是否需要存 cookie
const cookieValid = () => {
  if (loginFormData.checked.value) {
    setCookie(loginForm.value.useraccount, loginForm.value.password, 7)
  } else {
    clearCookie()
  }
}

// 页面加载时获取 cookie
onMounted(() => {
  getCookie()
})

</script>
