import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taydukiapp/dtos/AuthDTO.dart';
import 'package:taydukiapp/pages/HomeAdmin.dart';
import 'package:taydukiapp/pages/HomeDienVien.dart';
import 'package:taydukiapp/pages/LoginPage.dart';

const debug = true;

Future<void> main() async {
  await FlutterDownloader.initialize(debug: debug);
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var data = preferences.getString("UserInfo");
  if (data != null) {
    AuthDTO authDTO = AuthDTO.fromJson(json.decode(data));
    runApp(MaterialApp(
      home: authDTO.role == "Admin" ? HomePage() : HomeDienVienPage(),
      debugShowCheckedModeBanner: false,
    ));
  } else {
    runApp(MaterialApp(
      home: Login(),
      debugShowCheckedModeBanner: false,
    ));
  }
}
class MessageHandler extends StatefulWidget {
  @override
  _MessageHandlerState createState() => _MessageHandlerState();
}

class _MessageHandlerState extends State<MessageHandler> {
  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  @override
  void initState() {

    // ...

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // TODO optional
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // TODO optional
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
