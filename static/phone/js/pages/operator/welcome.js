var option = {
  tooltip: {
    trigger: 'axis',
    axisPointer: { // 坐标轴指示器，坐标轴触发有效
      type: 'shadow' // 默认为直线，可选为：'line' | 'shadow'
    }
  },
  legend: {
    data: ['已经完成的任务量', '未完成的任务量']
  },
  grid: {
    left: '3%',
    right: '4%',
    bottom: '3%',
    containLabel: true
  },
  xAxis: {
    type: 'value'
  },
  yAxis: {
    type: 'category',
    data: ['周一', '周二', '周三', '周四', '周五', '周六', '周日']
  },
  series: [{
    name: '已经完成的任务量',
    type: 'bar',
    stack: '总量',
    label: {
      normal: {
        show: true,
        position: 'insideLeft'
      }
    },
    data: [6, 5, 4, 5, 4, 5, 4]
  }, {
    name: '未完成的任务量',
    type: 'bar',
    stack: '总量',
    label: {
      normal: {
        show: true,
        position: 'insideRight'
      }
    },
    data: [0, 0, 0, 0, 1, 0, 0, 0]
  }]
};
var myChart = echarts.init(document.getElementById('operator_workload_stat'));
myChart.setOption(option);
