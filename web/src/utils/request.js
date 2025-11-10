import axios from 'axios' // 引入axios
import { ElMessage, ElMessageBox } from 'element-plus'
import { useUserStore } from '@/pinia/modules/user'
import { useStudentStore } from '@/pinia/modules/student'
import router from '@/router/index'
import { ElLoading } from 'element-plus'

// 添加一个状态变量，用于跟踪是否已有错误弹窗显示
let errorBoxVisible = false

const service = axios.create({
  baseURL: import.meta.env.VITE_BASE_API,
  timeout: 99999
})
let activeAxios = 0
let timer
let loadingInstance
const showLoading = (
  option = {
    target: null
  }
) => {
  const loadDom = document.getElementById('gva-base-load-dom')
  activeAxios++
  if (timer) {
    clearTimeout(timer)
  }
  timer = setTimeout(() => {
    if (activeAxios > 0) {
      if (!option.target) option.target = loadDom
      loadingInstance = ElLoading.service(option)
    }
  }, 400)
}

const closeLoading = () => {
  activeAxios--
  if (activeAxios <= 0) {
    clearTimeout(timer)
    loadingInstance && loadingInstance.close()
  }
}

/*
// http request 拦截器
service.interceptors.request.use(
  (config) => {
    if (!config.donNotShowLoading) {
      showLoading(config.loadingOption)
    }
    const userStore = useUserStore()
    config.headers = {
      'Content-Type': 'application/json',
      'x-token': userStore.token,
      'x-user-id': userStore.userInfo.ID,
      ...config.headers
    }
    return config
  },
  (error) => {
    if (!error.config.donNotShowLoading) {
      closeLoading()
    }
    ElMessage({
      showClose: true,
      message: error,
      type: 'error'
    })
    return error
  }
)
  */
 // http request 拦截器
service.interceptors.request.use(
  (config) => {
    if (!config.donNotShowLoading) {
      showLoading(config.loadingOption)
    }

    const userStore = useUserStore()
    //const { useStudentStore } = await import('@/pinia/modules/student') // 动态导入，避免循环依赖

    const studentStore = useStudentStore()

    const isStudentAPI = config.url?.includes('/student/')
    const studentTokenWhitelist = ['/student/login', '/student/register', '/student/initPassword','/student/sendEmailCode']

    const isWhiteListed = studentTokenWhitelist.some(url => config.url?.includes(url))


    // 设置通用 header
    config.headers = {
      'Content-Type': 'application/json',
      ...config.headers
    }

    if (isStudentAPI && !isWhiteListed) {
      // 学生端请求，设置 student-token
      if (studentStore.token) {
        config.headers['student-token'] = studentStore.token
      }
      if (studentStore.user?.ID) {
        config.headers['student-id'] = studentStore.user.ID
      }
    } else {
      // 用户端请求，设置 x-token 和 x-user-id
      if (userStore.token) {
        config.headers['x-token'] = userStore.token
      }
      if (userStore.userInfo?.ID) {
        config.headers['x-user-id'] = userStore.userInfo.ID
      }
    }

    return config
  },
  (error) => {
    if (!error.config?.donNotShowLoading) {
      closeLoading()
    }
    ElMessage({
      showClose: true,
      message: error,
      type: 'error'
    })
    return error
  }
)

// http response 拦截器
service.interceptors.response.use(
  (response) => {
    const userStore = useUserStore()
    if (!response.config.donNotShowLoading) {
      closeLoading()
    }
    if (response.headers['new-token']) {
      userStore.setToken(response.headers['new-token'])
    }

    if (response.config.responseType === 'blob') {
      return response
    }
    
    if (response.data.code === 0 || response.headers.success === 'true') {
      if (response.headers.msg) {
        response.data.msg = decodeURI(response.headers.msg)
      }
      return response.data
    } else {
      ElMessage({
        showClose: true,
        message: response.data.msg || decodeURI(response.headers.msg),
        type: 'error'
      })
      return response.data.msg ? response.data : response
    }
  },
  (error) => {
    if (!error.config.donNotShowLoading) {
      closeLoading()
    }

    // 如果已经有错误弹窗显示，则不再显示新的弹窗
    if (errorBoxVisible) {
      return error
    }

    if (!error.response) {
      errorBoxVisible = true
      ElMessageBox.confirm(
        `
        <p>检测到请求错误</p>
        <p>${error}</p>
        `,
        '请求报错',
        {
          dangerouslyUseHTMLString: true,
          distinguishCancelAndClose: true,
          confirmButtonText: '稍后重试',
          cancelButtonText: '取消'
        }
      ).finally(() => {
        // 弹窗关闭后重置状态
        errorBoxVisible = false
      })
      return
    }

    switch (error.response.status) {
      case 500:
        errorBoxVisible = true
        ElMessageBox.confirm(
          `
        <p>检测到接口错误${error}</p>
        <p>错误码<span style="color:red"> 500 </span>：此类错误内容常见于后台panic，请先查看后台日志，如果影响您正常使用可强制登出清理缓存</p>
        `,
          '接口报错',
          {
            dangerouslyUseHTMLString: true,
            distinguishCancelAndClose: true,
            confirmButtonText: '清理缓存',
            cancelButtonText: '取消'
          }
        ).then(() => {
          const userStore = useUserStore()
          userStore.ClearStorage()
          router.push({ name: 'Login', replace: true })
        }).finally(() => {
          // 弹窗关闭后重置状态
          errorBoxVisible = false
        })
        break
      case 404:
        errorBoxVisible = true
        ElMessageBox.confirm(
          `
          <p>检测到接口错误${error}</p>
          <p>错误码<span style="color:red"> 404 </span>：此类错误多为接口未注册（或未重启）或者请求路径（方法）与api路径（方法）不符--如果为自动化代码请检查是否存在空格</p>
          `,
          '接口报错',
          {
            dangerouslyUseHTMLString: true,
            distinguishCancelAndClose: true,
            confirmButtonText: '我知道了',
            cancelButtonText: '取消'
          }
        ).finally(() => {
          // 弹窗关闭后重置状态
          errorBoxVisible = false
        })
        break
      case 401:
        errorBoxVisible = true
        ElMessageBox.confirm(
          `
          <p>无效的令牌</p>
          <p>错误码:<span style="color:red"> 401 </span>错误信息:${error}</p>
          `,
          '身份信息',
          {
            dangerouslyUseHTMLString: true,
            distinguishCancelAndClose: true,
            confirmButtonText: '重新登录',
            cancelButtonText: '取消'
          }
        ).then(() => {
          const userStore = useUserStore()
          userStore.ClearStorage()
          router.push({ name: 'Login', replace: true })
        }).finally(() => {
          // 弹窗关闭后重置状态
          errorBoxVisible = false
        })
        break
    }

    return Promise.reject(error)
    //return error
  }
)
export default service
