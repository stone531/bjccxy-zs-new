import { createRouter, createWebHashHistory } from 'vue-router'
import { studentRoutes } from '../api/student.js'

const routes = [
  {
    path: '/',
    redirect: '/login'
  },
  {
    path: '/init',
    name: 'Init',
    component: () => import('@/view/init/index.vue')
  },
  {
    path: '/login',
    name: 'Login',
    component: () => import('@/view/login/index.vue')
  },
  {
    path: '/scanUpload',
    name: 'ScanUpload',
    meta: {
      title: '扫码上传',
      client: true
    },
    component: () => import('@/view/example/upload/scanUpload.vue')
  },
  {
    path: '/:catchAll(.*)',
    meta: {
      closeTab: true
    },
    component: () => import('@/view/error/index.vue')
  },
  {
    path: '/demo',
    name: 'Demo',
    meta: { title: 'Demo管理', icon: 'example' },
    children: [{
      path: 'record',
      name: 'DemoRecord',
      component: () => import('@/view/example/demo/record.vue'),
      meta: { title: '记录管理', icon: 'table' }
    }]
  },
  {
    path: '/layout/business/certificate/certificateInfo',
    name: 'certificateInfo',
    component: () => import('@/view/business/certificate/certificateInfo.vue'),
    meta: { 
      title: '证书详情', 
      keepAlive: false,
      noLogin: true // gin-vue-admin 默认支持这个字段跳过权限验证
    } 
  },
  {
    path: '/layout/trainingBusiness/training/trainingInfo',
    name: 'trainStuInfo',
    component: () => import('@/view/trainingBusiness/training/trainingInfo.vue'),
    meta: { 
      title: '培训证书详情', 
      keepAlive: false,
      noLogin: true // gin-vue-admin 默认支持这个字段跳过权限验证
    } 
  },
  {
    path: '/layout/student/home/detail',
    name: 'orderDetail',
    component: () => import('@/view/student/home/detail.vue'),
    meta: { 
      title: '学生订单详情', 
      keepAlive: false,
      noLogin: true 
    } 
  },
  {
    path: '/external-query',
    name: 'external-query',
    component: () => import('@/view/external/zsQuery.vue'),
    meta: {
      title: '外部证书查询入口',
      hidden: true, // 不在菜单显示
      noLogin: true // 自定义字段，后面可以在拦截器中使用跳过 token 检查
    }
  },
  {
    path: '/student-login',
    name: 'student-login',
    component: () => import('@/view/student/login/login.vue'),
    meta: {
      title: '学生登录',
      hidden: true, // 不在菜单显示
      noLogin: true // 自定义字段，后面可以在拦截器中使用跳过 token 检查
    }
  },
  {
    path: '/student-register',
    name: 'student-register',
    component: () => import('@/view/student/login/register.vue'),
    meta: {
      title: '学生注册',
      hidden: true, // 不在菜单显示
      noLogin: true // 自定义字段，后面可以在拦截器中使用跳过 token 检查
    }
  },
  {
    path: '/user-agreement',
    name: 'user-agreement',
    component: () => import('@/view/student/login/user-agreement.vue'),
    meta: {
      title: '长城学院用户协议',
      hidden: true, // 不在菜单显示
      noLogin: true // 自定义字段，后面可以在拦截器中使用跳过 token 检查
    }
  },
  {
    path: '/privacy-policy',
    name: 'privacy-policy',
    component: () => import('@/view/student/login/privacy-policy.vue'),
    meta: {
      title: '长城学院隐私政策',
      hidden: true, // 不在菜单显示
      noLogin: true // 自定义字段，后面可以在拦截器中使用跳过 token 检查
    }
  },
  {
    path: '/student-retrivev-password',
    name: 'student-retrivev-password',
    component: () => import('@/view/student/login/retrieve-password.vue'),
    meta: {
      title: '找回密码',
      hidden: true, // 不在菜单显示
      noLogin: true // 自定义字段，后面可以在拦截器中使用跳过 token 检查
    }
  },
]

const router = createRouter({
  history: createWebHashHistory(),
  routes
})

studentRoutes.forEach(route => router.addRoute(route))

export default router
