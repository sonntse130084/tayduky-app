import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:taydukiapp/components/DaoCu.dart';
import 'package:taydukiapp/dtos/DaoCuDTO.dart';
import 'package:taydukiapp/pages/DaoCuForm.dart';
import 'package:taydukiapp/viewmodels/DaoCuViewModels.dart';

class DaoCuPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: DaoCuViewModel(),
      child:  Scaffold(
        appBar: new AppBar(
          elevation: 0.1,
          backgroundColor: Colors.red[900],
          title: Text('Quản Lý Đạo Cụ'),
        ),
        body: ScopedModelDescendant<DaoCuViewModel>(builder:
            (BuildContext buildContext, Widget child, DaoCuViewModel model) {
          return 	FutureBuilder<List<DaoCuDTO>>(
              future: model.getAllDaoCu("All"),
              builder: (context, AsyncSnapshot<List<DaoCuDTO>> snapshot) {
                if (snapshot.hasData) {
                  return DaoCu(
                    daoCuList: snapshot.data,
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }
          );
        }),
        bottomNavigationBar: ScopedModelDescendant<DaoCuViewModel>(builder:
            (BuildContext buildContext, Widget child, DaoCuViewModel model) {
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
                              builder: (context) => DaoCuForm(
                                action: "Create",
                              )));
                      if (result != null) {
                        bool flg = await model.createDaoCu(result);
                        if (flg) {
                          Fluttertoast.showToast(msg: 'Đã thêm đạo cụ thành công');
                        } else {
                          Fluttertoast.showToast(msg: 'Thêm đạo cụ thất bại');
                        }
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Thêm một đạo cụ mới",
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
