import 'package:flutter/material.dart';
import 'package:metro_info/news_detail.dart';
import 'package:metro_info/profile.dart';
import 'package:metro_info/send_message.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'metro-info',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final _navBarTitle = '';
  final lguName = 'Pasay City'; // TODO: This should be taken from localstorage

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final Color _primaryColor = Color.fromRGBO(255, 82, 48, 1);
    final String _lguLogoPath = 'https://upload.wikimedia.org/wikipedia/en/4/48/Ph_seal_ncr_pasay.png';
    final String _lguName = 'Pasay City';
    final String _regionName = 'National Capital Region';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: _primaryColor,
        leading: IconButton(
          icon: Icon(Icons.menu),
          color: Colors.white,
          iconSize: 30.0,
          onPressed: () {
            print('humburger icon clicked');
          },
        ),
        title: Text(
          'metro-info',
          style: TextStyle(fontSize: 30.0, color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person_outline),
            color: Colors.white,
            iconSize: 30.0,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => Profile()));
            },
          )
        ],
      ),
      backgroundColor: Color.fromRGBO(244, 244, 244, 1),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[            
            Stack(
              children: <Widget>[
                TopHeader(_primaryColor),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      child: CachedNetworkImage(
                        imageUrl: _lguLogoPath,
                        width: 120.0,
                      ),
                      padding:
                          EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(_lguName,
                            style:
                                TextStyle(color: Colors.white, fontSize: 25.0)),
                        Text(_regionName,
                            style:
                                TextStyle(color: Colors.white, fontSize: 15.0)),
                      ],
                    ),
                  ],
                )
              ],
            ),
            NewsBox(),
            EventsBox(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _primaryColor,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => SendMessage()));
        },
        tooltip: 'Send ',
        child: Icon(Icons.message),
        foregroundColor: Colors.white,
      ),
    );
  }
}

class NewsBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0, right: 25.0, left: 25.0),
      child: Container(
        width: double.infinity,
        height: 480.0,
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
            ListItem('Aenean aliquet, tellus et semper aliquet',
                'Posted 2 hrs ago', Icons.mail_outline),
            ListItem('Nam porta consectetur arcu', 'Posted 2 hrs ago',
                Icons.mail_outline),
            ListItem('Lorem ipsum dolor sit amet, consectetur adipiscing elit',
                'Posted 3 hrs ago', Icons.mail_outline),
            ListItem('Etiam ac lectus vel enim viverra venenatis.',
                'Posted 1 day ago', Icons.mail_outline),
            ListItem('Duis eget orci quam. Vivamus a ultrices ex',
                'Posted 1 day ago', Icons.mail_outline),
          ],
        ),
      ),
    );
  }
}

class EventsBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0, right: 25.0, left: 25.0),
      child: Container(
        width: double.infinity,
        height: 480.0,
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
                'Events',
                style: TextStyle(
                  color: Colors.black.withOpacity(0.7),
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ),
            ListItem('Aenean aliquet, tellus et semper aliquet',
                'Apr 3, 2020 2pm - 3pm', Icons.today),
            ListItem('Nam porta consectetur arcu', 'Apr 9, 2020 8am - 12pm',
                Icons.today),
            ListItem('Lorem ipsum dolor sit amet, consectetur adipiscing elit',
                '3 hrs ago', Icons.today),
            ListItem('Etiam ac lectus vel enim viverra venenatis.', '1 day ago',
                Icons.today),
            ListItem('Donec fermentum sit amet nibh et vehicula.', '2 days ago',
                Icons.today),
          ],
        ),
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final _title;
  final _subTitle;
  final _icon;

  const ListItem(this._title, this._subTitle, this._icon);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        _icon,
        size: 30.0,
      ),
      title: Text(
        _title,
        style: TextStyle(fontSize: 20.0),
      ),
      subtitle: Text(_subTitle),
      enabled: true,
      contentPadding: EdgeInsets.only(top: 10.0, left: 10, right: 10),
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => NewsDetail()));
      },
    );
  }
}

class TopHeader extends StatelessWidget {
  final _primaryColor;

  const TopHeader(this._primaryColor);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CustomShapeClipper(),
      child: Container(
        height: 200.0,
        decoration: BoxDecoration(color: _primaryColor),
      ),
    );
  }
}

class CustomShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    path.lineTo(0.0, 130.0);
    path.quadraticBezierTo(size.width / 2, 200, size.width, 130.0);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class ButtonIcon extends StatelessWidget {
  final Color materialColor;
  final Color iconColor;
  final Icon buttonIcon;
  final String buttonText;

  ButtonIcon(
      this.materialColor, this.iconColor, this.buttonIcon, this.buttonText);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Material(
          borderRadius: BorderRadius.circular(100.0),
          color: materialColor,
          child: IconButton(
            padding: EdgeInsets.all(15.0),
            icon: buttonIcon,
            iconSize: 30.0,
            color: iconColor,
            onPressed: () {},
          ),
        ),
        SizedBox(height: 8.0),
        Text(
          buttonText,
          style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
