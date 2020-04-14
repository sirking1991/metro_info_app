import 'package:flutter/material.dart';
import 'package:metro_info/provider/app_state.dart';
import 'package:metro_info/views/main.dart';
import 'package:metro_info/views/region_lgu_selector.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  AppState appState = AppState();
  appState.init();
  runApp(ChangeNotifierProvider(
    child: MyApp(),
    create: (context) => appState,
  ));
}

class MyApp extends StatelessWidget {
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
              primarySwatch: Colors.orange,
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
              primarySwatch: Colors.orange,
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
