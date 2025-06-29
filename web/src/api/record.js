import request from '@/utils/request'

// ������¼
export function createDemoRecord(data) {
  return request({
    url: '/demoRecord/create',
    method: 'post',
    data
  })
}

// ��ȡ��¼�б�
export function getDemoRecordList(params) {
  return request({
    url: '/demoRecord/list',
    method: 'get',
    params
  })
}