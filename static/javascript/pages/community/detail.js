var marker;
var map;

var myChart_community_stat_income;
var myChart_community_stat_user_count;
var myChart_community_internet_behavior_analysis_1;
var myChart_community_internet_behavior_analysis_2;
var myChart_community_internet_behavior_analysis_3;
var myChart_community_internet_behavior_analysis_4;

var myChart_community_ftth_topology; //小区ftth拓扑图

var table_oLanguage = {
  "sLengthMenu": "每页显示 _MENU_ 条记录",
  "sZeroRecords": "对不起，查询不到任何相关数据",
  "sInfo": "当前显示 _START_ 到 _END_ 条，共 _TOTAL_ 条记录",
  "sInfoEmtpy": "找不到相关数据",
  "sInfoFiltered": "数据表中共为 _MAX_ 条记录)",
  "sProcessing": "正在加载中...",
  "sSearch": "搜索: ",
  "sUrl": "", //多语言配置文件，可将oLanguage的设置放在一个txt文件中，例：Javascript/datatable/dtCH.txt
  "oPaginate": {
    "sFirst": "第一页",
    "sPrevious": " 上一页 ",
    "sNext": " 下一页 ",
    "sLast": " 最后一页 "
  }
}; //多语言配置


$(document).ready(function() {
  update_map();
  create_chart_community_ftth_usage();

  $('#table_consumer_ftth').DataTable({
    responsive: true,
    oLanguage: table_oLanguage //多语言配置
  });
  $('#table_consumer_telephone').DataTable({
    responsive: true,
    oLanguage: table_oLanguage //多语言配置
  });
  $('#table_inspection').DataTable({
    responsive: true,
    oLanguage: table_oLanguage //多语言配置
  });
});


function create_chart_community_ftth_usage() {
  var option = {
    tooltip: {},
    title: [{
      text: '小区光缆资源使用情况统计',
      subtext: '总计 ',
      x: '50%',
      textAlign: 'center'
    }],
    series: [{
      type: 'pie',
      data: [{
        name: '已经使用',
        value: 1234
      }, {
        name: '未使用',
        value: 231
      }]
    }]
  }

  var myChart_community_ftth_usage = echarts.init(document.getElementById('chart_community_ftth_usage'));
  myChart_community_ftth_usage.setOption(option);
}


$('#tab_internet_behavior_analysis').on('shown.bs.tab', function(e) {
  if (!myChart_community_internet_behavior_analysis_1) {
    myChart_community_internet_behavior_analysis_1 = echarts.init(document.getElementById('community_internet_behavior_analysis_1'));
    myChart_community_internet_behavior_analysis_2 = echarts.init(document.getElementById('community_internet_behavior_analysis_2'));
    myChart_community_internet_behavior_analysis_3 = echarts.init(document.getElementById('community_internet_behavior_analysis_3'));
    myChart_community_internet_behavior_analysis_4 = echarts.init(document.getElementById('community_internet_behavior_analysis_4'));


    myChart_community_internet_behavior_analysis_1.setOption(option_community_internet_behavior_analysis_1);
    myChart_community_internet_behavior_analysis_2.setOption(option_community_internet_behavior_analysis_2);
    myChart_community_internet_behavior_analysis_3.setOption(option_community_internet_behavior_analysis_3);
    myChart_community_internet_behavior_analysis_4.setOption(option_community_internet_behavior_analysis_4);
  }
});

$('#tab_stat').on('shown.bs.tab', function(e) {
  if (!myChart_community_stat_income) {
    myChart_community_stat_income = echarts.init(document.getElementById('community_stat_income'));
    myChart_community_stat_user_count = echarts.init(document.getElementById('community_stat_user_count'));
    myChart_community_stat_income.setOption(option_community_stat_income);
    myChart_community_stat_user_count.setOption(option_community_stat_user_count);
  }
});

$('#tab_ftth_topology').on('shown.bs.tab', function(e) {
  if (!myChart_community_ftth_topology) {
    var myChart = echarts.init(document.getElementById('chart_community_ftth_topology'));
    myChart.showLoading();
    $.get('/data/community_ftth_topology.json', function(data) {
      myChart.hideLoading();

      myChart.setOption(option = {
        title: {
          text: ''
        },
        tooltip: {
          trigger: 'item',
          triggerOn: 'mousemove'
        },
        series: [{
          type: 'sankey',
          layout: 'none',
          data: data.nodes,
          links: data.links,
          itemStyle: {
            normal: {
              borderWidth: 1,
              borderColor: '#aaa'
            }
          },
          lineStyle: {
            normal: {
              color: 'source',
              curveness: 0.5
            }
          }
        }]
      });
    });
  }
});


function update_map() {
  map = new AMap.Map('community_map', {
    resizeEnable: true,
    zoom: 16,
    //mapStyle: 'amap://styles/whitesmoke',
    center: [102.25548, 27.890265]
  });

  AMapUI.loadUI(['overlay/AwesomeMarker'], function(AwesomeMarker) {
    marker = new AwesomeMarker({
      //设置awesomeIcon
      awesomeIcon: 'building-o',
      iconLabel: {
        style: {
          color: '#333',
          fontSize: '14px'
        }
      },
      iconStyle: 'blue',
      map: map,
      position: [
        102.25548, 27.890265
      ],
      title: '攀西花园'
    });
  });
}


// 指定图表的配置项和数据
var option_community_stat_income = {
  title: {
    text: '小区收入统计'
  },
  tooltip: {},
  legend: {
    data: ['总收入', '家宽业务收入', '电话业务收入']
  },
  xAxis: {
    data: [
      "2007年",
      "2008年",
      "2009年",
      "2010年",
      "2011年",
      "2012年",
      "2013年",
      "2014年",
      "2015年",
      "2016年"
    ]
  },
  yAxis: {},
  series: [{
    name: '总收入',
    type: 'line',
    data: [
      34,
      35,
      28,
      37,
      45,
      34,
      28,
      38,
      32,
      41
    ]
  }, {
    name: '家宽业务收入',
    type: 'line',
    data: [
      19,
      14,
      18,
      23,
      33,
      24,
      18,
      18,
      22,
      31
    ]
  }, {
    name: '电话业务收入',
    type: 'line',
    data: [
      21,
      23,
      12,
      21,
      15,
      14,
      12,
      15,
      12,
      11
    ]
  }]
};

var option_community_stat_user_count = {
  title: {
    text: '小区用户接入数'
  },
  tooltip: {},
  legend: {
    data: ['小区用户接入数', '电话接入数', '宽带接入数']
  },
  xAxis: {
    data: [
      "2007年",
      "2008年",
      "2009年",
      "2010年",
      "2011年",
      "2012年",
      "2013年",
      "2014年",
      "2015年",
      "2016年"
    ]
  },
  yAxis: {},
  series: [{
    name: '小区用户接入数',
    type: 'bar',
    data: [
      34,
      35,
      28,
      37,
      45,
      34,
      28,
      38,
      32,
      41
    ]
  }, {
    name: '电话接入数',
    type: 'bar',
    data: [
      19,
      14,
      18,
      23,
      33,
      24,
      18,
      18,
      22,
      31
    ]
  }, {
    name: '宽带接入数',
    type: 'bar',
    data: [
      21,
      23,
      12,
      21,
      15,
      14,
      18,
      18,
      12,
      11
    ]
  }]
};

var option_community_internet_behavior_analysis_1 = {
  title: {
    text: '小区用户接入数'
  },
  tooltip: {},
  legend: {
    data: ['小区用户接入数', '电话接入数', '宽带接入数']
  },
  xAxis: {
    data: [
      "2007年",
      "2008年",
      "2009年",
      "2010年",
      "2011年",
      "2012年",
      "2013年",
      "2014年",
      "2015年",
      "2016年"
    ]
  },
  yAxis: {},
  series: [{
    name: '小区用户接入数',
    type: 'bar',
    data: [
      34,
      35,
      28,
      37,
      45,
      34,
      28,
      38,
      32,
      41
    ]
  }, {
    name: '电话接入数',
    type: 'bar',
    data: [
      19,
      14,
      18,
      23,
      33,
      24,
      18,
      18,
      22,
      31
    ]
  }, {
    name: '宽带接入数',
    type: 'bar',
    data: [
      21,
      23,
      12,
      21,
      15,
      14,
      18,
      18,
      12,
      11
    ]
  }]
};


var option_community_internet_behavior_analysis_1 = {
  title: {
    text: '带宽时段占用率统计'
  },
  tooltip: {},
  legend: {
    data: ['小区带宽占用率']
  },
  xAxis: {
    data: [
      "0",
      "1",
      "2",
      "3",
      "4",
      "5",
      "6",
      "7",
      "8",
      "9",
      "10",
      "11",
      "12",
      "13",
      "14",
      "15",
      "16",
      "17",
      "18",
      "19",
      "20",
      "21",
      "22",
      "23",
      "24"
    ]
  },
  yAxis: {},
  series: [{
    name: '小区带宽占用率',
    type: 'bar',
    data: [
      50,
      45,
      28,
      14,
      12,
      10,
      12,
      23,
      24,
      32,
      31,
      33,
      34,
      40,
      28,
      32,
      31,
      33,
      34,
      70,
      78,
      82,
      88,
      75,
      60
    ]
  }]
};

var option_community_internet_behavior_analysis_2 = {
  tooltip: {
    formatter: '{b0}: {c0}%'
  },
  title: [{
    text: '流量分布图'
  }],
  series: [{
    type: 'pie',
    data: [{
      name: 'HTTP协议',
      value: 52.8
    }, {
      name: '网络电视',
      value: 16.4
    }, {
      name: 'P2P下载',
      value: 14.6
    }, {
      name: '未知流量',
      value: 6.4
    }, {
      name: '常用协议',
      value: 4.8
    }, {
      name: '移动应用',
      value: 1.9
    }, {
      name: '及时通信',
      value: 3.2
    }]
  }]
}

var option_community_internet_behavior_analysis_3 = {
  title: {
    text: '带宽使用率最高的用户TOP10'
  },
  legend: {
    data: ['日均带宽占用率']
  },
  xAxis: {
    type: 'value'
  },
  yAxis: {
    type: 'category',
    data: ['6单元305', '7单元402', '3单元301', '3单元601', '4单元201', '5单元401', '2单元101', '1单元401', '1单元201', '1单元501']
  },
  series: [{
    type: 'bar',
    data: [78, 79, 80, 82, 84, 87, 89, 90, 92, 95]
  }]
}
var option_community_internet_behavior_analysis_4 = {
  title: {
    text: '带宽使用率最低的用户TOP10'
  },
  legend: {
    data: ['日均带宽占用率']
  },
  xAxis: {
    type: 'value',
    min: 0,
    max: 100
  },
  yAxis: {
    type: 'category',
    data: ['6单元305', '7单元402', '3单元301', '3单元601', '4单元201', '5单元401', '2单元101', '1单元401', '1单元201', '1单元501']
  },
  series: [{
    type: 'bar',
    data: [43,41,38,36,35,28,21,15,10,2]
  }]
}
