$(document).ready(function(){
  $("img[id|='point']").each(function functionName() {
    $(this).mouseover(function () {
      $(this).attr('src', '/images/occ_point_highlight.png');
      //将配对的跳纤口也高亮显示出来
      var no = parseInt(this.id.slice(6));
      var target_no = 12 + no;
      if (target_no > 24){
        target_no = target_no - 24;
      }
      $('#point-' + target_no.toString()).attr('src', '/images/occ_point_highlight.png');
    });

    $(this).mouseout(function () {
      $(this).attr('src', '/images/occ_point_used.png');
      //将配对的跳纤口还原到原来的颜色
      var no = parseInt(this.id.slice(6));
      var target_no = 12 + no;
      if (target_no > 24){
        target_no = target_no - 24;
      }
      $('#point-' + target_no.toString()).attr('src', '/images/occ_point_used.png');
    });
  });

  update_map();
});

function update_map() {
  map = new AMap.Map('occ_map', {
    resizeEnable: true,
    zoom: 16,
    mapStyle: 'amap://styles/grey',
    center: [121.48471,31.23988]
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
        121.48471,31.23988
      ],
      title: '宁波小区'
    });
  });
}

var myChart_occ_topology;
$('#tab_occ_topology').on('shown.bs.tab', function(e) {
  if (!myChart_occ_topology) {
    myChart_occ_topology = echarts.init(document.getElementById('chart_occ_topology'));
    myChart_occ_topology.showLoading();
    $.get('/data/community_ftth_topology.json', function(data) {
      myChart_occ_topology.hideLoading();

      myChart_occ_topology.setOption(option = {
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
