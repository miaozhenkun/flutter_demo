import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:manhua/util/CommonUtils.dart';
import 'package:manhua/util/redux/MkState.dart';
import 'package:manhua/util/shared_preferences.dart';
import 'package:manhua/views/DtDetail.dart';
import 'package:manhua/views/LoginPage.dart';
import 'package:manhua/views/TsPage.dart';
import 'package:manhua/views/XsDetail.dart';
import 'package:manhua/views/videPage.dart';
import 'package:manhua/views/videoPlay.dart';
import 'package:redux/redux.dart';
import './views/firstPage.dart';
import './views/secPage.dart';
import './views/thirdPage.dart';
import './views/MyPage.dart';
import './views/Detail.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'dart:async';

SpUtil sp;
void main() async{
  //debugPaintSizeEnabled = true;
  sp = await SpUtil.getInstance();
  //sp.get('theme');
  print(sp.get('theme'));
  runApp(new FlutterReduxApp());
}

class FlutterReduxApp extends StatelessWidget {
  final store = new Store<MkState>(
    appReducer,
    ///初始化数据
    initialState: new MkState(
      themeData: CommonUtils.getThemeData(sp.get('theme')==null?1:sp.get('theme')),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return new StoreProvider(
        store: store,
        child: new StoreBuilder<MkState>(builder: (context, store) {
          return new MaterialApp(
            home: MyApp(),
            // theme: ThemeData(
            //   brightness: Brightness.light,
            //   backgroundColor: Colors.cyan[200],
            //   textTheme: TextTheme(
            //       display1: TextStyle(fontSize: 17.0, color: Colors.black),
            //       display2: TextStyle(fontSize: 13.0, color: Colors.grey),
            //       display3: TextStyle(fontSize: 23.0, color: Colors.black)),
            // ),
            theme: store.state.themeData,
            routes: <String, WidgetBuilder>{
              '/loginpage': (BuildContext context) => new LoginPage(),
              '/detail': (BuildContext context) => new DetailPage(params: {}),
              '/xsdetail': (BuildContext context) => new XsDetailPage(),
              '/dtdetail': (BuildContext context) =>new DtDetailPage(channelname: ''),
              '/tspage': (BuildContext context) => new TsPage(),
              '/videoPage': (BuildContext context) => new videoPage(), 
              '/videoPlayPage': (BuildContext context) => new videoPlayPage(videoUrl:''),                             
            },
          );
        }));
  }
}

class MyApp extends StatefulWidget {
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  PageController pageController;
  int currentIndex = 0;
  final JPush jpush = new JPush();
  @override
  void initState() {
    super.initState();
    this.pageController = PageController(initialPage: this.currentIndex);
    initPlatformState();
  }

  //极光推送配置
  Future<void> initPlatformState() async {
    jpush.getRegistrationID().then((rid) {
      print(rid);
    });
    jpush.setup(
      appKey: "114311f50bb78a9fef2e86b1",
      channel: "theChannel",
      production: false,
      debug: true,
    );
    jpush.applyPushAuthority(
        new NotificationSettingsIOS(sound: false, alert: false, badge: false));
    try {
      jpush.addEventHandler(
        onReceiveNotification: (Map<String, dynamic> message) async {
          print("flutter onReceiveNotification: $message");
        },
        onOpenNotification: (Map<String, dynamic> message) async {
          print("flutter onOpenNotification: $message");
        },
        onReceiveMessage: (Map<String, dynamic> message) async {
          print("flutter onReceiveMessage: $message");
        },
      );
    } on Exception {}
  }

  //重新 build 方法
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today),
                title: Text("首页"),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                title: Text("发现"),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.collections),
                title: Text("电台"),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                title: Text("我的"),
              ),
            ],
            fixedColor: Colors.green,
            type: BottomNavigationBarType.fixed,
            onTap: (page) {
              pageController.jumpToPage(page);
            },
            currentIndex: this.currentIndex,
          ),
          body: PageView(
            children: <Widget>[
              new FirstPage(),
              new SecPage(),
              new ThirdPage(),
              new ProfileWidget()
            ],
            controller: this.pageController,
            onPageChanged: (index) {
              setState(() {
                this.currentIndex = index;
              });
            },
          ),
        ));
  }

  //监听APP退出方法
  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
                title: new Text('确定吗?'),
                content: new Text('退出APP'),
                actions: <Widget>[
                  new FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: new Text('否'),
                  ),
                  new FlatButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: new Text('是'),
                  ),
                ],
              ),
        ) ??
        false;
  }
}
