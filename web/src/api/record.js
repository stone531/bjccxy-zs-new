import request from '@/utils/request'

// 创建记录
export function createDemoRecord(data) {
  return request({
    url: '/demoRecord/create',
    method: 'post',
    data
  })
}

// 获取记录列表
export function getDemoRecordList(params) {
  return request({
    url: '/demoRecord/list',
    method: 'get',
    params
  })
}