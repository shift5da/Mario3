var option1 = {
  title: {
    text: '线路专业2017年KPI完成情况',
    subtext: '当前总分：95分，去年得分92分',
    subtextStyle: {
      color: '#a3435c',
      fontWeight: 'bold',
      fontSize: 14
    },
    x: 'center'
  },
  tooltip: {},
  legend: {
    data: ['去年完成情况', '今年完成情况'],
    orient: 'vertical',
    left: 'left'
  },
  radar: {
    // shape: 'circle',
    indicator: [{
      name: '基础维护',
      max: 100
    }, {
      name: '基础管理',
      max: 100
    }, {
      name: '基础支撑',
      max: 100
    }],
    center: ['50%', '60%'],
    radius: '70%'
  },
  series: [{
    name: '线路专业2017年KPI完成情况',
    type: 'radar',
    data: [{
      value: [98, 95, 80],
      name: '去年完成情况'
    }, {
      value: [96, 98, 95],
      name: '今年完成情况'
    }]
  }]
};

var myChart1 = echarts.init(document.getElementById('chart1'));
myChart1.setOption(option1);
