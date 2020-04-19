import 'package:flutter/material.dart';
import 'package:metro_info/networking/api_provider.dart';
import 'package:metro_info/provider/app_state.dart';
import 'package:metro_info/views/profile.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SendMessage extends StatefulWidget {
  @override
  _SendMessageState createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {
  String _message;

  Message msg = Message();

  bool _processing = false;

  @override
  void initState() {
    _checkAppUserRegistration();

    super.initState();
  }

  _checkAppUserRegistration() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    if (null == pref.getString("device_id")) {
      Alert(
          title: "Update your profile to send messages to LGU",
          context: context,
          buttons: [
            DialogButton(
              color: Provider.of<AppState>(context, listen: false).themeColor,
              child: Text("Okay"),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Profile()),
                );
              },
            )
          ]).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // BEGIN: navbar
            Container(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.only(top: 30.0, right: 15.0, left: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      color: Colors.black45,
                      iconSize: 30.0,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            ),
            // END: navbar

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 30.0),
              child: Text(
                'Send Message',
                style: TextStyle(
                    color: Colors.black.withOpacity(0.7),
                    fontWeight: FontWeight.bold,
                    fontSize: 32.0),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Your message'),
                        TextField(
                          maxLines: 3,
                          maxLength: 256,
                          onChanged: (String v) {
                            _message = v;
                          },
                        ),
                      ]),
                  SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40.0),
                    child: _processing
                        ? Center(child: CircularProgressIndicator())
                        : DialogButton(
                            color: Provider.of<AppState>(context, listen: false)
                                .themeColor,
                            onPressed: () {
                              Alert(
                                      style: AlertStyle(isCloseButton: false),
                                      buttons: [
                                        DialogButton(
                                          color: Colors.red,
                                          child: Text(
                                            "No",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                        DialogButton(
                                          color: Colors.green,
                                          child: Text(
                                            "Yes",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            sendMessage();
                                          },
                                        ),
                                      ],
                                      context: context,
                                      title: "Send message?")
                                  .show();
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Icon(
                                  Icons.send,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  'Send',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  sendMessage() async {
    setState(() => _processing = true);

    SharedPreferences pref = await SharedPreferences.getInstance();

    msg.deviceId = pref.getString("device_id");
    msg.lguId = pref.getInt("lgu_id");
    msg.message = _message;

    var now = new DateTime.now();

    var key = utf8.encode('singlecord');
    final validationStr =
        now.day.toString() + "-" + msg.lguId.toString() + "-" + msg.deviceId;

    var bytes = utf8.encode(validationStr);
    var hmacSha256 = new Hmac(sha256, key); // HMAC-SHA256
    var digest = hmacSha256.convert(bytes);

    msg.validationToken = digest.toString();

    FocusScope.of(context).requestFocus(FocusNode()); // hides keyboard

    ApiProvider().post("send_message", msg.toJson()).then((response) {
      setState(() => _processing = false);
      Alert(
          context: context,
          title: "Message sent",
          type: AlertType.success,
          buttons: [
            DialogButton(
              color: Provider.of<AppState>(context, listen: false).themeColor,
              child: Text(
                "Okay",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            )
          ]).show();
    }).catchError((error) {
      setState(() => _processing = false);
      Alert(
          context: context,
          title: "Error",
          desc: "An error occured while sending your message. Try again later.",
          type: AlertType.error,
          buttons: [
            DialogButton(
              color: Provider.of<AppState>(context, listen: false).themeColor,
              child: Text(
                "Okay",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ]).show();
    });
  }
}

class Message {
  String validationToken;
  int lguId;
  String deviceId;
  String message;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['validation_token'] = this.validationToken;
    data['device_id'] = this.deviceId;
    data['message'] = this.message;
    return data;
  }
}
