import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:metro_info/networking/api_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// This "Headless Task" is run when app is terminated.
void backgroundFetchHeadlessTask(String taskId) async {
  print('[BackgroundFetch] Headless event received.');
  BackgroundFetch.finish(taskId);
}

class BgProcess extends ChangeNotifier {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  init() async {
    print("BgProcess.init()");
    initPlatformState();
    initLocalNotification();

    // Register to receive BackgroundFetch events after app is terminated.
    // Requires {stopOnTerminate: false, enableHeadless: true}
    BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
  }

  initLocalNotification() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid = AndroidInitializationSettings('milogo_sml');
    var initializationSettingsIOS = IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
  }

  Future selectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
  }

  sendNotification(String title, String body) async {
    print('sending notification: ' + body);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your-channel-id', 'your-channel-name', 'your-channel-description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: 'item x');
  }

  getBcastMsg() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var _lguId = _pref.getInt('lgu_id');

    ApiProvider().get('bcastmsg/' + _lguId.toString()).then((res) {
      var bcastMsg = BroadcastMessage.getMap(res);
      bcastMsg.forEach((msg) {
        if (null == _pref.getBool('bcastmsg_' + msg.id.toString())) {
          //var lguName = Provider.of<AppState>(context, listen: false).lguName;
          sendNotification('METRO-INFO', msg.message);
          // set so we dont notify for same message
          _pref.setBool('bcastmsg_' + msg.id.toString(), true);
        }
      });
    }).catchError((error) {
      print(error);
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Configure BackgroundFetch.
    BackgroundFetch.configure(
        BackgroundFetchConfig(
            minimumFetchInterval: 15,
            stopOnTerminate: false,
            enableHeadless: true,
            requiresBatteryNotLow: true,
            requiresCharging: false,
            requiresStorageNotLow: false,
            requiresDeviceIdle: false,
            requiredNetworkType: NetworkType.ANY), (String taskId) async {
      // This is the fetch-event callback.
      print("[BackgroundFetch] Event received $taskId");

      getBcastMsg();

      // IMPORTANT:  You must signal completion of your task or the OS can punish your app
      // for taking too long in the background.
      BackgroundFetch.finish(taskId);
    }).then((int status) {
      print('[BackgroundFetch] configure success: $status');
    }).catchError((e) {
      print('[BackgroundFetch] configure ERROR: $e');
    });

    // Optionally query the current BackgroundFetch status.
    await BackgroundFetch.status;
  }
}

class BroadcastMessage {
  int id;
  int lguId;
  int postedBy;
  String broadcastOn;
  String broadcastVia;
  String message;
  String status;
  String createdAt;
  String updatedAt;

  BroadcastMessage(
      {this.id,
      this.lguId,
      this.postedBy,
      this.broadcastOn,
      this.broadcastVia,
      this.message,
      this.status,
      this.createdAt,
      this.updatedAt});

  BroadcastMessage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    lguId = json['lgu_id'];
    postedBy = json['posted_by'];
    broadcastOn = json['broadcast_on'];
    broadcastVia = json['broadcast_via'];
    message = json['message'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['lgu_id'] = this.lguId;
    data['posted_by'] = this.postedBy;
    data['broadcast_on'] = this.broadcastOn;
    data['broadcast_via'] = this.broadcastVia;
    data['message'] = this.message;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }

  static List<BroadcastMessage> getMap(List data) {
    List<BroadcastMessage> datatemp = [];
    data.forEach((item) {
      datatemp.add(BroadcastMessage(
          id: item['id'],
          lguId: item['lgu_id'],
          postedBy: item['posted_by'],
          broadcastOn: item['bbroadcast_on'],
          broadcastVia: item['broadcast_via'],
          message: item['message'],
          status: item['status'],
          createdAt: item['broadcast'],
          updatedAt: item['updated_at']));
    });
    return datatemp;
  }
}
