import 'package:flutter/material.dart';
import '../net/httpclient.dart';
import '../net/http_config.dart';
import '../models/news.dart';
import 'news_list_item.dart';
import 'dart:convert';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/delivery_header.dart';
import 'package:flutter_easyrefresh/material_footer.dart';

// 科技新闻列表
class TechNewsListPage extends StatefulWidget {
  @override
  _TechNewsListPageState createState() => _TechNewsListPageState();
}

class _TechNewsListPageState extends State<TechNewsListPage> with AutomaticKeepAliveClientMixin {
  NewsList newslist;
  int size = 0;
  int _pageNum = 0;
  var datas = [];

  @override
  bool get wantKeepAlive => true;

  // 下拉刷新数据
  Future<Null> _refreshData() async {
    setState(() {
      this._pageNum = 1;
      _getMoreData(false);
    });
  }

  // 上拉加载数据
  Future<Null> _addMoreData() async {
    setState(() {
      this._pageNum += 1;
      _getMoreData(true);
    });
  }

  _getMoreData(bool _ifAdd){
    HttpClient.request(TECH_NEWS_API).then((res){
      Map<String,dynamic> subjects  = json.decode(res.data) as Map;
      if(mounted){
        setState(() {
          this.newslist = NewsList.fromJson(subjects);
          if (_ifAdd) {
            datas.addAll(newslist.result);
          } else {
            datas.clear();
            datas = newslist.result;
          }
          size = datas.length;
        });
      }
    });
  }

  @override
  void initState(){
    super.initState();
    _addMoreData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: EasyRefresh(
          header: DeliveryHeader(),
          footer: MaterialFooter(),
          child: new ListView.separated(
            itemCount: size,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index){
              return NewsListItemPage(datas[index]);
            },
            separatorBuilder: (context, index) {
              return Divider();
            },
          ),
          onRefresh: _refreshData,
          onLoad: _addMoreData,
      ),
    );

  }

}


