import { createRouter, createWebHashHistory } from 'vue-router'

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
    path: '/external-query',
    name: 'external-query',
    component: () => import('@/view/external/zsQuery.vue'),
    meta: {
      title: '外部证书查询入口',
      hidden: true, // 不在菜单显示
      noLogin: true // 自定义字段，后面可以在拦截器中使用跳过 token 检查
    }
  },

]

const router = createRouter({
  history: createWebHashHistory(),
  routes
})

export default router
