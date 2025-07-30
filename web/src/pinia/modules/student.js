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
    useraccount: '',
    avatar: '',
    classInfo: {},
    name: '',
    email: '',
    id_card_number: ''
  })

  // ✅ 存储 token：本地存储 + cookie 双保险
  const studentToken = useStorage('student-token', '')
  const cookies = useCookies()
  const currentToken = computed(() => {
    return studentToken.value || cookies.get('student-token') || ''
  })
  //const currentToken = computed(() => studentToken.value || xToken.value || '')

  const setStudentInfo = (val) => {
    studentInfo.value = val
  }

  const setToken = (val) => {
    studentToken.value = val
    cookies.set('student-token', val, { path: '/', maxAge: 60 * 60 * 24 }) // 1天
  }

  const clearToken = () => {
    studentToken.value = ''
    cookies.remove('student-token')
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

      setStudentInfo(res.data.user || res.data.student)
      setToken(res.data.token)

      // 登录成功后可跳转
      // await router.replace({ name: 'StudentHome' })

      return true
    } catch (error) {
      console.error('Student LoginIn error:', error)
      return false
    } finally {
      loadingInstance.value?.close()
    }
  }

  const LoginOut = async () => {
    await ClearStorage()
    await router.push({ name: 'StudentLogin' })
    window.location.reload()
  }

  const ClearStorage = () => {
    clearToken()
    sessionStorage.clear()
    localStorage.removeItem('student-token') // 保险
  }

  return {
    studentInfo,
    token: currentToken,
    LoginIn,
    LoginOut,
    GetStudentInfo,
    ClearStorage,
    setToken,
    loadingInstance,
    setStudentInfo
  }
})
