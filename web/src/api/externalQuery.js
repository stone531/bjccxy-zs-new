import service from '@/utils/request'

export const externalQuery = (data) => {
  return service({
    url: '/external/zsQuery',
    method: 'post',
    data,
    headers: {
      isToken: false // 重要：跳过 token 附带
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