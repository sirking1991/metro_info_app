import 'package:flutter/material.dart';
import 'package:metro_info/networking/api_provider.dart';
import 'package:metro_info/models/app_user.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class SendMessage extends StatefulWidget {
  @override
  _SendMessageState createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {
  String _message;

  Message msg = Message();

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
              child: Form(
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
                    // Row(
                    //   children: <Widget>[
                    //     Icon(Icons.camera),
                    //     SizedBox(
                    //       width: 10.0,
                    //     ),
                    //     Text(
                    //       'Attach photo',
                    //       style: TextStyle(fontSize: 18.0),
                    //     )
                    //   ],
                    // ),
                    Consumer<AppUser>(builder: (context, appUser, child) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40.0),
                        child: RaisedButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (_) {
                                  return AlertDialog(
                                    content: Text("Send message?"),
                                    actions: <Widget>[
                                      FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        }, child: Text("No"),
                                      ),
                                      FlatButton(
                                        autofocus: true,
                                        onPressed: () {
                                          sendMessage(appUser);
                                          Navigator.of(context).pop();
                                        }, child: Text("Yes"),
                                      )
                                    ],
                                  );
                                });
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(Icons.send),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text('Send'),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  sendMessage(AppUser appUser) {
    msg.deviceId = appUser.deviceId;
    msg.lguId = appUser.lguId;
    msg.message = _message;

    var now = new DateTime.now();

    var key = utf8.encode('singlecord');
    final validationStr = now.day.toString() +
        "-" +
        appUser.lguId.toString() +
        "-" +
        appUser.deviceId;
    var bytes = utf8.encode(validationStr);

    var hmacSha256 = new Hmac(sha256, key); // HMAC-SHA256
    var digest = hmacSha256.convert(bytes);

    print("validationStr=$validationStr SHA256=" + digest.toString());

    msg.validationToken = digest.toString();

    print("message=" + _message);
    final ApiProvider _provider = ApiProvider();
    try {
      _provider.post("send_message", msg.toJson()).then((onValue) {});
    } catch (e) {
      print(e.toString());
    }
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
