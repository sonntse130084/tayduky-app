import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:taydukiapp/dtos/KiepNanDTO.dart';
import 'package:taydukiapp/viewmodels/KiepNanDienVienViewModel.dart';

class VaiDienDetails extends StatefulWidget {
  KiepNanDTO kiepnan;

  VaiDienDetails({this.kiepnan});

  @override
  _VaiDienDetailsState createState() => _VaiDienDetailsState();
}

class _VaiDienDetailsState extends State<VaiDienDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          elevation: 0.1,
          backgroundColor: Colors.red[900],
          title: Text('Chi Tiết Kiếp Nạn'),
        ),
        body: ScopedModel(
          model: KiepNanDienVienViewModel(),
          child: ScopedModelDescendant<KiepNanDienVienViewModel>(
              builder: (BuildContext buildContext, Widget child,
                  KiepNanDienVienViewModel model) {
                return FutureBuilder<String>(
                    future: model.getVaiDien(
                        kiepNanId: widget.kiepnan.kiepNanId),
                    builder:
                        (context, AsyncSnapshot<String> snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                          padding: EdgeInsets.all(12.0),
                          color: Colors.grey[200],
                          height: double.infinity,
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Tên Kiếp Nạn: ",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        widget.kiepnan.kiepNanNm,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Thời gian quay: ",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "${widget.kiepnan.thoiGianBatDau} - ${widget.kiepnan.thoiGianKetThuc}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Mô tả kiếp nạn: ",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Expanded(
                                      child: Text(
                                        widget.kiepnan.moTa,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Vai diễn: ",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(snapshot.data,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          )),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Center(
                            child: CircularProgressIndicator());
                      }
                    });
              }),
        ),
        floatingActionButton: ClipOval(
          child: Material(
            color: Colors.red[900], // button color
            child: InkWell(
              child: SizedBox(
                  width: 80,
                  height: 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Đặc tả",
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        "vai diễn",
                        style: TextStyle(color: Colors.white),
                      ),
                      Icon(
                        Icons.file_download,
                        color: Colors.white,
                      )
                    ],
                  )),
              onTap: () async {
                if (widget.kiepnan.dacTaVaiDien == null ||
                    widget.kiepnan.dacTaVaiDien.isEmpty) {
                  Fluttertoast.showToast(
                      msg: "Kiếp nạn này không có đặc tả để bạn download");
                } else {
                  await downloadFile();
                }
              },
            ),
          ),
        ));
  }

  Future<void> downloadFile() async {
    String _localPath = 'storage/emulated/0/Download';
//                                  String _localPath = (await _findLocalPath()) + Platform.pathSeparator + 'Download';
//                                  final savedDir = Directory(_localPath);
    final taskId = await FlutterDownloader.enqueue(
      url: widget.kiepnan.dacTaVaiDien,
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
