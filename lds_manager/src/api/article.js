import request from '@/utils/request'

export function fetchList(query) {
  return request({
    url: '/dev/list',
    method: 'post',
    params: query
  })
}

export function fetchFList(query) {
  return request({
    url: '/dev/fault',
    method: 'post',
    params: query
  })
}

export function fetchDevMsg(query) {
  return request({
    url: '/devMsg/list',
    method: 'post',
    params: query
  })
}

export function updateDevMsg(query) {
  return request({
    url: '/devMsg/handle',
    method: 'post',
    params: query
  })
}

export function fetchUserList(query) {
  return request({
    url: '/user/list',
    method: 'post',
    params: query
  })
}

export function fetchArticle(id) {
  return request({
    url: '/article/detail',
    method: 'get',
    params: { id }
  })
}

export function fetchPv(pv) {
  return request({
    url: '/article/pv',
    method: 'get',
    params: { pv }
  })
}

export function createArticle(data) {
  return request({
    url: '/dev/add',
    method: 'post',
    data
  })
}

export function updateArticle(data) {
  return request({
    url: 'dev/update',
    method: 'post',
    data
  })
}
