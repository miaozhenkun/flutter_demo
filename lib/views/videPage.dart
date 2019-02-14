import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:manhua/http/Constants.dart';
import 'package:manhua/http/HttpService.dart';
import 'package:manhua/views/videoPlay.dart';
import '../http/Constants.dart';
import '../http/HttpService.dart';

class videoPage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<videoPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text('搞笑视频'),
      ),
      body: new vPage(),
    );
  }
}

class vPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new GridViewState();
}

class GridViewState extends State with AutomaticKeepAliveClientMixin {
  var resultList = [];
  var channellist = [];
  var channel = [];
  var result = [];
  var params = {'page': 1, 'count': 5, 'type': 'video'};
  ScrollController _scrollController = ScrollController();
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    getData(false);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new GridView.count(
        controller: _scrollController,
        primary: false,
        padding: const EdgeInsets.all(8.0),
        mainAxisSpacing: 2.0, //竖向间距
        crossAxisCount: 1, //横向Item的个数
        crossAxisSpacing: 8.0, //横向间距
        children: buildGridTileList());
  }

  List<Widget> buildGridTileList() {
    List<Widget> widgetList = new List();
    print(channellist.length);
    for (int i = 0; i < channellist.length; i++) {
      widgetList.add(getItemWidget(channellist[i], i));
    }
    return widgetList;
  }

  Widget getItemWidget(channellist, int index) {
    //BoxFit 可设置展示图片时 的填充方式
    if (index < channellist.length - 1) {
      return GestureDetector(
        child: Card(
          child: new Column(
            children: <Widget>[
              Stack(
                alignment: const FractionalOffset(0, 1),
                children: <Widget>[
                  Container(
                    height: 300.0,
                    child: Image(
                      width: double.infinity,
                      image: new CachedNetworkImageProvider(
                          channellist['thumbnail']),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Center(
                    child: Container(
                      child: Text(
                        channellist['text'],
                        style: TextStyle(color: Colors.white, fontSize: 18.0),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        onTap: () => _toPlay(channellist['video']),
      );
    }
    if (index == channellist.length - 1) {
      return _getMoreWidget();
    }
  }

  // getData() {
  //   HttpService.get(Constants.videoUrl, (res) {
  //     resultList = jsonDecode(res)['result'];
  //     print(resultList);
  //     if (resultList.length > 0) {
  //       setState(() {
  //         channellist = resultList;
  //         print(channellist);
  //       });
  //     }
  //   }, params: {'page': 1, 'count': 10, 'type': 'video'});
  // }

  getData(isloadmore) {
    HttpService.get(Constants.videoUrl, (res) {
      resultList = jsonDecode(res)['result'];
      if (isloadmore) {
        print('加载更多');
        result.addAll(resultList);
      } else {
        print('不是加载更多');
        result = resultList;
      }
      print(result.length);
      if (result.length > 0) {
        setState(() {
          channellist = result;
        });
      }
    }, params: params);
  }

  _toPlay(String videoUrl) {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new videoPlayPage(videoUrl: videoUrl)));
  }

  /**
   * 加载更多时显示的组件,给用户提示
   */
  Widget _getMoreWidget() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              '稍等片刻...',
              style: TextStyle(fontSize: 16.0),
            ),
            CircularProgressIndicator(
              strokeWidth: 1.0,
            )
          ],
        ),
      ),
    );
  }

  /*
   * 上拉加载
   */
  void _getMore() {
    int page = params['page'];
    params['page'] = page + 1;
    getData(true);
    return;
  }
}
