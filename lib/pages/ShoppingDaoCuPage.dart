import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:taydukiapp/components/ImageCustom.dart';
import 'package:taydukiapp/dtos/CartDaoCuDTO.dart';
import 'package:taydukiapp/dtos/DaoCuDTO.dart';
import 'package:taydukiapp/dtos/ThongKeDaoCuDTO.dart';
import 'package:taydukiapp/viewmodels/DaoCuViewModels.dart';

class ShoppingDaoCu extends StatefulWidget {
  CartDaoCuDTO cartDto;
  String thoiGianBatDau;
  String thoiGianKetThuc;

  ShoppingDaoCu({this.cartDto, this.thoiGianBatDau, this.thoiGianKetThuc});

  @override
  _ShoppingDaoCuState createState() => _ShoppingDaoCuState();
}

class _ShoppingDaoCuState extends State<ShoppingDaoCu> {
  var cart = new CartDaoCuDTO();

  @override
  void initState() {
    if (widget.cartDto != null && widget.cartDto.cart != null) {
      for (var daocu in widget.cartDto.cart) {
        cart.addItemToCart(daocu);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: DaoCuViewModel(cart: cart.cart),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.1,
          backgroundColor: Colors.red[900],
          title: Text('Shopping Đạo Cụ'),
        ),
        body: ScopedModelDescendant<DaoCuViewModel>(builder:
            (BuildContext buildContext, Widget child, DaoCuViewModel model) {
          return FutureBuilder<List<DaoCuDTO>>(
              future: model.thongKeDaoCu(
                  "Shopping",
                  ThongKeDaoCuDTO(
                      thoiGianBatDau: widget.thoiGianBatDau,
                      thoiGianKetThuc: widget.thoiGianKetThuc)),
              builder: (context, AsyncSnapshot<List<DaoCuDTO>> snapshot) {
                if (snapshot.hasData) {
                  return model.daocuList.length > 0
                      ? ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            DaoCuDTO dto = snapshot.data[index];
                            bool isChoose =
                                cart.isExist(dto.daoCuId) != -1 ? true : false;
                            return DaoCuSingle3(
                              daocu: dto,
                              isChoose: isChoose,
                              updateCart: (action) {
                                updateCart(dto, action);
                              },
                            );
                          },
                        )
                      : Container(
                          padding: EdgeInsets.all(8),
                          child: Center(
                            child: Text(
                              "Hiện tại không còn đạo cụ nào trong kho để bạn lựa chọn!",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ),
                        );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              });
        }),
        bottomNavigationBar: new Container(
          color: Colors.white,
          child: Row(
            children: <Widget>[
              Expanded(
                child: MaterialButton(
                  height: 60,
                  onPressed: () async {
                    Navigator.pop(context, cart);
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

  void updateCart(DaoCuDTO dto, String action) {
    if (action == "Add") {
      cart.addItemToCart(dto);
    } else {
      cart.removeItemFromCart(dto);
    }
  }
}

class DaoCuSingle3 extends StatefulWidget {
  DaoCuDTO daocu;
  bool isChoose;
  Function(String) updateCart;

  DaoCuSingle3({
    this.daocu,
    this.isChoose,
    this.updateCart,
  });

  @override
  _DaoCuSingle3State createState() => _DaoCuSingle3State();
}

class _DaoCuSingle3State extends State<DaoCuSingle3> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5),
      height: 120,
      child: Card(
        semanticContainer: true,
        child: ListTile(
          onTap: () {
            setState(() {
              widget.isChoose = !widget.isChoose;
            });
            if (widget.isChoose) {
              widget.updateCart("Add");
            } else {
              widget.updateCart("Remove");
            }
          },
          leading: Container(
            height: 500,
            width: 70,
            child: ImageCustom(
              image: widget.daocu.hinhAnh,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(widget.daocu.ten),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text("Trạng thái: "),
                  Expanded(
                    child: Text(
                      "${widget.daocu.trangThai}",
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Text(
                "${widget.daocu.dacTa}",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          trailing: Checkbox(
            activeColor: Colors.white,
            checkColor: Colors.black,
            value: widget.isChoose,
            onChanged: (bool value) {
              setState(() {
                widget.isChoose = value;
              });
              if (widget.isChoose) {
                widget.updateCart("Add");
              } else {
                widget.updateCart("Remove");
              }
            },
          ),
        ),
      ),
    );
  }
}
