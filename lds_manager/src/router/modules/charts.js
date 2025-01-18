/** When your routing table is too long, you can split it into small modules**/

import Layout from '@/layout'

const chartsRouter = {
  path: '/charts',
  component: Layout,
  redirect: 'noRedirect',
  name: '数据指标',
  meta: {
    title: '数据指标',
    icon: 'chart'
  },
  children: [
    /*
    {
      path: 'keyboard',
      component: () => import('@/views/charts/keyboard'),
      name: '路灯健康指标',
      meta: { title: '路灯健康指标', noCache: true }
    },
    */
    {
      path: 'line',
      component: () => import('@/views/charts/line'),
      name: '路灯状态指标',
      meta: { title: '路灯状态指标', noCache: true }
    },
    {
      path: 'mix-chart',
      component: () => import('@/views/charts/mix-chart'),
      name: '路灯上报指标',
      meta: { title: '路灯上报指标', noCache: true }
    }
  ]
}

export default chartsRouter
