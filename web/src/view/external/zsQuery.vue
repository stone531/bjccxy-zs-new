<template>
  <div id="userLayout" class="w-full h-full relative">
    <div
      class="rounded-lg flex items-center justify-evenly w-full h-full md:w-screen md:h-screen md:bg-[#194bfb] bg-white"
    >
       <!-- class="h-full" -->
      <div class="min-h-screen bg-cover bg-center bg-no-repeat">
        <img
          
          class="absolute inset-0 w-full h-full object-cover object-top mt-0"
          
          src="@/assets/bjccxy/banner.jpg"
          alt="banner"
        />
      </div>

       <div class="md:w-full w-10/12 h-full flex items-center justify-evenly relative">
    <div class="h-0 w-32 bg-white dark:bg-slate-900 absolute -ml-8" />

    <div
      class="fixed right-[10rem] top-1/2 -translate-y-1/2 z-[999] w-[30rem] rounded-lg flex flex-col justify-between bg-white dark:bg-slate-800 p-6 shadow-lg"
    >
      <!-- Tab 标签页 -->
      <el-tabs v-model="activeTab" type="card" class="mb-4">
        <el-tab-pane label="证书查询" name="certificate" />
        <el-tab-pane label="学籍查询" name="school" />
        <el-tab-pane label="培训证书查询" name="train" />
      </el-tabs>

      <el-form
        ref="queryForm"
        :model="formData"
        :rules="rules"
        label-width="100px"
      >
        <!-- 姓名 -->
        <el-form-item label="姓名：" prop="name" class="mb-6">
          <el-input
            v-model="formData.name"
            size="large"
            placeholder="请输入姓名"
          />
        </el-form-item>

        <!-- 根据 tab 控制显示字段 -->
        <!-- 证书号：只在 certificate 页显示 -->
        <el-form-item
          v-if="activeTab === 'certificate'"
          label="证书号："
          prop="number"
          class="mb-6"
        >
          <el-input
            v-model="formData.number"
            size="large"
            placeholder="请输入证书号"
          />
        </el-form-item>

        <!-- 身份证号：在 school / train 页显示 -->
        <el-form-item
          v-if="activeTab !== 'certificate'"
          label="身份证号："
          prop="idcard"
          class="mb-6"
        >
          <el-input
            v-model="formData.idcard"
            size="large"
            placeholder="请输入身份证号"
          />
        </el-form-item>

        <!-- 查询按钮 -->
        <el-form-item class="mb-6">
          <el-button
            class="shadow shadow-active h-11 w-full"
            type="primary"
            size="large"
            @click="submitQuery"
          >
            {{ tabButtonText[activeTab] }}
          </el-button>
        </el-form-item>
      </el-form>
    </div>
  </div>
      
    </div>

    <BottomInfo class="left-0 right-0 absolute bottom-3 mx-auto w-full z-20">
      
    </BottomInfo>
  </div>
</template>



<script setup>
//http://localhost:8080/#/external-query
  import { captcha } from '@/api/user'
  import { checkDB } from '@/api/initdb'
  import BottomInfo from '@/components/bottomInfo/bottomInfo.vue'
  import { reactive, ref } from 'vue'
  import { ElMessage } from 'element-plus'
  import { useRouter } from 'vue-router'
  import { useUserStore } from '@/pinia/modules/user'

  defineOptions({
    name: 'zsQuery'
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

  const activeTab = ref('certificate') // 当前页：certificate / school / train
  // 表单字段
  const formData = reactive({
    name: '',
    number: '',  // 用于证书号
    idcard: '',  // 用于身份证号
  })

  const tabButtonText = {
    certificate: '证书查询',
    school: '学籍查询',
    train: '培训证书查询',
  }

  // 表单校验规则
  const rules = {
    name: [{ required: true, message: '请输入姓名', trigger: 'blur' }],
    number: [
      {
        required: () => activeTab.value === 'certificate',
        message: '请输入证书号',
        trigger: 'blur',
      },
    ],
    idcard: [
      {
        required: () => activeTab.value !== 'certificate',
        message: '请输入身份证号',
        trigger: 'blur',
      },
    ],
  }

  // 提交查询
const submitQuery = () => {
  const typeMap = {
    certificate: '证书查询',
    school: '学籍查询',
    train: '培训证书查询',
  }

  const payload = {
    type: activeTab.value, // certificate / school / train
    name: formData.name,
    number: formData.number,
    idcard: formData.idcard,
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
    username: 'admin',
    password: '',
    captcha: '',
    captchaId: '',
    openCaptcha: false
  })

  const userStore = useUserStore()
  const login = async () => {
    return await userStore.LoginIn(loginFormData)
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
        await loginVerify()
        return false
      }

      // 通过验证，请求登陆
      const flag = await login()

      // 登陆失败，刷新验证码
      if (!flag) {
        await loginVerify()
        return false
      }

      // 登陆成功
      return true
    })
  }
}
</script>