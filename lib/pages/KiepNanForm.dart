import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taydukiapp/dtos/AuthDTO.dart';
import 'package:taydukiapp/dtos/CartDaoCuDTO.dart';
import 'package:taydukiapp/dtos/CartDienVienDTO.dart';
import 'package:taydukiapp/dtos/KiepNanDTO.dart';
import 'package:taydukiapp/pages/CartDienVienPage.dart';
import 'package:taydukiapp/pages/ShoppingDaoCuPage.dart';

class KiepNanForm extends StatefulWidget {
  KiepNanDTO kiepnan;
  String action;

  KiepNanForm({this.kiepnan, this.action});

  @override
  _KiepNanFormState createState() => _KiepNanFormState();
}

class _KiepNanFormState extends State<KiepNanForm> {
  TextEditingController _name = TextEditingController();
  TextEditingController _place = TextEditingController();
  TextEditingController _timeStart = TextEditingController();
  TextEditingController _timeEnd = TextEditingController();
  TextEditingController _description = TextEditingController();
  TextEditingController _timeShot = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ProgressDialog pr;
  File _fileSpec;
  String _pathFile;
  String _fileName;

  @override
  void initState() {
    if (widget.kiepnan != null) {
      _name.text = widget.kiepnan.kiepNanNm;
      _place.text = widget.kiepnan.diaDiemQuay;
      _timeStart.text = widget.kiepnan.thoiGianBatDau;
      _timeEnd.text = widget.kiepnan.thoiGianKetThuc;
      _description.text = widget.kiepnan.moTa;
      _timeShot.text = "${widget.kiepnan.soLanQuay}";
      _pathFile = widget.kiepnan.dacTaVaiDien;
    }
    if (widget.kiepnan == null) {
      widget.kiepnan = KiepNanDTO();
    }
    if (widget.kiepnan.cartDaoCuDTO == null) {
      widget.kiepnan.cartDaoCuDTO = CartDaoCuDTO();
    }
    if (widget.kiepnan.cartDienVienDTO == null) {
      widget.kiepnan.cartDienVienDTO = CartDienVienDTO();
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
        title: Text('Kiếp Nạn Form'),
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
                  child: Text("Tên Kiếp Nạn: "),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                    elevation: 0.0,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0, right: 5.0),
                      child: TextFormField(
                        controller: _name,
                        maxLength: 50,
                        decoration: InputDecoration(
                            hintText: "Tên kiếp nạn",
                            icon: Icon(Icons.person_outline),
                            border: InputBorder.none),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Tên kiếp nạn không được để trống";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                  child: Text("Địa Điểm Quay Kiếp Nạn: "),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                    elevation: 0.0,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0, right: 5.0),
                      child: TextFormField(
                        controller: _place,
                        maxLength: 200,
                        decoration: InputDecoration(
                            hintText: "Địa điểm quay",
                            icon: Icon(Icons.place),
                            border: InputBorder.none),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Địa điểm quay không được để trống";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                  child: Text("Thời gian bắt đầu: "),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14.0, 8.0, 7.0, 8.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                    elevation: 0.0,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0, right: 5.0),
                      child: TextFormField(
                        controller: _timeStart,
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: DateTime.now(), onChanged: (date) {
//                            if (widget.kiepnan.cartDaoCuDTO.cart != null &&
//                                widget.kiepnan.cartDaoCuDTO.cart.length > 0) {
//                              bool flag = showConfirmAlertDialog(context);
//                              if (flag) {
//                                String x =
//                                    DateFormat("dd/MM/yyyy").format(date);
//                                _timeStart.text = x;
//                              }
//                            } else {
//                              String x = DateFormat("dd/MM/yyyy").format(date);
//                              _timeStart.text = x;
//                            }
                          }, onConfirm: (date) {
                            if (widget.kiepnan.cartDaoCuDTO.cart != null &&
                                widget.kiepnan.cartDaoCuDTO.cart.length > 0) {
                              showConfirmAlertDialog(context, date, "start");
                            } else {
                              String x = DateFormat("dd/MM/yyyy").format(date);
                              _timeStart.text = x;
                            }
                          },
                              currentTime: _timeStart.text.isEmpty
                                  ? DateTime.now()
                                  : DateFormat("dd/MM/yyyy")
                                      .parse(_timeStart.text),
                              locale: LocaleType.vi);
                        },
                        decoration: InputDecoration(
                            hintText: "bắt đầu",
                            icon: Icon(Icons.access_time),
                            border: InputBorder.none),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Thời gian bắt đầu không được để trống";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                  child: Text("Thời gian kết thúc: "),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(7.0, 8.0, 14.0, 8.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                    elevation: 0.0,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0, right: 5.0),
                      child: TextFormField(
                        controller: _timeEnd,
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: DateTime.now(), onChanged: (date) {
//                            if (widget.kiepnan.cartDaoCuDTO.cart != null &&
//                                widget.kiepnan.cartDaoCuDTO.cart.length > 0) {
//                              bool flag = showConfirmAlertDialog(context);
//                              if (flag) {
//                                String x =
//                                    DateFormat("dd/MM/yyyy").format(date);
//                                _timeEnd.text = x;
//                              }
//                            } else {
//                              String x = DateFormat("dd/MM/yyyy").format(date);
//                              _timeEnd.text = x;
//                            }
                          }, onConfirm: (date) {
                            if (widget.kiepnan.cartDaoCuDTO.cart != null &&
                                widget.kiepnan.cartDaoCuDTO.cart.length > 0) {
                              showConfirmAlertDialog(context, date, "end");
                            } else {
                              String x = DateFormat("dd/MM/yyyy").format(date);
                              _timeEnd.text = x;
                            }
                          },
                              currentTime: _timeEnd.text.isEmpty
                                  ? DateTime.now()
                                  : DateFormat("dd/MM/yyyy")
                                      .parse(_timeEnd.text),
                              locale: LocaleType.vi);
                        },
                        decoration: InputDecoration(
                            hintText: "kết thúc",
                            icon: Icon(Icons.timer_off),
                            border: InputBorder.none),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Thời gian kết thúc không được để trống";
                          } else {
                            if (_timeStart != null &&
                                _timeStart.text.isNotEmpty) {
                              var inputFormat = DateFormat("dd/MM/yyyy");
                              DateTime startTime =
                                  inputFormat.parse(_timeStart.text);
                              DateTime endTime = inputFormat.parse(value);
                              if (startTime.isAfter(endTime)) {
                                return "Thời gian kết thúc phải sau thời gian bắt đầu";
                              }
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
                  child: Text("Số Lần Quay"),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                    elevation: 0.0,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0, right: 5.0),
                      child: TextFormField(
                        controller: _timeShot,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter.digitsOnly
                        ],
                        // Only numbers can be entered
                        decoration: InputDecoration(
                            hintText: "Số lần quay",
                            icon: Icon(Icons.confirmation_number),
                            border: InputBorder.none),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Số lượng quay không được để trống";
                          } else if (int.parse(value) <= 0) {
                            return "Số lần quay phải lớn hơn 0";
                          }
                          return null;
                        },
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
                      padding: const EdgeInsets.only(left: 12.0, right: 5.0),
                      child: TextFormField(
                        maxLines: 5,
                        maxLength: 500,
                        controller: _description,
                        decoration: InputDecoration(
                            hintText: "Mô Tả",
                            icon: Icon(Icons.description),
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                  child: Text("Đặc tả vai diễn"),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(14.0, 0.0, 14.0, 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: ListTile(
                          title: _fileName != null
                              ? Text(
                                  _fileName,
                                )
                              : Text(""),
                          subtitle:
                              _pathFile != null ? Text(_pathFile) : Text(""),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: MaterialButton(
                              onPressed: () async {
                                await getFile();
                              },
                              child: Text(
                                "Chọn file từ thiết bị",
                                style: TextStyle(fontSize: 16),
                              ),
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                  child: Text("Danh sách đạo cụ: "),
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
                          if (_formKey.currentState.validate()) {
                            dynamic result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ShoppingDaoCu(
                                          cartDto: widget.kiepnan.cartDaoCuDTO,
                                          thoiGianBatDau: _timeStart.text,
                                          thoiGianKetThuc: _timeEnd.text,
                                        )));
                            if (result != null) {
                              setState(() {
                                widget.kiepnan.cartDaoCuDTO = result;
                              });
                            }
                          }
                        },
                        title: Text(
                          "Danh sách đạo cụ",
                          style: TextStyle(
                            color: Colors.red[900],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Icon(
                          Icons.navigate_next,
                          color: Colors.red[900],
                        ),
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                  child: Text("Danh sách vai diễn: "),
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
                          if (_formKey.currentState.validate()) {
                            dynamic result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CartDienVien(
                                          cartDienvien:
                                              widget.kiepnan.cartDienVienDTO,
                                        )));
                            if (result != null) {
                              setState(() {
                                widget.kiepnan.cartDienVienDTO = result;
                              });
                            }
                          }
                        },
                        title: Text(
                          "Danh sách vai diễn",
                          style: TextStyle(
                            color: Colors.red[900],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Icon(
                          Icons.navigate_next,
                          color: Colors.red[900],
                        ),
                      ),
                    )),
                widget.action == "Create"
                    ? Container(
                        padding: EdgeInsets.all(15),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    side: BorderSide(color: Colors.grey[100])),
                                height: 50,
                                onPressed: () async {
                                  await pr.show();
                                  String url = await upLoadFile();
                                  await create(url);
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
                                String url = await upLoadFile();
                                await update(url);
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  showConfirmAlertDialog(BuildContext context, dynamic date, String type) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Hủy bỏ"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Đồng ý"),
      onPressed: () {
        widget.kiepnan.cartDaoCuDTO = CartDaoCuDTO();
        String x = DateFormat("dd/MM/yyyy").format(date);
        if (type == "start") {
          _timeStart.text = x;
        } else {
          _timeEnd.text = x;
        }
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Xác nhận"),
      content: Text(
          "Nếu bạn muốn thay đổi ngày bắt đầu họặc kết thúc của kiếp nạn, đạo cụ của kiếp nạn sẽ bị trả lại!"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
  }

  Future<void> getFile() async {
    _fileSpec = await FilePicker.getFile();
//    _pathFile = await FilePicker.getFilePath();
    setState(() {
      _pathFile = _fileSpec.path;
      _fileName = _pathFile != null ? _pathFile.split('/').last : '...';
    });
  }

  Future<String> upLoadFile() async {
    if (_fileSpec != null) {
      String urlFile;
      final FirebaseStorage storage = FirebaseStorage.instance;
      final String pictureName =
          "files/${DateTime.now().millisecondsSinceEpoch.toString()}_${_fileName}";
      StorageUploadTask task1 =
          storage.ref().child(pictureName).putFile(_fileSpec);

      StorageTaskSnapshot snapshot1 =
          await task1.onComplete.then((snapshot) => snapshot);
      urlFile = await snapshot1.ref.getDownloadURL();
      return urlFile;
    } else {
      if (widget.kiepnan != null) {
        if (widget.kiepnan.dacTaVaiDien != null) {
          return widget.kiepnan.dacTaVaiDien;
        }
      }
      await pr.hide();
      return "";
    }
  }

  Future<void> create(String fileUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    AuthDTO authDTO =
        AuthDTO.fromJson(json.decode(prefs.getString("UserInfo")));
    if (_formKey.currentState.validate()) {
      KiepNanDTO dto = KiepNanDTO(
        kiepNanNm: _name.text,
        moTa: _description.text,
        diaDiemQuay: _place.text,
        thoiGianBatDau: _timeStart.text,
        thoiGianKetThuc: _timeEnd.text,
        soLanQuay: int.parse(_timeShot.text),
        dacTaVaiDien: fileUrl,
        cartDaoCuDTO: widget.kiepnan.cartDaoCuDTO,
        cartDienVienDTO: widget.kiepnan.cartDienVienDTO,
        implementer: authDTO.username,
      );
      await pr.hide();
      Navigator.pop(context, dto);
    } else {
      await pr.hide();
    }
  }

  Future<void> update(String fileUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    AuthDTO authDTO =
        AuthDTO.fromJson(json.decode(prefs.getString("UserInfo")));
    if (_formKey.currentState.validate()) {
      KiepNanDTO dto = KiepNanDTO(
        kiepNanId: widget.kiepnan.kiepNanId,
        kiepNanNm: _name.text,
        moTa: _description.text,
        diaDiemQuay: _place.text,
        thoiGianBatDau: _timeStart.text,
        thoiGianKetThuc: _timeEnd.text,
        soLanQuay: int.parse(_timeShot.text),
        dacTaVaiDien: fileUrl,
        cartDaoCuDTO: widget.kiepnan.cartDaoCuDTO,
        cartDienVienDTO: widget.kiepnan.cartDienVienDTO,
        implementer: authDTO.username,
      );
      await pr.hide();
      Navigator.pop(context, dto);
    } else {
      await pr.hide();
    }
  }
}
