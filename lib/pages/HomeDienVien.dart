import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taydukiapp/components/ImageCustom.dart';
import 'package:taydukiapp/dtos/AuthDTO.dart';
import 'package:taydukiapp/dtos/UsersDTO.dart';
import 'package:taydukiapp/pages/DienVienProfilePage.dart';
import 'package:taydukiapp/pages/LichDien.dart';
import 'package:taydukiapp/pages/LichSu.dart';
import 'package:taydukiapp/pages/LoginPage.dart';
import 'package:taydukiapp/pages/ProfileForm.dart';
import 'package:taydukiapp/viewmodels/UsersViewModels.dart';

class HomeDienVienPage extends StatefulWidget {
  @override
  _HomeDienVienPageState createState() => _HomeDienVienPageState();
}

class _HomeDienVienPageState extends State<HomeDienVienPage> {
  String _message = '';

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

//  _register() {
//    _firebaseMessaging.getToken().then((token) => print("FCM token: $token"));
//  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMessage();
  }

  void getMessage() {
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
      setState(() => _message = message["notification"]["title"]);
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
    }, onResume: (Map<String, dynamic> message) async {
      print('on resume $message');
      setState(() => _message = message["notification"]["title"]);
    }, onLaunch: (Map<String, dynamic> message) async {
      print('on launch $message');
      setState(() => _message = message["notification"]["title"]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.1,
        backgroundColor: Colors.red[900],
        title: Text('Tây Du Ký'),
      ),
      drawer: Drawer(
        child: ScopedModel(
          model: UsersViewModel(),
          child: ScopedModelDescendant<UsersViewModel>(builder:
              (BuildContext buildContext2, Widget child,
                  UsersViewModel usersViewModel) {
            return FutureBuilder<UsersDTO>(
                future: usersViewModel.getUsersSession(),
                builder: (context, AsyncSnapshot<UsersDTO> snapshot) {
                  if (snapshot.hasData) {
                    _firebaseMessaging.subscribeToTopic(snapshot.data.username);
                    return ListView(
                      children: <Widget>[
                        // header
                        new UserAccountsDrawerHeader(
                          accountName: snapshot.data == null
                              ? Text("")
                              : Text(snapshot.data.ten),
                          accountEmail: Row(
                            children: <Widget>[
                              snapshot.data == null
                                  ? Text("")
                                  : Text(snapshot.data.email),
                              IconButton(
                                onPressed: () async {
                                  dynamic result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProfileForm(
                                                user: snapshot.data,
                                              )));
                                  if (result != null) {
                                    bool flg =
                                        await usersViewModel.updateUser(result);
                                    if (flg) {
                                      Fluttertoast.showToast(
                                          msg: "Cập nhật diễn viên thành công");
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: "Cập nhật diễn viên thất bại");
                                    }
                                  }
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                          currentAccountPicture: GestureDetector(
                            child: CircleAvatar(
                              radius: 80,
                              backgroundColor: Colors.grey[200],
                              backgroundImage:
                                  snapshot.data.hinhAnh.contains("assets/")
                                      ? AssetImage(
                                          snapshot.data.hinhAnh,
                                        )
                                      : NetworkImage(
                                          snapshot.data.hinhAnh,
                                        ),
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red[900],
                          ),
                        ),
                        // body
                        InkWell(
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        new HomeDienVienPage()),
                                (router) => false);
                          },
                          child: ListTile(
                            title: Text('Trang chủ'),
                            leading: Icon(
                              Icons.dashboard,
                              color: Colors.red[900],
                            ),
                          ),
                        ),
                        Divider(),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => new LichDienPage()));
                          },
                          child: ListTile(
                            title: Text('Lịch Diễn'),
                            leading: Icon(
                              Icons.calendar_today,
                              color: Colors.red[900],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => new LichSuPage()));
                          },
                          child: ListTile(
                            title: Text('Lịch Sử'),
                            leading: Icon(
                              Icons.history,
                              color: Colors.red[900],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.remove('UserInfo');
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()));
                          },
                          child: ListTile(
                            title: Text('Đăng Xuất'),
                            leading: Icon(
                              Icons.exit_to_app,
                              color: Colors.red[900],
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                });
          }),
        ),
      ),
      body: Container(
        color: Colors.grey[200],
        child: Column(
          children: <Widget>[
            const SizedBox(height: 30.0),
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 250.0,
                        child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side:
                                  BorderSide(color: Colors.red[900], width: 2)),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          new LichDienPage()));
                            },
                            splashColor: Colors.black,
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Center(
                                      child: Icon(Icons.calendar_today,
                                          size: 50.0)),
                                  SizedBox(height: 15),
                                  Center(
                                      child: Text("Lịch Diễn Sắp Tới",
                                          style: TextStyle(fontSize: 17)))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        height: 250.0,
                        child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side:
                                  BorderSide(color: Colors.red[900], width: 2)),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => new LichSuPage()));
                            },
                            splashColor: Colors.black,
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Center(
                                      child: Icon(Icons.history, size: 50.0)),
                                  SizedBox(height: 15),
                                  Center(
                                      child: Text("Lịch Sử",
                                          style: TextStyle(fontSize: 17)))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 3.0,
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 340.0,
                        child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side:
                                  BorderSide(color: Colors.red[900], width: 2)),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProfilePage()));
                            },
                            splashColor: Colors.black,
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Center(child: Icon(Icons.person, size: 50.0)),
                                  SizedBox(height: 15),
                                  Center(
                                      child: Text("Thông Tin",
                                          style: TextStyle(fontSize: 17)))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        height: 160.0,
                        child: Card(
                          color: Colors.red[900],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side:
                                  BorderSide(color: Colors.red[900], width: 2)),
                          child: InkWell(
                            onTap: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              AuthDTO authDTO = AuthDTO.fromJson(json.decode(prefs.getString("UserInfo")));
                              prefs.remove('UserInfo');
                              _firebaseMessaging.unsubscribeFromTopic(authDTO.username);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Login()));
                            },
                            splashColor: Colors.black,
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Center(
                                      child: Icon(
                                    Icons.exit_to_app,
                                    size: 50.0,
                                    color: Colors.white,
                                  )),
                                  SizedBox(height: 15),
                                  Center(
                                      child: Text("Đăng Xuất",
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.white)))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
