import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:taydukiapp/components/DienVien.dart';
import 'package:taydukiapp/dtos/UsersDTO.dart';
import 'package:taydukiapp/pages/DienVienForm.dart';
import 'package:taydukiapp/viewmodels/DienVienViewModel.dart';

class DienVienPage extends StatefulWidget {
  @override
  _DienVienPageState createState() => _DienVienPageState();
}

class _DienVienPageState extends State<DienVienPage> {
  var dienVienList = [
    {
      "username": "dienvien1",
      "password": "123456",
      "ten": "Ngộ Không",
      "moTa": "Đây là Ngộ Không",
      "hinhAnh": "assets/ngokhong.png",
      "soDienThoai": "0966038624",
      "email": "sh2812995@gmail.com"
    },
    {
      "username": "dienvien2",
      "password": "123456",
      "ten": "Đường Tăng",
      "moTa": "Đây là Đường Tăng",
      "hinhAnh": "assets/duongtang.png",
      "soDienThoai": "19001582",
      "email": "sonmap@gmail.com"
    },
    {
      "username": "dienvien3",
      "password": "123456",
      "ten": "Bát Giới",
      "moTa": "Đây là Bát Giới",
      "hinhAnh": "assets/batgioi.png",
      "soDienThoai": "19009001",
      "email": "batgioi@gmail.com"
    },
    {
      "username": "dienvien4",
      "password": "123456",
      "ten": "Sa Tăng",
      "moTa": "Đây là Sa Tăng",
      "hinhAnh": "assets/satang.png",
      "soDienThoai": "0985339476",
      "email": "sahoathuong@gmail.com"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
        model: DienVienViewModel(),
        child: Scaffold(
          appBar: new AppBar(
            elevation: 0.1,
            backgroundColor: Colors.red[900],
            title: Text('Quản Lý Diễn Viên'),
          ),
          body: ScopedModelDescendant<DienVienViewModel>(builder:
              (BuildContext buildContext, Widget child,
              DienVienViewModel model) {
            return FutureBuilder<List<UsersDTO>>(
                future: model.getAllDienVien(),
                builder: (context, AsyncSnapshot<List<UsersDTO>> snapshot) {
                  if (snapshot.hasData) {
                    return DienVien(
                      dienVienList: snapshot.data,
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }
            );
          }),
          bottomNavigationBar:
          ScopedModelDescendant<DienVienViewModel>(builder:
              (BuildContext buildContext, Widget child,
              DienVienViewModel model) {
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
                                builder: (context) =>
                                    DienVienForm(
                                      action: "Create",
                                    )));
                        if (result != null) {
                          bool flg = await model.createDienVien(result);
                          if (flg) {
                            Fluttertoast.showToast(
                                msg: 'Đã thêm diễn viên thành công');
                          } else {
                            Fluttertoast.showToast(
                                msg: 'Thêm diễn viên thất bại');
                          }
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Thêm một Diễn Viên mới",
                            style: TextStyle(
                                color: Colors.white, fontSize: 20),
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
