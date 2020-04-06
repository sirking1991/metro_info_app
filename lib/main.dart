import 'package:flutter/material.dart';
import 'package:metro_info/views/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    print('MyApp build');

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'metro-info',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: MyHomePage(),
    );
  }

  checkSelectedLGU() async {
    String _lguId = '';

    // check if user already selected region/lgu
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      _lguId = prefs.getString('lgu_id');
    } catch (e) {
      print('error getting shared pref: ' + e.toString());
    }

    print('LGU selected: ' + _lguId);

  }
}

