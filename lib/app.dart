import 'dart:io';
import 'package:flutter/material.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter_jpush/flutter_jpush.dart';

import 'routes/routers.dart';
import 'routes/application.dart' show Application;
import "pages/SingleManagerWidgets.dart";
import 'event/ApplicationEvent.dart';
import "util/sp.dart";
import 'util/logger.dart';

class Navigation extends StatefulWidget {
  Navigation(){

  }
  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _currentIndex = 0;
  Choice _currentItem = choices.elementAt(0);
  BottomNavigationBarType _type = BottomNavigationBarType.fixed;

  _NavigationState(){
    final eventBus = new EventBus();
    ApplicationEvent.event = eventBus;
  }

  //极光推送初始化
  void _initJPush() async {
    await FlutterJPush.startup();
    logger.info("初始化jpush成功");

    // 获取 registrationID
    var registrationID =await FlutterJPush.getRegistrationID();
    logger.info(registrationID);

    // 注册接收和打开 Notification()
    _initNotification();
  }

  void _initNotification() async {

    FlutterJPush.addConnectionChangeListener((bool connected) {
      setState(() {
        /// 是否连接，连接了才可以推送
        print("连接状态改变:$connected");
        if (connected) {
          //在启动的时候会去连接自己的服务器，连接并注册成功之后会返回一个唯一的设备号
          try {
            FlutterJPush.getRegistrationID().then((String regId) {
              print("主动获取设备号:$regId");
            });
          } catch (error) {
            print('主动获取设备号Error:$error');
          }
        }
      });
    });

    FlutterJPush.addReceiveNotificationListener(
            (JPushNotification notification) {
              logger.info("收到推送提醒: $notification");
        }
    );

    FlutterJPush.addReceiveOpenNotificationListener(
            (JPushNotification notification) {
              logger.info("打开了推送提醒: $notification");
        }
    );

    FlutterJPush.addReceiveCustomMsgListener((JPushMessage msg) {
      setState(() {
        print("收到推送消息提醒: $msg");

      });
    });
  }

  @override
  void initState() {
    super.initState();
    _initJPush();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      title: "Home",
      theme: new ThemeData(
        primarySwatch: Colors.blue
      ),
      routes: Routes.getRoutes(),
      onGenerateRoute: (RouteSettings settings) {
        print("#########onGenerateRoute");
          return MaterialPageRoute(builder: (context) {
            String routeName = settings.name;
            print("routeName:" + routeName);
            // 如果访问的路由页需要登录，但当前未登录，则直接返回登录页路由，
            // 引导用户登录；其它情况则正常打开路由。

          });
      },
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (BuildContext context) =>
              Scaffold(body: SingleManagerWidgets.instance.getNotFound()),
        );
      },
      home: Scaffold(
        appBar: AppBar(
          title: Text(_currentItem.title),
        ),
        body: buildBody(),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget buildBody() {
    return choices.elementAt(_currentIndex).container;
  }

  Widget _buildBottomNavigationBar() {
    //侦听导航Tab变化，可能来自其他页面的切换请求
    ApplicationEvent.event.on<EvtHomeNavChange>().listen((event){
      setState(() {
        _currentIndex = event.index;
        _currentItem = choices.elementAt(_currentIndex);
      });;
    });

    return SafeArea(
        child: SizedBox(
            height: 50.0,
            child: Card(
                color: Platform.isIOS ? Colors.transparent : Colors.white,
                elevation: Platform.isIOS ? 0.0 : 8.0,
                // iphone 无阴影
                shape: RoundedRectangleBorder(),
                margin: EdgeInsets.all(0.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Divider(color: Color(0xFFE0E0E0), height: 0.5),
                      Expanded(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: choices.map((Choice item){
                                return _buildBottomItem(
                                    icon: item.icon, text: item.title, index: item.index
                                );
                              }).toList()
                            ),
                      )
                    ]))));
  }

  Widget _buildBottomItem({IconData icon, String text, int index}) {
    Color color =
    _currentIndex == index ? Theme.of(context).primaryColor : Colors.grey;
    return Expanded(
        child: InkResponse(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(icon, color: color, size: 22.0),
                  // Image.asset(, color: color, width: 22.0, height: 22.0),
                  Text(text, style: TextStyle(color: color, fontSize: 10.0))
                ]),
            onTap: () => setState(() => _currentIndex = index)));
  }

  BottomNavigationBarItem _buildItem({IconData icon, Choice item}) {
    String text = item.title;
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        color: _colorTabMatching(item: item),
      ),
      title: Text(
        text,
        style: TextStyle(
          color: _colorTabMatching(item: item),
        ),
      ),
    );
  }

  Color _colorTabMatching({Choice item}) {
    return _currentItem == item ? Theme.of(context).primaryColor : Colors.grey;
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _currentItem = choices.elementAt(_currentIndex);
    });
  }
}

class Button extends StatelessWidget {
  final String text;
  final VoidCallback onPress;

  const Button({Key key, this.text, @required this.onPress}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: Colors.lightGreen,
      child: Text('$text', style: TextStyle(color: Colors.white)),
      onPressed: onPress,
    );
  }
}

/**
 * 导航内容
 */
class Choice {
  const Choice({ this.index,this.title, this.icon,this.container });
  final String title;
  final Widget container;
  final int index;
  final IconData icon;
}

List<Choice> choices = <Choice>[
  Choice(index:0,title: '首页', icon: Icons.home,container: SingleManagerWidgets.instance.getHome()),
  Choice(index:1,title: '动态', icon: Icons.access_alarm,container: SingleManagerWidgets.instance.getTimeline()),
  Choice(index:2,title: '项目', icon: Icons.menu,container: SingleManagerWidgets.instance.getBody()),
  Choice(index:3,title: '我的', icon: Icons.settings,container: SingleManagerWidgets.instance.getMe()),
];