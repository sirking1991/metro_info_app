import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:metro_info/models/news.dart';
import 'package:metro_info/networking/api_provider.dart';
import 'package:metro_info/views/news_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsList extends StatefulWidget {
  @override
  _NewsListState createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {

  int _lgu = 0;

  SharedPreferences _prefs;

  List<News> _news = [];

  @override
  void initState() {
    _getPrefs();    
    super.initState();
  }

  _getPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _lgu = _prefs.getInt("lgu_id");

    var tmp = _prefs.getString("news");
    if(null != tmp) {      
      List tmpNewsList = News.getMapLGUs(json.decode(tmp));
      print("displaying news from cache");
      setState(() => _news = tmpNewsList);
    }

    _getNewsFromAPI();
  }

  _getNewsFromAPI(){
    ApiProvider().get("news/$_lgu")
      .then((response){
        print("displaying news from API");

        // save the news to pref so we can load his later
        _prefs.setString("news", json.encode(response));

        // rebuild
        setState(() =>_news = News.getMapLGUs(response));
      })
      .catchError((onError){
        print(onError);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0, right: 25.0, left: 25.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: Offset(0.0, 3.0),
              blurRadius: 15.0,
            ),
          ],
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Text(
                'News',
                style: TextStyle(
                  color: Colors.black.withOpacity(0.7),
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ),
            Column(              
              children: <Widget>[
                ..._news.map((n){
                  return ListItem(n);
                }),                
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ListItem extends StatefulWidget {
  var _news;

  ListItem(this._news);

  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  @override
  Widget build(BuildContext context) {
    var _icon = Icons.mail_outline;

    var jiffy = Jiffy(DateTime.parse( widget._news.postingDate))
      ..startOf(Units.HOUR);

    return ListTile(
      leading: Icon(_icon, size: 30.0, ),
      title: Text(
        widget._news.subject,
        style: TextStyle(fontSize: 20.0),
      ),
      subtitle: Text(jiffy.fromNow() ),
      enabled: true,
      contentPadding: EdgeInsets.only(top: 10.0, left: 10, right: 10),
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) => NewsDetail(widget._news)));
      },
    );
  }
}
