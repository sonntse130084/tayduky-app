import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:taydukiapp/dtos/KiepNanDTO.dart';
import 'package:taydukiapp/pages/LichDien.dart';
import 'package:taydukiapp/viewmodels/KiepNanDienVienViewModel.dart';

class LichSuPage extends StatefulWidget {
  @override
  _LichSuPageState createState() => _LichSuPageState();
}

class _LichSuPageState extends State<LichSuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          elevation: 0.1,
          backgroundColor: Colors.red[900],
          title: Text('Lịch sử diễn viên'),
        ),
        body: ScopedModel(
          model: KiepNanDienVienViewModel(),
          child: ScopedModelDescendant<KiepNanDienVienViewModel>(builder:
              (BuildContext buildContext, Widget child,
                  KiepNanDienVienViewModel model) {
            return FutureBuilder<List<KiepNanDTO>>(
                future: model.getKiepNanOfDienVien(isFinished: "1"),
                builder: (context, AsyncSnapshot<List<KiepNanDTO>> snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data.length > 0
                        ? ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              KiepNanDTO dto = snapshot.data[index];
                              return KiepNanSingle2(
                                kiepnan: dto,
                              );
                            },
                          )
                        : Center(
                            child: Text(
                              "Hiện tại không có kiếp nạn nào!",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                });
          }),
        ));
  }
}
