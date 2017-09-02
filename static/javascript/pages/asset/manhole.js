$(document).ready(function(){

  update_map();
});


function update_map() {
  map = new AMap.Map('manhole_map', {
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
      title: '攀西花园'
    });
  });
}
