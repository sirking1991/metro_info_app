import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:metro_info/views/events_list.dart';
import 'package:metro_info/views/news_list.dart';
import 'package:metro_info/views/profile.dart';
import 'package:metro_info/views/send_message.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // TODO: These should be taken from SharedPreferences
  Color _primaryColor = Color.fromRGBO(255, 82, 48, 1);
  String _lguLogoPath =
      'https://upload.wikimedia.org/wikipedia/en/4/48/Ph_seal_ncr_pasay.png';
  String _regionName = '';
  String _lguName = '';

  @override
  void initState() {
    _getLGUDetails();
    super.initState();
  }

  _getLGUDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _lguName = prefs.getString("lgu_name");
      _regionName = prefs.getString("region_short_name");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _primaryColor,
        // leading: IconButton(
        //   icon: Icon(Icons.menu),
        //   color: Colors.white,
        //   iconSize: 30.0,
        //   onPressed: () {

        //       Navigator.of(context).push(MaterialPageRoute(
        //           builder: (BuildContext context) => RegionLGUSelector(isIntial: false,)));

        //     // TODO: Should display drawer with LGU pages

        //   },
        // ),
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
            NewsList(),
            EventsList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _primaryColor,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => SendMessage()));
        },
        tooltip: 'Send',
        child: Icon(Icons.message),
        foregroundColor: Colors.white,
      ),
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
