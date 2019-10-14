import 'package:flutter/material.dart';
import 'package:amap_base/amap_base.dart'; //高德地图amap_base_map
import 'dart:math';
import 'package:permission_handler/permission_handler.dart';
import 'package:ssi/util/ui_common.dart';//权限
/**
 * ShowMapScreen
 * 地图缩放
 * 标注
 */
class ExAMapPage extends StatefulWidget {
  @override
  _ShowMapScreenState createState() => _ShowMapScreenState();
}
const markerList = const [
  LatLng(30.308802, 120.071179),
  LatLng(30.2412, 120.00938),
  LatLng(30.296945, 120.35133),
  LatLng(30.328955, 120.365063),
  LatLng(30.181862, 120.369183),
];
class _ShowMapScreenState extends State<ExAMapPage> {
  AMapController _controller;
  final _amapLocation = AMapLocation();//定位
  double lat ;
  double lng ;
  @override
  void initState() {
    _getLocation();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('绘制点标记'),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Builder(
        builder: (context) {
          return AMapView(
            onAMapViewCreated: (controller) {
              _controller = controller;
              //插件代码报错，剪到本地git，有修改。
              _controller.markerClickedEvent.listen((it){
                //处理点击事件
                //清空标记
                _controller.clearMarkers();
                //标点
                _controller.addMarker(MarkerOptions(
                  //position: it,
                ));
                //缩放定位
                //_controller.changeLatLng(it);

              });
              //点击标注图标执行
              /*controller
                ..addMarkers(
                  markerList
                      .map((latLng) =>
                      MarkerOptions(
                        icon: 'images/home_map_icon_positioning_nor.png',
                        position: latLng,
                        title: '哈哈',
                        snippet: '呵呵',
                        object: '测试数据$latLng',
                      ))
                      .toList(),
                )
                ..setZoomLevel(10);*/
            },
            amapOptions:AMapOptions(
              compassEnabled: false,
              zoomControlsEnabled: true,
              logoPosition: LOGO_POSITION_BOTTOM_CENTER,
              camera: CameraPosition(
                target: LatLng(40.851827, 111.801637),
                zoom: 15,
              ),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          _getLocation();
          //_clearLocation();
          /*final nextLatLng = _nextLatLng();
          await _controller.addMarker(MarkerOptions(
            position: nextLatLng,
          ));
          await _controller.changeLatLng(nextLatLng);*/
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
//随机生成经纬度
  LatLng _nextLatLng() {
    final _random = Random();
    double nextLat = (301818 + _random.nextInt(303289 - 301818)) / 10000;
    double nextLng = (1200093 + _random.nextInt(1203691 - 1200093)) / 10000;
    return LatLng(nextLat, nextLng);
  }
  //清空标记
  _clearLocation(){
    //_controller.clearMap();
    _controller.clearMarkers();
  }
  //定位标记
  _getLocation()async{
    _amapLocation.init();
    final options = LocationClientOptions(
      isOnceLocation: true,
      locatingWithReGeocode: true,
    );
    //监听可以获取位置
    _amapLocation.startLocate(options).listen((location) => setState(() {
      lat = location.latitude;
      lng = location.longitude;
      if(lat>0&&lng>0){
        checkPersmission();
      }else{
        getFloat('获取位置失败，请检测GPS是否开启！');
      }
    }));
  }
  //是否开启权限
  void checkPersmission() async {
    // 申请权限
    Map<PermissionGroup, PermissionStatus> permissions =
    await PermissionHandler().requestPermissions([PermissionGroup.location]);
    // 申请结果
    PermissionStatus permission =
    await PermissionHandler().checkPermissionStatus(PermissionGroup.location);
    if (permission == PermissionStatus.granted) {
      ///地图标注
      final nextLatLng = LatLng(lat, lng);
      //清空标记
      _controller.clearMarkers();
      //标点
      _controller.addMarker(MarkerOptions(
        position: nextLatLng,
      ));
      //缩放定位
      _controller.changeLatLng(nextLatLng);
    } else {
      getFloat('请打开GPS和允许定位权限');
    }
  }
  //判空
  bool isNotEmpty(var text){
    if(text==null||text.toString().isEmpty||text.toString()=='null'||text.toString()==null){
      return false;
    }else{
      return true;
    }
  }
  //提示框
  getFloat(String text) {
    SsUI.toast(context, text);
  }
}
