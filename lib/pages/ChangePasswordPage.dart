import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:taydukiapp/components/ImageCustom.dart';
import 'package:taydukiapp/components/SpinKit.dart';
import 'package:taydukiapp/dtos/UsersDTO.dart';
import 'package:taydukiapp/viewmodels/UsersViewModels.dart';

class ChangePasswordForm extends StatefulWidget {
  UsersDTO user;

  ChangePasswordForm({this.user});

  @override
  _ChangePasswordFormState createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  TextEditingController _password = TextEditingController();
  TextEditingController _newPassword = TextEditingController();
  TextEditingController _confirmPassword = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ProgressDialog pr;


  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);

    pr.style(
      message: "Vui lòng đợi sau giây lát ...",
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      elevation: 10.0,
      messageTextStyle: TextStyle(color: Colors.black, fontSize: 15.0),
    );
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.1,
        backgroundColor: Colors.red[900],
        title: InkWell(
            onTap: () {
//              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: Text('Thay đổi mật khẩu')),
      ),
      body: Container(
        color: Colors.grey[200],
        child: Form(
          key: _formKey,
          child:  ListView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                      child: Text("Mật khẩu hiện tại: "),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                        elevation: 0.0,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12.0, right:5.0),
                          child: TextFormField(
                            obscureText: true,
                            controller: _password,
                            maxLength: 100,
                            decoration: InputDecoration(
                                hintText: "Mật khẩu hiện tại",
                                icon: Icon(Icons.lock_outline),
                                border: InputBorder.none),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Mật khẩu hiện tại không được để trống!";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                      child: Text("Mật khẩu mới: "),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                        elevation: 0.0,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12.0, right:5.0),
                          child: TextFormField(
                            obscureText: true,
                            controller: _newPassword,
                            maxLength: 100,
                            decoration: InputDecoration(
                                hintText: "Mật khẩu mới",
                                icon: Icon(Icons.lock),
                                border: InputBorder.none),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Mật khẩu mới không được để trống!";
                              } else {}
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                      child: Text("Xác nhận mật khẩu: "),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                        elevation: 0.0,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12.0, right:5.0),
                          child: TextFormField(
                            obscureText: true,
                            controller: _confirmPassword,
                            maxLength: 100,
                            decoration: InputDecoration(
                                hintText: "Xác nhận mật khẩu",
                                icon: Icon(Icons.info),
                                border: InputBorder.none),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Phần xác nhận mật khẩu không được để trống!";
                              } else if (value != _newPassword.text) {
                                return "Phần xác nhận mật khẩu không khớp!";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(15),
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            side: BorderSide(color: Colors.grey[100])),
                        height: 50,
                        onPressed: () async {
                          await pr.show();
                          await submit();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                            Text(
                              "Đổi mật khẩu",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                        color: Colors.red[900],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Future<bool> checkPassword() async {
    UsersViewModel model = UsersViewModel();
    var data = await model.login(widget.user.username, _password.text);
    if (data != null) {
      return true;
    }
    return false;
  }

  Future<void> submit() async {
    if (_formKey.currentState.validate()) {
      bool isCheck = await checkPassword();
      if (isCheck) {
        if (_password.text == _newPassword.text) {
          Fluttertoast.showToast(
              msg: "Mật khẩu mới không được trùng với mật khẩu cũ");
        } else {
          UsersDTO dto = UsersDTO(username: widget.user.username,password: _newPassword.text);
          UsersViewModel model = UsersViewModel();
          var data = await model.updateUser(dto);
          if (data != null) {
            await pr.hide();
            Navigator.pop(context, true);
          }
        }
      } else{
        Fluttertoast.showToast(
            msg: "Mật khẩu hiện tại không đúng");
      }
    }
    clearPassword();
    await pr.hide();
  }

  void clearPassword() {
    _password.text = "";
    _newPassword.text = "";
    _confirmPassword.text = "";
  }
}
