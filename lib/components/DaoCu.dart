import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:taydukiapp/components/ImageCustom.dart';
import 'package:taydukiapp/dtos/DaoCuDTO.dart';
import 'package:taydukiapp/pages/DaoCuForm.dart';
import 'package:taydukiapp/viewmodels/DaoCuViewModels.dart';

class DaoCu extends StatefulWidget {
  final List<DaoCuDTO> daoCuList;

  DaoCu({this.daoCuList});

  @override
  _DaoCuState createState() => _DaoCuState();
}

class _DaoCuState extends State<DaoCu> {
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
    return ScopedModelDescendant<DaoCuViewModel>(builder:
        (BuildContext buildContext, Widget child, DaoCuViewModel model) {
      return widget.daoCuList.length > 0
          ? ListView.builder(
              itemCount: widget.daoCuList.length,
              itemBuilder: (context, index) {
                DaoCuDTO dto = widget.daoCuList[index];
                return DaoCuSingle2(
                  daocu: dto,
                  deleteItem: () async {
                    await pr.show();
                    setState(() {
                      model.deleteDaoCu(widget.daoCuList[index].daoCuId);
                    });
                    await pr.hide();
                  },
                  updateItem: (daocuDTO) async {
                    bool flg = await model.updateDaoCu(daocuDTO);
                    if (flg) {
                      Fluttertoast.showToast(msg: "Cập nhật đạo cụ thành công");
                    } else {
                      Fluttertoast.showToast(msg: "Cập nhật đạo cụ thất bại");
                    }
                  },
                );
              })
          : Center(
              child: Text(
                "Hiện tại không có đạo cụ nào trong kho!",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
    });
  }
}

class DaoCuSingle2 extends StatelessWidget {
  DaoCuDTO daocu;

  Function() deleteItem;
  Function(DaoCuDTO) updateItem;

  DaoCuSingle2({this.daocu, this.deleteItem, this.updateItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5),
      height: 120,
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
                      builder: (context) => DaoCuForm(
                            action: "Update",
                            daocu: daocu,
                          )));
              if (result != null) {
                this.updateItem(result);
              }
            },
          ),
          IconSlideAction(
            caption: 'Delete',
            color: Colors.red[900],
            icon: Icons.delete,
            onTap: () {
              this.deleteItem();
            },
          ),
        ],
        child: Card(
          semanticContainer: true,
          child: ListTile(
            onTap: () {},
            leading: Container(
              height: 500,
              width: 70,
              child: ImageCustom(
                image: daocu.hinhAnh,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(daocu.ten),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text("Trạng thái: "),
                    Expanded(
                      child: Text(
                        "${daocu.trangThai}",
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Text(
                  "${daocu.dacTa}",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DaoCuSingle1 extends StatelessWidget {
  DaoCuDTO daocu;

  DaoCuSingle1({
    this.daocu,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Hero(
      tag: daocu.daoCuId,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DaoCuForm(
                        action: "Update",
                        daocu: daocu,
                      )));
        },
        child: GridTile(
          footer: Container(
            height: 40,
            color: Colors.white70,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    daocu.ten,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
          child: ImageCustom(
            image: daocu.hinhAnh,
            fit: BoxFit.cover,
          ),
        ),
      ),
    ));
  }
}
