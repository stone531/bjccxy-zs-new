// src/pinia/student.js

import { login as studentLogin, getStudentInfo } from '@/api/student'
import router from '@/router'
import { ElLoading, ElMessage } from 'element-plus'
import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { useCookies } from '@vueuse/integrations/useCookies'
import { useStorage } from '@vueuse/core'

export const useStudentStore = defineStore('student', () => {
  const loadingInstance = ref(null)

  const studentInfo = ref({
    uuid: '',
    nickName: '',
    avatar: '',
    classInfo: {},
  })

  // ✅ 使用独立的 token 名称存储，防止冲突
  const studentToken = useStorage('student-token', '')
  const xToken = useCookies('x-student-token')  // cookie 也独立
  const currentToken = computed(() => studentToken.value || xToken.value || '')

  const setStudentInfo = (val) => {
    studentInfo.value = val
  }

  const setToken = (val) => {
    studentToken.value = val
    xToken.value = val
  }

  const GetStudentInfo = async () => {
    const res = await getStudentInfo()
    if (res.code === 0) {
      setStudentInfo(res.data.studentInfo)
    }
    return res
  }

  const LoginIn = async (loginInfo) => {
    try {
      loadingInstance.value = ElLoading.service({
        fullscreen: true,
        text: '登录中，请稍候...'
      })

      const res = await studentLogin(loginInfo)

      if (res.code !== 0) {
        ElMessage.error(res.msg || '登录失败')
        return false
      }

      setStudentInfo(res.data.student)
      setToken(res.data.token)

      //await router.replace({ name: 'StudentHome' }) // 学生默认路由

      return true
    } catch (error) {
      console.error('Student LoginIn error:', error)
      return false
    } finally {
      loadingInstance.value?.close()
    }
  }

  const LoginOut = async () => {
    // 如果你有接口 logoutStudent()，可调用之
    await ClearStorage()
    await router.push({ name: 'StudentLogin' })
    window.location.reload()
  }

  const ClearStorage = () => {
    studentToken.value = ''
    xToken.remove()
    sessionStorage.clear()
    localStorage.removeItem('student-token')
  }

  return {
    studentInfo,
    token: currentToken,
    LoginIn,
    LoginOut,
    GetStudentInfo,
    ClearStorage,
    setToken,
    loadingInstance
  }
})
