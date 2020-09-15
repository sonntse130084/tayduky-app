import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:taydukiapp/components/KiepNan.dart';
import 'package:taydukiapp/dtos/KiepNanDTO.dart';
import 'package:taydukiapp/pages/KiepNanForm.dart';
import 'package:taydukiapp/viewmodels/KiepNanViewModel.dart';

class KiepNanPage extends StatefulWidget {
  @override
  _KiepNanPageState createState() => _KiepNanPageState();
}

class _KiepNanPageState extends State<KiepNanPage> {
  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: KiepNanViewModel(),
      child: Scaffold(
        appBar: new AppBar(
          elevation: 0.1,
          backgroundColor: Colors.red[900],
          title: Text('Quản lý kiếp nạn'),
        ),
        body: ScopedModelDescendant<KiepNanViewModel>(builder:
            (BuildContext buildContext, Widget child, KiepNanViewModel model) {
          return FutureBuilder<List<KiepNanDTO>>(
              future: model.getAllKiepNan(),
              builder: (context, AsyncSnapshot<List<KiepNanDTO>> snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    color: Colors.grey[200],
                    child: KiepNan(
                      kiepNanList: snapshot.data,
                    ),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              });
        }),
        bottomNavigationBar: ScopedModelDescendant<KiepNanViewModel>(builder:
            (BuildContext buildContext, Widget child, KiepNanViewModel model) {
          return Container(
            color: Colors.white,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: MaterialButton(
                    height: 60,
                    onPressed: () async {
                      dynamic result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => KiepNanForm(
                                    action: "Create",
                                  )));
                      if (result != null) {
                        bool flg = await model.createKiepNan(result);
                        if (flg) {
                          Fluttertoast.showToast(
                              msg: 'Đã thêm kiếp nạn thành công');
                        } else {
                          Fluttertoast.showToast(msg: 'Thêm kiếp nạn thất bại');
                        }
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Thêm một kiếp nạn mới",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ],
                    ),
                    color: Colors.red[900],
                  ),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
