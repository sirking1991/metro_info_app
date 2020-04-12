import 'package:flutter/material.dart';
import 'package:metro_info/models/app_user.dart';
import 'package:metro_info/views/main.dart';
import 'package:metro_info/views/region_lgu_selector.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Future lguChecker() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs);
    print(prefs.getString("region_short_name"));

    // return prefs.getString('first_name');
    return prefs.getInt("lgu_id");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: lguChecker(),
      builder: (context, AsyncSnapshot snapshot) {
       
        if(snapshot.connectionState== ConnectionState.done){
          print(snapshot.data);
          return ChangeNotifierProvider(
          lazy: false,
          create: (context) => AppUser(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'metro-info',
            theme: ThemeData(
              primarySwatch: Colors.orange,
            ),
            home: snapshot.hasData? MyHomePage():RegionLGUSelector(isIntial: true),
          ),
        );
        }else{
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'metro-info',
            theme: ThemeData(
              primarySwatch: Colors.orange,
            ),
            home: Scaffold(              
              body:Center(
                child: CircularProgressIndicator(),
              )

            ),
          ) ;
        }
      
        
      },
    );
  }
}
