

var option = {
    angleAxis: {
    },
    radiusAxis: {
        type: 'category',
        data: ['周一', '周二', '周三', '周四', '周五', '周六', '周日'],
        z: 10
    },
    polar: {
    },
    series: [{
        type: 'bar',
        data: [1, 2, 3, 4, 2, 1, 0],
        coordinateSystem: 'polar',
        name: '未响应',
        stack: 'a'
    }, {
        type: 'bar',
        data: [2, 4, 6, 8, 3, 2, 1],
        coordinateSystem: 'polar',
        name: '超时完成',
        stack: 'a'
    }, {
        type: 'bar',
        data: [1, 2, 3, 4, 3, 2 , 1],
        coordinateSystem: 'polar',
        name: '按时完成',
        stack: 'a'
    }],
    legend: {
        show: true,
        data: ['未响应', '超时完成', '按时完成']
    }
};

var myChart = echarts.init(document.getElementById('chart1'));
myChart.setOption(option);

var option2 = {
  title: {
    text: '本月任务量统计',
    x: 'center'
  },
  tooltip: {
    trigger: 'item',
    formatter: "{a} <br/>{b} : {c}次 ({d}%)"
  },
  legend: {
    orient: 'vertical',
    left: 'left',
    data: ['巡检任务', '抢修任务', '检修任务', '其他任务']
  },
  series: [{
    name: '访问来源',
    type: 'pie',
    radius: '55%',
    center: ['50%', '60%'],
    data: [{
      value: 335,
      name: '巡检任务'
    }, {
      value: 310,
      name: '抢修任务'
    }, {
      value: 234,
      name: '检修任务'
    }, {
      value: 135,
      name: '其他任务'
    }],
    itemStyle: {
      emphasis: {
        shadowBlur: 10,
        shadowOffsetX: 0,
        shadowColor: 'rgba(0, 0, 0, 0.5)'
      }
    }
  }]
};
var myChart2 = echarts.init(document.getElementById('chart2'));
myChart2.setOption(option2);

var option3 = {
  title: {
    text: '本月任务完成及时率',
    x: 'center'
  },
  tooltip: {
    trigger: 'axis'
  },
  radar: [{
    indicator: [{
      text: '巡检任务',
      max: 100
    }, {
      text: '抢修任务',
      max: 100
    }, {
      text: '检修任务',
      max: 100
    }, {
      text: '其他任务',
      max: 100
    }],
    center: ['50%', '60%'],
    radius: '60%'
  }],
  series: [{
    type: 'radar',
    tooltip: {
      trigger: 'item'
    },
    itemStyle: {
      normal: {
        areaStyle: {
          type: 'default'
        }
      }
    },
    data: [{
      value: [90, 73, 85, 80],
      name: '本月任务完成及时率'
    }]
  }]
};

var myChart3 = echarts.init(document.getElementById('chart3'));
myChart3.setOption(option3);

var option4 = {
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

var myChart4 = echarts.init(document.getElementById('chart4'));
myChart4.setOption(option4);
