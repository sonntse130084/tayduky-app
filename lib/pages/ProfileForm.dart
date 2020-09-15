import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:taydukiapp/components/ImageCustom.dart';
import 'package:taydukiapp/components/SpinKit.dart';
import 'package:taydukiapp/components/Loading.dart';
import 'package:taydukiapp/constants/Contants.dart';
import 'package:taydukiapp/dtos/UsersDTO.dart';
import 'package:taydukiapp/pages/ChangePasswordPage.dart';

class ProfileForm extends StatefulWidget {
  UsersDTO user;

  ProfileForm({this.user});

  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  TextEditingController _username = TextEditingController();
  TextEditingController _ten = TextEditingController();
  TextEditingController _moTa = TextEditingController();
  TextEditingController _soDienThoai = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _diaChi = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  ProgressDialog pr;
  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile.path);
    });
  }

  Widget _displayChild1() {
    if (_image == null &&
        (widget.user == null || widget.user.hinhAnh.isEmpty)) {
      return OutlineButton(
        borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 2.5),
        onPressed: () {
          getImage();
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 50, 14, 50),
          child: new Icon(
            Icons.add,
            color: Colors.grey,
            size: 65,
          ),
        ),
      );
    } else {
      if (_image != null) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: Image.file(
                _image,
                fit: BoxFit.fill,
                width: double.infinity,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            MaterialButton(
              onPressed: () {
                getImage();
              },
              child: Text(
                "Thay đổi",
                style: TextStyle(fontSize: 16),
              ),
              color: Colors.white,
            ),
          ],
        );
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Expanded(
              child: ImageCustom(
            image: widget.user.hinhAnh,
          )),
          SizedBox(
            width: 10,
          ),
          MaterialButton(
            onPressed: () {
              getImage();
            },
            child: Text(
              "Thay đổi",
              style: TextStyle(fontSize: 16),
            ),
            color: Colors.white,
          ),
        ],
      );
    }
  }

  @override
  void initState() {
    if (widget.user != null) {
      _username.text = widget.user.username;
      _ten.text = widget.user.ten;
      _soDienThoai.text = "${widget.user.soDienThoai}";
      _email.text = widget.user.email;
      _moTa.text = widget.user.moTa;
      _diaChi.text = widget.user.diaChi;
    }
  }

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
            child: Text('My Profile')),
      ),
      body: Container(
        color: Colors.grey[200],
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                  child: Text("Hình ảnh"),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                  child: Center(
                    child: Container(
                      child: _displayChild1(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                  child: Text("Username: "),
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
                        enabled: false,
                        controller: _username,
                        maxLength: 100,
                        decoration: InputDecoration(
                            hintText: "Tên đăng nhập",
                            icon: Icon(Icons.lock_outline),
                            border: InputBorder.none),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Tên đăng nhập không được để trống!";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                  child: Text("Mật khẩu: "),
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                      ),
                      child: ListTile(
                        onTap: () async {
                          var result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChangePasswordForm(
                                        user: widget.user,
                                      )));
                          if (result == true) {
                            Fluttertoast.showToast(
                                msg: "Thay đổi mật khẩu thành công");
                          }
                        },
                        title: Text(
                          "Click here to change password",
                          style: TextStyle(
                              color: Colors.red[900],
                              fontWeight: FontWeight.bold),
                        ),
                        trailing: Icon(
                          Icons.navigate_next,
                          color: Colors.red[900],
                        ),
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                  child: Text("Tên Diễn Viên: "),
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
                        controller: _ten,
                        maxLength: 100,
                        decoration: InputDecoration(
                            hintText: "Tên Diễn Viên",
                            icon: Icon(Icons.person_outline),
                            border: InputBorder.none),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Tên diễn viên không được để trống!";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                  child: Text("Số Điện Thoại"),
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
                        controller: _soDienThoai,
                        maxLength: 11,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter.digitsOnly
                        ],
                        // Only numbers can be entered
                        decoration: InputDecoration(
                            hintText: "Số Điện Thoại",
                            icon: Icon(Icons.confirmation_number),
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                  child: Text("Email"),
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
                        controller: _email,
                        maxLength: 450,
                        decoration: InputDecoration(
                            hintText: "Email",
                            icon: Icon(Icons.info),
                            border: InputBorder.none),
                          validator: (value) {
                            if(value.isNotEmpty){
                              RegExp exp = new RegExp(Constants.REGEX_EMAIL);
                              if (!exp.hasMatch(value)) {
                                return "Vui lòng nhập đúng email!";
                              }
                            }
                            return null;
                          },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                  child: Text("Địa chỉ:"),
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
                        controller: _diaChi,
                        maxLength: 450,
                        decoration: InputDecoration(
                            hintText: "Địa chỉ",
                            icon: Icon(Icons.info),
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                  child: Text("Mô Tả"),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 2.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                    elevation: 0.0,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0, right:5.0),
                      child: TextFormField(
                        maxLines: 5,
                        controller: _moTa,
                        maxLength: 500,
                        decoration: InputDecoration(
                            hintText: "Mô Tả",
                            icon: Icon(Icons.description),
                            border: InputBorder.none),
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
                      String img = await upLoadImage();
                      if (img != null && img.isNotEmpty) {
                        await update(img);
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        Text(
                          "Cập nhật",
                          style: TextStyle(color: Colors.white, fontSize: 16),
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
      ),
    );
  }

  Future<String> upLoadImage() async {
    if (_image != null) {
      if (_formKey.currentState.validate()) {
        String imageUrl;

        final FirebaseStorage storage = FirebaseStorage.instance;
        final String pictureName =
            "images/user/username_${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
        StorageUploadTask task1 =
            storage.ref().child(pictureName).putFile(_image);

        StorageTaskSnapshot snapshot1 =
            await task1.onComplete.then((snapshot) => snapshot);
        imageUrl = await snapshot1.ref.getDownloadURL();
        return imageUrl;
      }
      await pr.hide();
    } else {
      if (widget.user != null) {
        if (widget.user.hinhAnh != null) {
          return widget.user.hinhAnh;
        }
      }
      await pr.hide();
      Fluttertoast.showToast(msg: 'Hình ảnh phải được cung cấp');
    }
  }

  Future<void> update(String imgUrl) async {
    if (_formKey.currentState.validate()) {
      UsersDTO dto = UsersDTO(
          username: widget.user.username,
          ten: _ten.text,
          moTa: _moTa.text,
          hinhAnh: imgUrl,
          soDienThoai: _soDienThoai.text,
          email: _email.text,
          diaChi: _diaChi.text,
          implementer: widget.user.username);
      await pr.hide();
      Navigator.pop(context, dto);
    }
    await pr.hide();
  }
}
