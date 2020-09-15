import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:taydukiapp/components/KiepNan.dart';
import 'package:taydukiapp/dtos/KiepNanDTO.dart';
import 'package:taydukiapp/pages/KiepNanForm.dart';
import 'package:taydukiapp/pages/VaiDienDetails.dart';
import 'package:taydukiapp/viewmodels/KiepNanDienVienViewModel.dart';
import 'package:taydukiapp/viewmodels/KiepNanViewModel.dart';

class LichDienPage extends StatefulWidget {
  @override
  _LichDienPageState createState() => _LichDienPageState();
}

class _LichDienPageState extends State<LichDienPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          elevation: 0.1,
          backgroundColor: Colors.red[900],
          title: Text('Lịch diễn'),
        ),
        body: ScopedModel(
          model: KiepNanDienVienViewModel(),
          child: ScopedModelDescendant<KiepNanDienVienViewModel>(builder:
              (BuildContext buildContext, Widget child,
                  KiepNanDienVienViewModel model) {
            return FutureBuilder<List<KiepNanDTO>>(
                future: model.getKiepNanOfDienVien(isFinished: "0"),
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

class KiepNanSingle2 extends StatelessWidget {
  KiepNanDTO kiepnan;

  KiepNanSingle2({this.kiepnan});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5),
      height: 90,
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'Chi tiết',
            color: Colors.black,
            icon: Icons.details,
            onTap: () async {
             Navigator.push(context, MaterialPageRoute(builder: (context) => VaiDienDetails(kiepnan: kiepnan,)));
            },
          ),
        ],
        child: Card(
          semanticContainer: true,
          child: ListTile(
            title: Text(kiepnan.kiepNanNm),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text("Địa điểm quay: "),
                    Text(
                      kiepnan.diaDiemQuay,
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text("Thời gian quay: "),
                    Text(
                      "${kiepnan.thoiGianBatDau} - ${kiepnan.thoiGianKetThuc}",
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> downloadFile() async {
    String _localPath = 'storage/emulated/0/Download';
//                                  String _localPath = (await _findLocalPath()) + Platform.pathSeparator + 'Download';
//                                  final savedDir = Directory(_localPath);
    final taskId = await FlutterDownloader.enqueue(
      url: kiepnan.dacTaVaiDien,
      savedDir: _localPath,
      showNotification: true,
      // show download progress in status bar (for Android)
      openFileFromNotification:
          true, // click on notification to open downloaded file (for Android)
    );
    Fluttertoast.showToast(msg: "Download thành công!");
  }

  Future<String> _findLocalPath() async {
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }
}
