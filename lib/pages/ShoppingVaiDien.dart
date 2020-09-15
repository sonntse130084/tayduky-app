import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:taydukiapp/components/ImageCustom.dart';
import 'package:taydukiapp/dtos/CartDienVienDTO.dart';
import 'package:taydukiapp/dtos/UsersDTO.dart';
import 'package:taydukiapp/dtos/VaiDienItem.dart';
import 'package:taydukiapp/viewmodels/DienVienViewModel.dart';

class ShoppingVaiDien extends StatefulWidget {
  String vaidien;
  CartDienVienDTO cartDienVienDTO;
  String action;

  ShoppingVaiDien({this.vaidien, this.cartDienVienDTO, this.action});

  @override
  _ShoppingVaiDienState createState() => _ShoppingVaiDienState();
}

class _ShoppingVaiDienState extends State<ShoppingVaiDien> {
  TextEditingController _vaiDien = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.vaidien != null) {
      _vaiDien.text = widget.vaidien;
    }
  }

  Widget _fieldVaiDien() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
            child: Text("Tên vai diễn: "),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
            child: Material(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
              elevation: 0.0,
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: TextFormField(
                  controller: _vaiDien,
                  decoration: InputDecoration(
                      hintText: "Tên vai diễn",
                      icon: Icon(Icons.recent_actors),
                      border: InputBorder.none),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Tên vai diễn không được để trống";
                    } else if (widget.action == "Create" &&
                        widget.cartDienVienDTO.checkVaiDien(value) != -1) {
                      return "Vai diễn này đã tồn tại trong kiếp nạn này!\nVui lòng tạo 1 vai diễn khác";
                    } else if(widget.vaidien != value &&  widget.cartDienVienDTO.checkVaiDien(value) != -1){
                      return "Vai diễn này đã tồn tại trong kiếp nạn này!\nVui lòng tạo 1 vai diễn khác";
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
            child: Text("Diễn viên: "),
          ),
        ],
      ),
    );
  }

  Widget _noneDienVien() {
    return Center(
      child: Container(
        child: OutlineButton(
            borderSide:
                BorderSide(color: Colors.grey.withOpacity(0.5), width: 2.5),
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                VaiDienItem vaiDienItem =
                    VaiDienItem(dienvien: null, vaidien: _vaiDien.text);
                Navigator.pop(context, vaiDienItem);
              }
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
              child: Text(
                "Hiện tại chưa chọn được diễn viên!",
                style: TextStyle(color: Colors.grey),
              ),
            )),
      ),
    );
  }

  List<UsersDTO> userList;

  Widget _displayBody() {
    return ScopedModelDescendant<DienVienViewModel>(builder:
        (BuildContext buildContext, Widget child, DienVienViewModel model) {
      return FutureBuilder<List<UsersDTO>>(
          future: model.getAllDienVien(),
          builder: (context, AsyncSnapshot<List<UsersDTO>> snapshot) {
            if (snapshot.hasData) {
              return Container(
                color: Colors.grey[200],
                child: Form(
                  key: _formKey,
                  child: ListView.builder(
                    itemCount: snapshot.data.length + 2,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return _fieldVaiDien();
                      } else if (index == 1) {
                        return Container();
//                return _noneDienVien();
                      } else {
                        UsersDTO dto = snapshot.data[index - 2];
                        if (widget.cartDienVienDTO
                                .checkDienVien(dto.username) ==
                            -1) {
                          empty = false;
                          bool isChoose = false;
                          if (_dienVienDTO != null) {
                            isChoose = _dienVienDTO.username == dto.username
                                ? true
                                : false;
                          }
                          return DienVienSingle2(
                              dienvien: dto,
                              isChoose: isChoose,
                              chooseDienvien: (dto) {
                                setState(() {
                                  _dienVienDTO = dto;
                                });
                              });
                        } else if (empty && index == snapshot.data.length + 1) {
                          return Container(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Divider(),
                                Center(
                                  child: Text(
                                    "Hiện tại không có diễn viên nào để bạn có thể lựa chọn cho kiếp nạn này!",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Container();
                        }
                      }
                    },
                  ),
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          });
    });
  }

  bool empty = true;
  UsersDTO _dienVienDTO;

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: DienVienViewModel(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.1,
          backgroundColor: Colors.red[900],
          title: Text('Chọn Diễn Viên Cho Vai Diễn'),
        ),
        body: _displayBody(),
        bottomNavigationBar: new Container(
          color: Colors.white,
          child: Row(
            children: <Widget>[
              Expanded(
                child: MaterialButton(
                  height: 60,
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      if (_dienVienDTO == null && widget.action == "Create") {
                        Fluttertoast.showToast(
                            msg:
                                "Bạn vui lòng chọn diễn viên cho vai diễn trên!");
                      } else {
                        if (_dienVienDTO == null) {
                          int index = widget.cartDienVienDTO
                              .checkVaiDien(widget.vaidien);
                          if (index != -1) {
                            _dienVienDTO =
                                widget.cartDienVienDTO.cart[index].dienvien;
                          }
                        }
                        VaiDienItem vaiDienItem = VaiDienItem(
                            dienvien: _dienVienDTO, vaidien: _vaiDien.text);
                        Navigator.pop(context, vaiDienItem);
                      }
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Xác nhận",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                  color: Colors.red[900],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DienVienSingle2 extends StatefulWidget {
  UsersDTO dienvien;
  Function(UsersDTO) chooseDienvien;
  bool isChoose = false;

  DienVienSingle2({this.dienvien, this.chooseDienvien, this.isChoose});

  @override
  _DienVienSingle2State createState() => _DienVienSingle2State();
}

class _DienVienSingle2State extends State<DienVienSingle2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5),
      height: 120,
      child: Card(
        semanticContainer: true,
        color: widget.isChoose ? Colors.black12 : Colors.white,
        child: ListTile(
          onTap: () {
            this.widget.chooseDienvien(widget.dienvien);
          },
          leading: Container(
            height: 500,
            child: ImageCustom(
              image: widget.dienvien.hinhAnh,
              fit: BoxFit.fill,
            ),
          ),
          title: Text(widget.dienvien.ten),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text("Số điện thoại: "),
                  Text(
                    widget.dienvien.soDienThoai,
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Text("Email: "),
                  Text(
                    widget.dienvien.email,
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Text(
                widget.dienvien.moTa,
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
