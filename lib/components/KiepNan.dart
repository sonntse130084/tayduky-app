import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:taydukiapp/dtos/KiepNanDTO.dart';
import 'package:taydukiapp/pages/KiepNanForm.dart';
import 'package:taydukiapp/viewmodels/KiepNanViewModel.dart';

class KiepNan extends StatefulWidget {
  List<KiepNanDTO> kiepNanList = List<KiepNanDTO>();

  KiepNan({this.kiepNanList});

  @override
  _KiepNanState createState() => _KiepNanState();
}

class _KiepNanState extends State<KiepNan> {
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
    return ScopedModelDescendant<KiepNanViewModel>(
        builder: (BuildContext buildContext, Widget child, KiepNanViewModel model) {
          return widget.kiepNanList.length > 0 ? ListView.builder(
            itemCount: widget.kiepNanList.length,
            itemBuilder: (context, index) {
              KiepNanDTO dto = widget.kiepNanList[index];
              return KiepNanSingle(
                kiepnan: dto,
                deleteKiepNan: () async{
                  await pr.show();
                  setState(()  {
                    model.deleteKiepNan(widget.kiepNanList[index].kiepNanId);
                  });
                  await pr.hide();
                },
                updateKiepNan: (kiepnanDTO) async {
                    bool flg = await model.updateKiepNan(kiepnanDTO);
                    if(flg){
                      Fluttertoast.showToast(msg: "Cập nhật kiếp nạn thành công");
                    } else{
                      Fluttertoast.showToast(msg: "Cập nhật kiếp nạn thất bại");
                    }
                },
              );
            },
          ) : Center(
            child: Text(
              "Hiện tại không có kiếp nạn nào!",
              style:
              TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        });
  }
}

class KiepNanSingle extends StatelessWidget {
  KiepNanDTO kiepnan;
  Function() deleteKiepNan;
  Function(KiepNanDTO) updateKiepNan;

  KiepNanSingle({this.kiepnan, this.deleteKiepNan, this.updateKiepNan});

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
            caption: 'Edit',
            color: Colors.black,
            icon: Icons.edit,
            onTap: () async {
              dynamic result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => KiepNanForm(
                        action: "Update",
                        kiepnan: kiepnan,
                      )));
              if (result != null) {
                this.updateKiepNan(result);
              }
            },
          ),
          IconSlideAction(
            caption: 'Delete',
            color: Colors.red[900],
            icon: Icons.delete,
            onTap: () {
              this.deleteKiepNan();
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
}
