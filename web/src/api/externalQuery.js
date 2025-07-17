import service from '@/utils/request'

export const externalQuery = (data) => {
  return service({
    url: '/external/zsQuery',
    method: 'post',
    data,
    headers: {
      isToken: false // ��Ҫ������ token ����
    }
  })
}


export const login = (data) => {
  return service({
    url: '/base/login',
    method: 'post',
    data: data
  })
}