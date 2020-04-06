import 'package:flutter/material.dart';
import 'package:metro_info/models/app_user.dart';
import 'package:metro_info/views/main.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      lazy: false,
      create: (context) => AppUser(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'metro-info',
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        home: MyHomePage(),
      ),
    );
  }
}