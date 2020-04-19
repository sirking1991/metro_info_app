import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:metro_info/provider/app_state.dart';
import 'package:metro_info/views/events_list.dart';
import 'package:metro_info/views/news_list.dart';
import 'package:metro_info/views/profile.dart';
import 'package:metro_info/views/send_message.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:slugify/slugify.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (BuildContext context, AppState appState, Widget child) {
        return Scaffold(
          // backgroundColor: Color.fromRGBO(244, 244, 244, 1),
          appBar: AppBar(
            backgroundColor: appState.themeColor,
            title: Text(
              'metro-info',
              style: TextStyle(fontSize: 30.0, color: Colors.white),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.share),
                color: Colors.white,
                iconSize: 30.0,
                onPressed: () {
                  Share.share('Hey! check out this ' +
                      appState.lguName +
                      ' app. https://metro-info.herokuapp.com/download-app');
                },
              ),
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
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: appState.themeColor,
                  ),
                  child: Text(
                    "Hi " + appState.pref.getString('first_name') + "!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    _launchURL('https://metro-info.herokuapp.com/about-lgu/' + Slugify(appState.lguName) );
                  },
                                  child: ListTile(
                    leading: Icon(Icons.info),
                    title: Text('About ' + appState.lguName),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _launchURL('https://www.websitepolicies.com/policies/view/IJZauoEt');
                  },
                  child: ListTile(
                    leading: Icon(Icons.insert_drive_file),
                    title: Text('Terms of use'),
                  ),
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    TopHeader(appState),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          child: appState.lguLogo,
                          padding: EdgeInsets.only(
                              left: 10.0, right: 10.0, top: 10.0),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(appState.lguName,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25.0)),
                            Text(appState.regionShortName,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15.0)),
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
            backgroundColor: appState.themeColor,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => SendMessage()));
            },
            tooltip: 'Send',
            child: Icon(Icons.message),
            foregroundColor: Colors.white,
          ),
        );
      },
    );
  }
}

class TopHeader extends StatelessWidget {
  final AppState appState;

  TopHeader(this.appState);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CustomShapeClipper(),
      child: Container(
        height: 200.0,
        decoration: BoxDecoration(color: appState.themeColor),
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
