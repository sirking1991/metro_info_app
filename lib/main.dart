import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:metro_info/provider/app_state.dart';
import 'package:metro_info/provider/bg_process.dart';
import 'package:metro_info/views/main.dart';
import 'package:metro_info/views/region_lgu_selector.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:async';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          BgProcess bgProcess = BgProcess();
          bgProcess.init();
          return bgProcess;
        }),
        ChangeNotifierProvider(create: (context) {
              AppState appState = AppState();
              appState.init();
              return appState;
            }),
      ],
      child: MyApp(),
    ),
  );

}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  Future lguChecker() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt("lgu_id");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: lguChecker(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'metro-info',
            theme: ThemeData(
              primarySwatch:
                  Provider.of<AppState>(context, listen: false).themeColor,
            ),
            home: snapshot.hasData
                ? MyHomePage()
                : RegionLGUSelector(isIntial: true),
          );
        } else {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'metro-info',
            theme: ThemeData(
              primarySwatch:
                  Provider.of<AppState>(context, listen: false).themeColor,
            ),
            home: Scaffold(
                body: Center(
              child: CircularProgressIndicator(),
            )),
          );
        }
      },
    );
  }
}
