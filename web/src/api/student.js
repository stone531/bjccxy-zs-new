import request from '@/utils/request'

// ����������֤��
export function sendStudentCodeApi(data) {
  return request.post('/student/sendCode', data)
}

// ע��ӿ�
export function registerStudentApi(data) {
  return request.post('/student/register', data)
}
