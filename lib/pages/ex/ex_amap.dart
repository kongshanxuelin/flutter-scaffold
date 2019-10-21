import 'package:amap_base/amap_base.dart';
import 'package:flutter/material.dart';
import 'package:ssi/util/ui_common.dart';
const SPACE_NORMAL = const SizedBox(width: 8, height: 8);
const kDividerTiny = const Divider(height: 1);

class ExAMapPage extends StatefulWidget {
  ExAMapPage();

  factory ExAMapPage.forDesignTime() => ExAMapPage();

  @override
  _ShowMapScreenState createState() => _ShowMapScreenState();
}

class _ShowMapScreenState extends State<ExAMapPage> {
  AMapController _controller;
  MyLocationStyle _myLocationStyle = MyLocationStyle();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('显示地图')),
      body: Column(
        children: <Widget>[
          Flexible(
            child: AMapView(
              onAMapViewCreated: (controller) {
                _controller = controller;
              },
              amapOptions: AMapOptions(
                compassEnabled: false,
                zoomControlsEnabled: true,
                logoPosition: LOGO_POSITION_BOTTOM_CENTER,
                camera: CameraPosition(
                  target: LatLng(40.851827, 111.801637),
                  zoom: 15,
                ),
              ),
            ),
          ),
          Flexible(
            child: Builder(
              builder: (context) {
                return ListView(
                  children: <Widget>[
                    BooleanSetting(
                      head: '显示自己的位置 [Android, iOS]',
                      selected: false,
                      onSelected: (value) {
                        _updateMyLocationStyle(context, showMyLocation: value);
                      },
                    ),
                    ContinuousSetting(
                      head: '横坐标偏移量 [Android]',
                      onChanged: (value) {
                        _updateMyLocationStyle(context, anchorU: value);
                      },
                    ),
                    ContinuousSetting(
                      head: '纵坐标偏移量 [Android]',
                      onChanged: (value) {
                        _updateMyLocationStyle(context, anchorV: value);
                      },
                    ),
                    ColorSetting(
                      head: '圆形区域（以定位位置为圆心，定位半径的圆形区域）的填充颜色值 [Android, iOS]',
                      onSelected: (color) {
                        _updateMyLocationStyle(context, radiusFillColor: color);
                      },
                    ),
                    ColorSetting(
                      head: '圆形区域（以定位位置为圆心，定位半径的圆形区域）边框的颜色值 [Android, iOS]',
                      onSelected: (color) {
                        _updateMyLocationStyle(context, strokeColor: color);
                      },
                    ),
                    ContinuousSetting(
                      head: '圆形区域（以定位位置为圆心，定位半径的圆形区域）边框的宽度 [Android, iOS]',
                      max: 50,
                      onChanged: (value) {
                        _updateMyLocationStyle(context, strokeWidth: value);
                      },
                    ),
                    DiscreteSetting(
                      head: '我的位置展示模式 [Android]',
                      options: [
                        '定位、且将视角移动到地图中心点，定位点跟随设备移动',
                        '定位、但不会移动到地图中心点，并且会跟随设备移动',
                        '定位、且将视角移动到地图中心点',
                        '定位、且将视角移动到地图中心点，定位点依照设备方向旋转，并且会跟随设备移动',
                        '定位、但不会移动到地图中心点，定位点依照设备方向旋转，并且会跟随设备移动',
                        '定位、且将视角移动到地图中心点，地图依照设备方向旋转，定位点会跟随设备移动',
                        '定位、但不会移动到地图中心点，地图依照设备方向旋转，并且会跟随设备移动',
                        '只定位',
                      ],
                      onSelected: (value) {
                        int locationType;
                        switch (value) {
                          case '定位、且将视角移动到地图中心点，定位点跟随设备移动':
                            locationType = LOCATION_TYPE_FOLLOW;
                            break;
                          case '定位、但不会移动到地图中心点，并且会跟随设备移动':
                            locationType = LOCATION_TYPE_FOLLOW_NO_CENTER;
                            break;
                          case '定位、且将视角移动到地图中心点':
                            locationType = LOCATION_TYPE_LOCATE;
                            break;
                          case '定位、且将视角移动到地图中心点，定位点依照设备方向旋转，并且会跟随设备移动':
                            locationType = LOCATION_TYPE_LOCATION_ROTATE;
                            break;
                          case '定位、但不会移动到地图中心点，定位点依照设备方向旋转，并且会跟随设备移动':
                            locationType =
                                LOCATION_TYPE_LOCATION_ROTATE_NO_CENTER;
                            break;
                          case '定位、且将视角移动到地图中心点，地图依照设备方向旋转，定位点会跟随设备移动':
                            locationType = LOCATION_TYPE_MAP_ROTATE;
                            break;
                          case '定位、但不会移动到地图中心点，地图依照设备方向旋转，并且会跟随设备移动':
                            locationType = LOCATION_TYPE_MAP_ROTATE_NO_CENTER;
                            break;
                          case '只定位':
                            locationType = LOCATION_TYPE_SHOW;
                            break;
                        }
                        _updateMyLocationStyle(context,
                            myLocationType: locationType);
                      },
                    ),
                    Builder(
                      builder: (context) {
                        return ContinuousSetting(
                          head: '定位请求时间间隔, 单位毫秒 [Android]',
                          max: 5,
                          onChanged: (value) {
                            _updateMyLocationStyle(context,
                                interval: value.round() * 1000);

                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text('定位间隔${value.round()}秒'),
                              duration: Duration(seconds: 1),
                            ));
                          },
                        );
                      },
                    ),
                    BooleanSetting(
                      head: '精度圈是否显示 [iOS]',
                      selected: _myLocationStyle.showsAccuracyRing,
                      onSelected: (value) {
                        _updateMyLocationStyle(context,
                            showsAccuracyRing: value);
                      },
                    ),
                    BooleanSetting(
                      head: '是否显示方向指示 [iOS]',
                      selected: _myLocationStyle.showsHeadingIndicator,
                      onSelected: (value) {
                        _updateMyLocationStyle(context,
                            showsHeadingIndicator: value);
                      },
                    ),
                    ColorSetting(
                      head: '定位点背景色，不设置默认白色 [iOS]',
                      onSelected: (value) {
                        _updateMyLocationStyle(context,
                            locationDotBgColor: value);
                      },
                    ),
                    ColorSetting(
                      head: '定位点蓝色圆点颜色，不设置默认蓝色 [iOS]',
                      onSelected: (value) {
                        _updateMyLocationStyle(context,
                            locationDotFillColor: value);
                      },
                    ),
                    BooleanSetting(
                      head: '内部蓝色圆点是否使用律动效果, 默认YES [iOS]',
                      selected: _myLocationStyle.enablePulseAnnimation,
                      onSelected: (value) {
                        _updateMyLocationStyle(context,
                            enablePulseAnnimation: value);
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _updateMyLocationStyle(
      BuildContext context, {
        String myLocationIcon,
        double anchorU,
        double anchorV,
        Color radiusFillColor,
        Color strokeColor,
        double strokeWidth,
        int myLocationType,
        int interval,
        bool showMyLocation,
        bool showsAccuracyRing,
        bool showsHeadingIndicator,
        Color locationDotBgColor,
        Color locationDotFillColor,
        bool enablePulseAnnimation,
        String image,
      }) async {
    if (await Permissions().requestPermission()) {
      _myLocationStyle = _myLocationStyle.copyWith(
        myLocationIcon: myLocationIcon,
        anchorU: anchorU,
        anchorV: anchorV,
        radiusFillColor: radiusFillColor,
        strokeColor: strokeColor,
        strokeWidth: strokeWidth,
        myLocationType: myLocationType,
        interval: interval,
        showMyLocation: showMyLocation,
        showsAccuracyRing: showsAccuracyRing,
        showsHeadingIndicator: showsHeadingIndicator,
        locationDotBgColor: locationDotBgColor,
        locationDotFillColor: locationDotFillColor,
        enablePulseAnnimation: enablePulseAnnimation,
        image: image,
      );
      _controller.setMyLocationStyle(_myLocationStyle);
    } else {
      //showError(context, '权限不足');
      SsUI.alert(context, "曲线不足");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}


/// 连续设置
class ContinuousSetting extends StatefulWidget {
  const ContinuousSetting({
    Key key,
    @required this.head,
    @required this.onChanged,
    this.min = 0,
    this.max = 1,
  }) : super(key: key);

  final String head;
  final ValueChanged<double> onChanged;
  final double min;
  final double max;

  @override
  _ContinuousSettingState createState() => new _ContinuousSettingState();
}

class _ContinuousSettingState extends State<ContinuousSetting> {
  double _value;

  @override
  void initState() {
    super.initState();
    _value = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        top: 16,
        right: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(widget.head, style: Theme.of(context).textTheme.subhead),
          SPACE_NORMAL,
          Slider(
            value: _value,
            min: widget.min,
            max: widget.max,
            onChanged: (_) {},
            onChangeEnd: (value) {
              setState(() {
                _value = value;
                widget.onChanged(value);
              });
            },
          ),
          kDividerTiny,
        ],
      ),
    );
  }
}

/// 离散设置
class DiscreteSetting extends StatelessWidget {
  const DiscreteSetting({
    Key key,
    @required this.head,
    @required this.options,
    @required this.onSelected,
  }) : super(key: key);

  final String head;
  final List<String> options;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        PopupMenuButton<String>(
          onSelected: onSelected,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(head, style: Theme.of(context).textTheme.subhead),
          ),
          itemBuilder: (context) {
            return options
                .map((value) => PopupMenuItem<String>(
              child: Text(value),
              value: value,
            ))
                .toList();
          },
        ),
        kDividerTiny,
      ],
    );
  }
}

/// 颜色设置
class ColorSetting extends StatelessWidget {
  const ColorSetting({
    Key key,
    @required this.head,
    @required this.onSelected,
  }) : super(key: key);

  final String head;
  final ValueChanged<Color> onSelected;

  @override
  Widget build(BuildContext context) {
    return DiscreteSetting(
      head: head,
      options: ['绿色', '红色', '黄色'],
      onSelected: (value) {
        Color color;
        switch (value) {
          case '绿色':
            color = Colors.green.withOpacity(0.6);
            break;
          case '红色':
            color = Colors.red.withOpacity(0.6);
            break;
          case '黄色':
            color = Colors.yellow.withOpacity(0.6);
            break;
        }

        onSelected(color);
      },
    );
  }
}

/// 二元设置
class BooleanSetting extends StatefulWidget {
  const BooleanSetting({
    Key key,
    @required this.head,
    @required this.onSelected,
    this.selected = false,
  }) : super(key: key);

  final String head;
  final ValueChanged<bool> onSelected;
  final bool selected;

  @override
  _BooleanSettingState createState() => _BooleanSettingState();
}

class _BooleanSettingState extends State<BooleanSetting> {
  bool _selected;

  @override
  void initState() {
    super.initState();

    _selected = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SwitchListTile(
          title: Text(widget.head),
          value: _selected,
          onChanged: (selected) {
            setState(() {
              _selected = selected;
              widget.onSelected(selected);
            });
          },
        ),
        kDividerTiny,
      ],
    );
  }
}

/// 输入文字
class TextSetting extends StatelessWidget {
  final String leadingString;
  final String hintString;

  const TextSetting({
    Key key,
    @required this.leadingString,
    @required this.hintString,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(leadingString),
      title: TextFormField(
        decoration: InputDecoration(
          hintText: hintString,
        ),
      ),
    );
  }
}