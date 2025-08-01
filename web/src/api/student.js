import request from '@/utils/request'
import service from '@/utils/request'
import { data } from 'autoprefixer'

// src/router/student.js
export const studentRoutes = [
  {
    path: '/student',
    name: 'StudentRoot',
    component: () => import('@/view/student/home/home.vue'),
    redirect: '/student/info',
    children: [
      {
        path: 'info',
        name: 'StudentInfo',
        component: () => import('@/view/student/home/info.vue'),
        meta: { title: '我的信息', icon: 'user' }
      },
      {
        path: 'order',
        name: 'StudentOrder',
        component: () => import('@/view/student/home/order.vue'),
        meta: { title: '我的订单', icon: 'list' }
      },
      {
        path: 'certificate',
        name: 'StudentCertificate',
        component: () => import('@/view/student/home/certificate.vue'),
        meta: { title: '毕业证书申请', icon: 'file-text' }
      },
      {
        path: 'quit',
        name: 'StudentQuit',
        component: () => import('@/view/student/home/quit.vue'),
        meta: { title: '退出登录', icon: 'file-text' }
      }
    ]
  }
]


// 发送邮箱验证码
export function sendStudentCodeApi(data) {
  return request.post('/student/sendEmailCode', data)
}

// 注册接口
export function registerStudentApi(data) {
  return request.post('/student/register', data)
}



export const login = (data) => {
    return service({
        url: "/student/login",
        method: 'post',
        data: data
    })
    //return request.post('/student/login', data)
}

// @Summary 获取验证码
// @Produce  application/json
// @Param data body {username:"string",password:"string"}
// @Router /base/captcha [post]
/*
export const captcha = (data) => {
    return service({
        url: "/base/captcha",
        method: 'post',
        data: data
    })
}*/

// @Summary 用户注册
// @Produce  application/json
// @Param data body {username:"string",password:"string"}
// @Router /base/resige [post]
export const register = (data) => {
    return service({
        url: "/student/register",
        method: 'post',
        data: data
    })

    //return request.post('/student/register', data)
}

export const forgetSendEmail = (data) => {
    return service({
        url: "/base/forgetSendEmail",
        method: 'post',
        data: data
    })
}

export const forgetVerify = (data) => {
    return service({
        url: "/base/forgetVerify",
        method: 'post',
        data: data
    })
}


// @Tags User
// @Summary 分页获取用户列表
// @Security ApiKeyAuth
// @accept application/json
// @Produce application/json
// @Param data body modelInterface.PageInfo true "分页获取用户列表"
// @Success 200 {string} json "{"success":true,"data":{},"msg":"获取成功"}"
// @Router /user/getUserList [post]
export const getUserList = (data) => {
    return service({
        url: "/user/getUserList",
        method: 'post',
        data: data
    })
}


// @Tags User
// @Summary 设置用户权限
// @Security ApiKeyAuth
// @accept application/json
// @Produce application/json
// @Param data body api.SetUserAuth true "设置用户权限"
// @Success 200 {string} json "{"success":true,"data":{},"msg":"修改成功"}"
// @Router /user/setUserAuthority [post]
export const setUserAuthority = (data) => {
    return service({
        url: "/user/setUserAuthority",
        method: 'post',
        data: data
    })
}

export const resetPassword = (data) => {
    return service({
        url: "/user/resetPassword",
        method: 'post',
        data: data
    })
}

export const findSysUserById = (data) => {
    return service({
        url: "/user/findSysUserById",
        method: 'post',
        data: data
    })
}

export const deleteSysUser = (data) => {
    return service({
        url: "/user/deleteSysUser",
        method: 'post',
        data: data
    })
}

export const changeEmail = (data) => {
    return service({
        url: "/user/changeEmail",
        method: 'post',
        data: data
    })
}

export const initPassword = (data) => {
    return service({
        url: "/student/initPassword",
        method: 'post',
        data: data
    })
    //return request.post('/student/initPassword', data)
}


export const getStudentInfo = () => {
  return service({
    url: '/student/getInfo',
    method: 'get'
  })
}

//更新学生信息字段
export const updateStudentField = (data) => {
  return service({
    url: '/student/updateField',
    method: 'put',
    data
  })
}

// @Summary 修改密码
// @Produce  application/json
// @Param data body {username:"string",password:"string",newPassword:"string"}
// @Router /user/changePassword [post]
export const changePassword = (data) => {
  return service({
      url: "/student/changePassword",
      method: 'post',
      data: data
  })
}