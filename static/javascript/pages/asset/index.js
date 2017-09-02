var marker;


var occs = [{
  name: '光交-1',
  pos: [102.259042, 27.892361]
}, {
  name: '光交-1',
  pos: [102.259042, 27.892361]
}, {
  name: '光交-2',
  pos: [102.261896, 27.894314]
}, {
  name: '光交-3',
  pos: [102.261423, 27.895263]
}, {
  name: '光交-4',
  pos: [102.251231, 27.891508]
}, {
  name: '光交-5',
  pos: [102.26535, 27.894295]
}, {
  name: '光交-6',
  pos: [102.254471, 27.887164]
}, {
  name: '光交-7',
  pos: [102.259449, 27.892247]
}, {
  name: '光交-8',
  pos: [102.265007, 27.89384]
}, {
  name: '光交-9',
  pos: [102.261381, 27.891394]
}];
var manholes = [{
  name: '人井-1',
  pos: [102.25784, 27.894807]
}, {
  name: '人井-1',
  pos: [102.270414, 27.892114]
}, {
  name: '人井-2',
  pos: [102.25284, 27.890427]
}, {
  name: '人井-3',
  pos: [102.25902, 27.889042]
}, {
  name: '人井-4',
  pos: [102.253656, 27.893783]
}, {
  name: '人井-5',
  pos: [102.253656, 27.893783]
}];
var cable = {
  level1: [],
  level2: [],
  level3: []
}



var map = new AMap.Map('map_asset_overview', {
  resizeEnable: true,
  zoom: 14,
  mapStyle: 'amap://styles/whitesmoke',
  center: [102.245525, 27.881075]
});

AMap.plugin(['AMap.Autocomplete','AMap.PlaceSearch'], function() { //回调函数
  //实例化Autocomplete
  var autoOptions = {
    city: "凉山彝族自治州", //城市，默认全国
    input: "input_pos_query" //使用联想输入的input的id
  };
  autocomplete = new AMap.Autocomplete(autoOptions);
  //TODO: 使用autocomplete对象调用相关功能
  var placeSearch = new AMap.PlaceSearch({
    city: '凉山彝族自治州',
    map: map
  })
  AMap.event.addListener(autocomplete, "select", function(e) {
    //TODO 针对选中的poi实现自己的功能
    placeSearch.search(e.poi.name)
  });
})

for (var i = 0, l = occs.length; i < l; i++) {
  var o = occs[i];
  marker = new AMap.Marker({
    position: o.pos,
    title: o.name,
    icon: '/images/occ.jpg',
    map: map
  });
  AMap.event.addListener(marker, 'click', function () {
    window.location.href = "/asset/occs/1";
  });
}

for (var i = 0, l = manholes.length; i < l; i++) {
  o = manholes[i];
  marker = new AMap.Marker({
    position: o.pos,
    title: o.name,
    icon: '/images/manhole.png',
    map: map
  });
  AMap.event.addListener(marker, 'click', function () {
    window.location.href = "/asset/manholes/1";
  });
}

//////////////////////////////////////////

var map, district, polygons = [],
  citycode;
var districtSelect = document.getElementById('district');


AMap.plugin(['AMap.DistrictSearch'], function() {
  //行政区划查询
  var opts = {
    subdistrict: 1, //返回下一级行政区
    level: 'district',
    showbiz: false //查询行政级别为 市
  };
  district = new AMap.DistrictSearch(opts); //注意：需要使用插件同步下发功能才能这样直接使用
  district.search('凉山彝族自治州', function(status, result) {
    if (status == 'complete') {
      getData(result.districtList[0]);
    }
  });
});



function getData(data) {
  var bounds = data.boundaries;
  if (bounds) {
    for (var i = 0, l = bounds.length; i < l; i++) {
      var polygon = new AMap.Polygon({
        map: map,
        strokeWeight: 1,
        strokeColor: '#CC66CC',
        fillColor: '#CCF3FF',
        fillOpacity: 0,
        path: bounds[i]
      });
      polygons.push(polygon);
    }
    map.setFitView(); //地图自适应
  }

  var subList = data.districtList;
  var level = data.level;

  if (level === 'city') {
    if (subList) {
      var contentSub = new Option('--请选择--');
      for (var i = 0, l = subList.length; i < l; i++) {
        var name = subList[i].name;
        var levelSub = subList[i].level;
        var cityCode = subList[i].citycode;
        if (i == 0) {
          document.querySelector('#' + levelSub).add(contentSub);
        }
        contentSub = new Option(name);
        contentSub.setAttribute("value", levelSub);
        contentSub.center = subList[i].center;
        contentSub.adcode = subList[i].adcode;
        document.querySelector('#' + levelSub).add(contentSub);
      }
    }
  }


}

function search(obj) {
  //清除地图上所有覆盖物
  for (var i = 0, l = polygons.length; i < l; i++) {
    polygons[i].setMap(null);
  }
  var option = obj[obj.options.selectedIndex];
  var keyword = option.text; //关键字
  var adcode = option.adcode;
  district.setLevel(option.value); //行政区级别
  district.setExtensions('all');
  //行政区查询
  //按照adcode进行查询可以保证数据返回的唯一性
  district.search(adcode, function(status, result) {
    if (status === 'complete') {
      getData(result.districtList[0]);
    }
  });
}

function setCenter(obj) {
  map.setCenter(obj[obj.options.selectedIndex].center)
}
