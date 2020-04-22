import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:metro_info/provider/app_state.dart';
import 'package:metro_info/provider/bg_process.dart';
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
    Provider.of<BgProcess>(context, listen: false).init();
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
    return Scaffold(
      // backgroundColor: Color.fromRGBO(244, 244, 244, 1),
      appBar: AppBar(
        backgroundColor:
            Provider.of<AppState>(context, listen: false).themeColor,
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
                  Provider.of<AppState>(context, listen: false).lguName +
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
                color: Provider.of<AppState>(context, listen: false).themeColor,
              ),
              child: Text(
                "Hello! Welcome to metro-info",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                _launchURL('https://metro-info.herokuapp.com/about-lgu/' +
                    Slugify(
                        Provider.of<AppState>(context, listen: false).lguName));
              },
              child: ListTile(
                // leading: Icon(Icons.info),
                title: Text(
                  'About ' +
                      Provider.of<AppState>(context, listen: false).lguName,
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                _launchURL(
                    'https://www.websitepolicies.com/policies/view/IJZauoEt');
              },
              child: ListTile(
                // leading: Icon(Icons.insert_drive_file),
                title: Text(
                  'Terms of use',
                  style: TextStyle(fontSize: 20.0),
                ),
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
                TopHeader(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      child:
                          Provider.of<AppState>(context, listen: true).lguLogo,
                      padding:
                          EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                            Provider.of<AppState>(context, listen: false)
                                .lguName,
                            style:
                                TextStyle(color: Colors.white, fontSize: 25.0)),
                        Text(
                            Provider.of<AppState>(context, listen: false)
                                .regionShortName,
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
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          // Consumer<BgProcess>(
          //   builder:
          //       (BuildContext context, BgProcess bgProcess, Widget child) {
          //     return FloatingActionButton(
          //       backgroundColor: appState.themeColor,
          //       onPressed: () {
          //         bgProcess.getBcastMsg();
          //       },
          //       tooltip: 'Test',
          //       child: Icon(Icons.flash_on),
          //       foregroundColor: Colors.white,
          //     );
          //   },
          // ),
          // SizedBox(
          //   width: 10.0,
          // ),
          FloatingActionButton(
            backgroundColor:
                Provider.of<AppState>(context, listen: false).themeColor,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => SendMessage()));
            },
            tooltip: 'Send',
            child: Icon(Icons.message),
            foregroundColor: Colors.white,
          ),
        ],
      ),
    );
  }
}

class TopHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CustomShapeClipper(),
      child: Container(
        height: 200.0,
        decoration: BoxDecoration(
            color: Provider.of<AppState>(context, listen: false).themeColor),
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
