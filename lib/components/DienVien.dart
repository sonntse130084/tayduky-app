import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:taydukiapp/components/ImageCustom.dart';
import 'package:taydukiapp/dtos/UsersDTO.dart';
import 'package:taydukiapp/pages/DienVienForm.dart';
import 'package:taydukiapp/viewmodels/DienVienViewModel.dart';

class DienVien extends StatefulWidget {
  final List<UsersDTO> dienVienList;

  DienVien({this.dienVienList});

  @override
  _DienVienState createState() => _DienVienState();
}

class _DienVienState extends State<DienVien> {
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
    return ScopedModelDescendant<DienVienViewModel>(builder:
        (BuildContext buildContext, Widget child, DienVienViewModel model) {
      return widget.dienVienList.length > 0
          ? ListView.builder(
              itemCount: widget.dienVienList.length,
              itemBuilder: (context, index) {
                UsersDTO dto = widget.dienVienList[index];
                return DienVienSingle(
                  dienvien: dto,
                  deleteDienVien: () async {
                    await pr.show();
                    setState(() {
                      model.deleteDienVien(widget.dienVienList[index].username);
                    });
                    await pr.hide();
                  },
                  updateDienVien: (UsersDTO) async {
                    bool flg = await model.updateDienVien(UsersDTO);
                    if (flg) {
                      Fluttertoast.showToast(
                          msg: "Cập nhật diễn viên thành công");
                    } else {
                      Fluttertoast.showToast(
                          msg: "Cập nhật diễn viên thất bại");
                    }
                  },
                );
              },
            )
          : Center(
              child: Text(
                "Hiện tại không có diễn viên nào!",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
    });
  }
}

class DienVienSingle extends StatelessWidget {
  UsersDTO dienvien;
  Function() deleteDienVien;
  Function(UsersDTO) updateDienVien;

  DienVienSingle({this.dienvien, this.deleteDienVien, this.updateDienVien});

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
                      builder: (context) => DienVienForm(
                            dienvien: dienvien,
                            action: "Update",
                          )));
              if (result != null) {
                this.updateDienVien(result);
              }
            },
          ),
          IconSlideAction(
            caption: 'Delete',
            color: Colors.red[900],
            icon: Icons.delete,
            onTap: () {
              this.deleteDienVien();
            },
          ),
        ],
        child: Card(
          semanticContainer: true,
          child: ListTile(
            onTap: () {},
            leading: Container(
              height: 500,
              child: ImageCustom(
                image: dienvien.hinhAnh,
                fit: BoxFit.fill,
              ),
            ),
            title: Text(dienvien.ten),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text("Số điện thoại: "),
                    (dienvien.soDienThoai != null &&
                            dienvien.soDienThoai.isNotEmpty)
                        ? Text(
                            dienvien.soDienThoai,
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          )
                        : Text("không có"),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text("Email: "),
                    (dienvien.email != null && dienvien.email.isNotEmpty)
                        ? Text(
                            dienvien.email,
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          )
                        : Text("không có"),
                  ],
                ),
                Text(
                  dienvien.moTa,
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
