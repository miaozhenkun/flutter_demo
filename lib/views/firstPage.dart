import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:manhua/util/CommonUtils.dart';
import 'package:manhua/util/redux/MkState.dart';
import 'package:manhua/util/shared_preferences.dart';
import 'package:manhua/views/TsPage.dart';
import 'package:manhua/views/XsDetail.dart';
import 'package:manhua/views/videPage.dart';

class FirstPage extends StatefulWidget {
  @override
  createState() => new FirstPageState();
}

class FirstPageState extends State<FirstPage> {

  //创建页面切换动画
  SlideTransition createTransition(Animation<double> animation, Widget child) {
    return new SlideTransition(
      position: new Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: const Offset(0.0, 0.0),
      ).animate(animation),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(child: new StoreBuilder<MkState>(builder: (context, store) {
      return new Scaffold(
          appBar: new AppBar(
              title: new Center(
            child: new Text('首页'),
          )),
          body: new RotatedBox(
              quarterTurns: 4,
              // height: .0,
              child: Card(
                  child: new Column(children: [
                new ListTile(
                  title: new Text('唐诗',
                      style: new TextStyle(fontWeight: FontWeight.w500)),
                  subtitle: new Text('唐朝'),
                  leading: new Icon(
                    Icons.business,
                    color: Colors.blue[500],
                  ),
                  onTap: () => toTsPage(),
                ),
                new Divider(),
                new ListTile(
                  title: new Text('小说',
                      style: new TextStyle(fontWeight: FontWeight.w500)),
                  subtitle: new Text('小说在线阅读'),
                  leading: new Icon(
                    Icons.contact_phone,
                    color: Colors.blue[500],
                  ),
                  onTap: () => toXsPage(),
                ),
                new Divider(),
                new ListTile(
                  title: new Text('搞笑视频',
                      style: new TextStyle(fontWeight: FontWeight.w500)),
                  subtitle: new Text('视频'),
                  leading: new Icon(
                    Icons.contact_phone,
                    color: Colors.blue[500],
                  ),
                  onTap: () => toVideoPage(),
                ),
                new Divider(),
                new ListTile(
                  title: new Text('夜间模式点我',
                      style: new TextStyle(fontWeight: FontWeight.w500)),
                  subtitle: new Text('点我'),
                  leading: new Icon(
                    Icons.contact_mail,
                    color: Colors.blue[500],
                  ),
                  onTap: () => switchTheme(context, store),
                ),
                new Divider(),
              ]))));
    }));
  }

  void toTsPage() {
    //不带动画跳转
    // Navigator.push(
    //     context, new MaterialPageRoute(builder: (context) => new TsPage()));
    //页面从左到右
    Navigator.push<String>(
        context,
        new PageRouteBuilder(pageBuilder: (BuildContext context,
            Animation<double> animation, Animation<double> secondaryAnimation) {
          // 跳转的路由对象
          return new TsPage();
        }, transitionsBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
        ) {
          return createTransition(animation, child);
        }));
  }

  void toXsPage() {
    Navigator.push(context,
        new MaterialPageRoute(builder: (context) => new XsDetailPage()));
  }

  void toVideoPage() {
    Navigator.push(
        context, new MaterialPageRoute(builder: (context) => new videoPage()));
  }

  //切换夜间模式
  void switchTheme(context, store) async {
    var list = ['白天', '夜间'];
    var sp = await SpUtil.getInstance();
    CommonUtils.showCommitOptionDialog(context, list, (index) {
      sp.putInt('theme', index + 1);
      CommonUtils.pushTheme(store, index + 1);
      //LocalStorage.save(Config.THEME_COLOR, index.toString());
    }, colorList: CommonUtils.getThemeListColor());
  }
}
