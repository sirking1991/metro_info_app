import 'package:flutter/material.dart';
import 'package:metro_info/models/news.dart';
import 'package:metro_info/networking/api_provider.dart';
import 'package:metro_info/views/news_detail.dart';

class NewsList extends StatefulWidget {
  @override
  _NewsListState createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  List<News> _news = [
    News(postingDate: "2020-04-11 08:22:00", subject: "News1: Aenean aliquet, tellus et semper aliquet", content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit Lorem ipsum dolor sit amet, consectetur adipiscing elit Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit Lorem ipsum dolor sit amet, consectetur adipiscing elit Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit Lorem ipsum dolor sit amet, consectetur adipiscing elit Lorem ipsum dolor sit amet, consectetur adipiscing elit"),
    News(postingDate: "2020-04-10 08:22:00", subject: "News2: Lorem ipsum dolor sit amet, consectetur ", content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit Lorem ipsum dolor sit amet, consectetur adipiscing elit Lorem ipsum dolor sit amet, consectetur adipiscing elit"),
    News(postingDate: "2020-04-09 08:22:00", subject: "News3: consectetur adipiscing elit Lorem ipsum dolor sit amet,", content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit Lorem ipsum dolor sit amet, consectetur adipiscing elit Lorem ipsum dolor sit amet, consectetur adipiscing elit"),
    News(postingDate: "2020-04-09 13:22:00", subject: "News4: dolor sit amet, consectetur adipiscing elit,", content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit Lorem ipsum dolor sit amet, consectetur adipiscing elit Lorem ipsum dolor sit amet, consectetur adipiscing elit"),
    News(postingDate: "2020-04-07 08:22:00", subject: "News5: Ladipiscing elit Lorem ipsum dolor sit amet,", content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit Lorem ipsum dolor sit amet, consectetur adipiscing elit Lorem ipsum dolor sit amet, consectetur adipiscing elit"),
  ];
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
  initState(){
    print("initState");
    _retrieveNews();
  }

  _retrieveNews(){
    print("_retrieveNews()");
    final ApiProvider _provider = ApiProvider();
    try {
      _provider.get("news/1/0").then((news) {
        print(news);
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  @override
  Widget build(BuildContext context) {
    var _icon = Icons.mail_outline;
    var _postingDateString  = widget._news.postingDate;    

    return ListTile(
      leading: Icon(_icon, size: 30.0, ),
      title: Text(
        widget._news.subject,
        style: TextStyle(fontSize: 20.0),
      ),
      subtitle: Text(_postingDateString),
      enabled: true,
      contentPadding: EdgeInsets.only(top: 10.0, left: 10, right: 10),
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) => NewsDetail(widget._news)));
      },
    );
  }
}
