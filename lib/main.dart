import 'package:flutter/material.dart';
import 'package:metro_info/networking/api_provider.dart';
import 'package:metro_info/provider/app_state.dart';
import 'package:metro_info/views/main.dart';
import 'package:metro_info/views/region_lgu_selector.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:async';
import 'package:background_fetch/background_fetch.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

NotificationAppLaunchDetails notificationAppLaunchDetails;    

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });
}

/// This "Headless Task" is run when app is terminated.
void backgroundFetchHeadlessTask(String taskId) async {
  print('[BackgroundFetch] Headless event received.');
  BackgroundFetch.finish(taskId);
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  AppState appState = AppState();
  appState.init();
  runApp(ChangeNotifierProvider(
    child: MyApp(),
    create: (context) => appState,
  ));

  // Register to receive BackgroundFetch events after app is terminated.
  // Requires {stopOnTerminate: false, enableHeadless: true}
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);  
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _enabled = true;
  int _status = 0;
  List<DateTime> _events = [];

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

// Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Configure BackgroundFetch.
    BackgroundFetch.configure(BackgroundFetchConfig(
        minimumFetchInterval: 15,
        stopOnTerminate: false,
        enableHeadless: true,
        requiresBatteryNotLow: true,
        requiresCharging: false,
        requiresStorageNotLow: false,
        requiresDeviceIdle: false,
        requiredNetworkType: NetworkType.ANY
    ), (String taskId) async {
      // This is the fetch-event callback.
      print("[BackgroundFetch] Event received $taskId");
      // TODO: get broadcast message here



      // ApiProvider().get('bcastmsg/' + Provider.of<AppState>(context, listen: false).lguId.toString())
      //   .then((res){
      //     print(res.toString());
      //   })
      //   .catchError((error){
      //     print(error);
      //   });
      // setState(() {
      //   _events.insert(0, new DateTime.now());
      // });
      // IMPORTANT:  You must signal completion of your task or the OS can punish your app
      // for taking too long in the background.
      BackgroundFetch.finish(taskId);
    }).then((int status) {
      print('[BackgroundFetch] configure success: $status');
      // setState(() {
      //   _status = status;
      // });
    }).catchError((e) {
      print('[BackgroundFetch] configure ERROR: $e');
      // setState(() {
      //   _status = e;
      // });
    });

    // Optionally query the current BackgroundFetch status.
    int status = await BackgroundFetch.status;
    // setState(() {
    //   _status = status;
    // });

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    // if (!mounted) return;
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
              primarySwatch: Provider.of<AppState>(context, listen: false).themeColor,
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
              primarySwatch: Provider.of<AppState>(context, listen: false).themeColor,
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
