import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taydukiapp/components/ImageCustom.dart';
import 'package:taydukiapp/dtos/UsersDTO.dart';
import 'package:taydukiapp/pages/KiepNanManagement.dart';
import 'package:taydukiapp/pages/LoginPage.dart';
import 'package:taydukiapp/pages/ProfileForm.dart';
import 'package:taydukiapp/pages/DaoCuManagement.dart';
import 'package:taydukiapp/pages/DienVienManagement.dart';
import 'package:taydukiapp/viewmodels/UsersViewModels.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.1,
        backgroundColor: Colors.red[900],
        title: Text('Tây Du Ký App'),
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
                                    new HomePage()),
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
                                    builder: (context) => new KiepNanPage()));
                          },
                          child: ListTile(
                            title: Text('Quản Lý Kiếp Nạn'),
                            leading: Icon(
                              Icons.book,
                              color: Colors.red[900],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DaoCuPage()));
                          },
                          child: ListTile(
                            title: Text('Quản Lý Đạo Cụ'),
                            leading: Icon(
                              Icons.category,
                              color: Colors.red[900],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DienVienPage()));
                          },
                          child: ListTile(
                            title: Text('Quản Lý Diễn Viên'),
                            leading: Icon(
                              Icons.people,
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
                        height: 200.0,
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
                                      builder: (context) => KiepNanPage()));
                            },
                            splashColor: Colors.black,
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Center(child: Icon(Icons.book, size: 50.0)),
                                  SizedBox(height: 15),
                                  Center(
                                      child: Text("Quản Lý Kiếp Nạn",
                                          style: TextStyle(fontSize: 17)))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        height: 300.0,
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
                                      builder: (context) => DaoCuPage()));
                            },
                            splashColor: Colors.black,
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Center(
                                      child: Icon(Icons.category, size: 50.0)),
                                  SizedBox(height: 15),
                                  Center(
                                      child: Text("Quản Lý Đạo Cụ",
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
                        height: 280.0,
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
                                      builder: (context) => DienVienPage()));
                            },
                            splashColor: Colors.black,
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Center(child: Icon(Icons.people, size: 50.0)),
                                  SizedBox(height: 15),
                                  Center(
                                      child: Text("Quản Lý Diễn Viên",
                                          style: TextStyle(fontSize: 17)))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        height: 220.0,
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
                              prefs.remove('UserInfo');
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
                                      child: Icon(Icons.exit_to_app,
                                          size: 50.0, color: Colors.white)),
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
