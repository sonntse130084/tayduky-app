import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taydukiapp/components/ImageCustom.dart';
import 'package:taydukiapp/dtos/AuthDTO.dart';
import 'package:taydukiapp/dtos/DaoCuDTO.dart';

class DaoCuForm extends StatefulWidget {
  final action;
  DaoCuDTO daocu;

  DaoCuForm({this.action, this.daocu});

  @override
  _DaoCuFormState createState() => _DaoCuFormState();
}

class _DaoCuFormState extends State<DaoCuForm> {
  TextEditingController _daocuId = TextEditingController();
  TextEditingController _ten = TextEditingController();
  TextEditingController _dacTa = TextEditingController();
  TextEditingController _hinhAnh = TextEditingController();
  TextEditingController _trangThai = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
        (widget.daocu == null || widget.daocu.hinhAnh.isEmpty)) {
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
      if (widget.action == "Update" && _image != null) {
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
      return (widget.daocu != null && widget.daocu.hinhAnh != "")
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Expanded(
                    child: ImageCustom(
                  image: widget.daocu.hinhAnh,
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
            )
          : Row(
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
  }

  @override
  void initState() {
    if (widget.daocu != null) {
      _ten.text = widget.daocu.ten;
      _trangThai.text = widget.daocu.trangThai;
      _dacTa.text = widget.daocu.dacTa;
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
        title: Text('Đạo Cụ Form'),
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
                    child: Text("Hình ảnh:"),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                    child: Center(
                      child: Container(child: _displayChild1()),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                    child: Text("Tên Đạo Cụ: "),
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
                          maxLength: 50,
                          decoration: InputDecoration(
                              hintText: "Tên Đạo Cụ",
                              icon: Icon(Icons.person_outline),
                              border: InputBorder.none),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Tên đạo cụ không được để trống!";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                    child: Text("Trạng thái"),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                    child: Material(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                      elevation: 0.0,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12.0, right:5.0),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          items: <String>['Mới', 'Cũ'].map((String value) {
                            return new DropdownMenuItem<String>(
                              value: value,
                              child: new Text(value),
                            );
                          }).toList(),
                          value: _trangThai.text.isEmpty
                              ? "Mới"
                              : _trangThai.text,
                          onChanged: (value) {
                            setState(() {
                              _trangThai.text = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                    child: Text("Đặc Tả"),
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
                          maxLength: 500,
                          controller: _dacTa,
                          decoration: InputDecoration(
                              hintText: "Đặc Tả",
                              icon: Icon(Icons.description),
                              border: InputBorder.none),
                        ),
                      ),
                    ),
                  ),
                  widget.action == "Create"
                      ? Container(
                          padding: EdgeInsets.all(15),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      side:
                                          BorderSide(color: Colors.grey[100])),
                                  height: 50,
                                  onPressed: () async {
                                    await pr.show();
                                    String img = await upLoadImage();
                                    if (img != null && img.isNotEmpty) {
                                      await create(img);
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        "Thêm mới",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  color: Colors.red[900],
                                ),
                              )
                            ],
                          ),
                        )
                      : Container(
                          padding: EdgeInsets.all(15),
                          child: Column(
                            children: <Widget>[
                              MaterialButton(
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
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ],
                                ),
                                color: Colors.red[900],
                              ),
                            ],
                          ),
                        ),
                ]),
          ),
        ),
      ),
    );
  }

  Future<String> upLoadImage() async {
    if (_image != null) {
      String imageUrl;
      final FirebaseStorage storage = FirebaseStorage.instance;
      final String pictureName =
          "images/dao_cu/username_${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
      StorageUploadTask task1 =
          storage.ref().child(pictureName).putFile(_image);

      StorageTaskSnapshot snapshot1 =
          await task1.onComplete.then((snapshot) => snapshot);
      imageUrl = await snapshot1.ref.getDownloadURL();
      return imageUrl;
    } else {
      if (widget.daocu != null) {
        if (widget.daocu.hinhAnh != null) {
          return widget.daocu.hinhAnh;
        }
      }
      await pr.hide();
      Fluttertoast.showToast(msg: 'Hình ảnh phải được cung cấp');
    }
  }

  Future<void> create(String imgUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    AuthDTO authDTO =
        AuthDTO.fromJson(json.decode(prefs.getString("UserInfo")));
    if (_formKey.currentState.validate()) {
      DaoCuDTO dto = DaoCuDTO(
          ten: _ten.text,
          dacTa: _dacTa.text,
          hinhAnh: imgUrl,
          trangThai: _trangThai.text.isEmpty ? "Mới" : _trangThai.text,
          implementer: authDTO.username);
      await pr.hide();
      Navigator.pop(context, dto);
    } else {
      await pr.hide();
    }
  }

  Future<void> update(String imgUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    AuthDTO authDTO =
        AuthDTO.fromJson(json.decode(prefs.getString("UserInfo")));
    if (_formKey.currentState.validate()) {
      DaoCuDTO dto = DaoCuDTO(
          daoCuId: widget.daocu.daoCuId,
          ten: _ten.text,
          dacTa: _dacTa.text,
          hinhAnh: imgUrl,
          trangThai: _trangThai.text.isEmpty ? "Mới" : _trangThai.text,
          implementer: authDTO.username);
      await pr.hide();
      Navigator.pop(context, dto);
    } else {
      await pr.hide();
    }
  }
}
