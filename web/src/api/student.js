import request from '@/utils/request'

// 发送邮箱验证码
export function sendStudentCodeApi(data) {
  return request.post('/student/sendCode', data)
}

// 注册接口
export function registerStudentApi(data) {
  return request.post('/student/register', data)
}
