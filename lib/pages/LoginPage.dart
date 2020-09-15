import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taydukiapp/dtos/AuthDTO.dart';
import 'package:taydukiapp/pages/HomeAdmin.dart';
import 'package:taydukiapp/pages/HomeDienVien.dart';
import 'package:taydukiapp/components/Loading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taydukiapp/viewmodels/UsersViewModels.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();

  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
//    final user = Provider.of<UserProvider>(context);
    return Scaffold(
      key: _key,
      body: isLoading
          ? Loading()
          : ScopedModel(
              model: UsersViewModel(),
              child: ScopedModelDescendant<UsersViewModel>(builder:
                  (BuildContext buildContext, Widget child,
                      UsersViewModel model) {
                return Container(
                  padding: const EdgeInsets.all(0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red[900],
                    ),
                    child: Form(
                        key: _formKey,
                        child: ListView(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Image.asset(
                                  "assets/4thaytro.png",
                                  width: 250.0,
                                ),
                                Text(
                                  "TÂY DU KÝ",
                                  style: GoogleFonts.zcoolKuaiLe(
                                    textStyle: TextStyle(
                                        color: Colors.white,
                                        letterSpacing: 5,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 56),
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  14.0, 50.0, 14.0, 8.0),
                              child: Material(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.grey.withOpacity(0.2),
                                elevation: 0.0,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: new Border.all(
                                        color: Colors.black54,
                                      ),
                                      borderRadius:
                                          new BorderRadius.circular(12.0)),
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: TextFormField(
                                    controller: _username,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Tên đăng nhập",
                                      icon: Icon(Icons.person),
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Tên đăng nhập không được để trống";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  14.0, 8.0, 14.0, 8.0),
                              child: Material(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.grey.withOpacity(0.2),
                                elevation: 0.0,
                                child: Container(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: new Border.all(
                                        color: Colors.black54,
                                      ),
                                      borderRadius:
                                          new BorderRadius.circular(12.0)),
                                  child: TextFormField(
                                    obscureText: true,
                                    controller: _password,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Mật khẩu",
                                      icon: Icon(Icons.lock_outline),
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Mật khẩu không được để trống";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Container(
                                height: 64,
                                padding: const EdgeInsets.fromLTRB(
                                    14.0, 8.0, 14.0, 8.0),
                                child: FlatButton(
                                  color: Colors.red[900],
                                  onPressed: () async {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    var userInfo = await model.login(
                                        _username.text, _password.text);
                                    if (userInfo != null) {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.setString("UserInfo", userInfo);
                                      print("UserInfo: $userInfo");
                                      AuthDTO authDTO = AuthDTO.fromJson(
                                          json.decode(userInfo));
                                      if (authDTO.role == "Admin") {
                                        await Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    new HomePage()),
                                            (router) => false);
                                      } else {
                                        await Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    new HomeDienVienPage()),

                                                (router) => false);
                                      }
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: "Tên đăng nhập hoặc mật khẩu không đúng!");
                                    }
                                    _password.text = "";
                                    setState(() {
                                      isLoading = false;
                                    });
                                  },
                                  child: Text(
                                    "Đăng Nhập",
                                    style: TextStyle(
                                        fontSize: 21.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.white)),
                                )),
                          ],
                        )),
                  ),
                );
              }),
            ),
    );
  }
}
