import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:taydukiapp/components/ImageCustom.dart';
import 'package:taydukiapp/dtos/CartDienVienDTO.dart';
import 'package:taydukiapp/dtos/UsersDTO.dart';
import 'package:taydukiapp/dtos/VaiDienItem.dart';
import 'package:taydukiapp/pages/ShoppingVaiDien.dart';

class CartDienVien extends StatefulWidget {
  CartDienVienDTO cartDienvien;

  CartDienVien({this.cartDienvien});

  @override
  _CartDienVienState createState() => _CartDienVienState();
}

class _CartDienVienState extends State<CartDienVien> {
  CartDienVienDTO cart = CartDienVienDTO();

  @override
  void initState() {
    if (widget.cartDienvien != null && widget.cartDienvien.cart != null) {
      for (var vaiDienItem in widget.cartDienvien.cart) {
        cart.addItemToCart(vaiDienItem.vaidien, vaiDienItem.dienvien);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Colors.red[900],
        title: Text('Cart Diễn Viên'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
            itemCount: cart.cart == null
                ? 1
                : cart.cart.length + 1,
            itemBuilder: (context, index) {
              bool flagEmpty = false;
              if (cart.cart == null ||
                  index == cart.cart.length) {
                flagEmpty = true;
              }
              if (!flagEmpty) {
                VaiDienItem daoCuItem = cart.cart[index];
                return DienVienSingle1(
                  dienvien: cart.cart[index].dienvien,
                  vaidien: cart.cart[index].vaidien,
                  updateCartDienVien: (vaiDienItem) {
                    updateCartDienVien(
                        cart.cart[index].vaidien, vaiDienItem);
                  },
                  deleteVaiDien: () {
                    deleteVaiDien(cart.cart[index].vaidien);
                  },
                  cartDienVienDTO: cart,
                );
              } else {
                return Center(
                  child: Container(
                    padding: EdgeInsets.only(top: 10),
                    child: OutlineButton(
                        borderSide: BorderSide(
                            color: Colors.grey.withOpacity(0.5), width: 2.5),
                        onPressed: () async {
                          dynamic result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ShoppingVaiDien(
                                        cartDienVienDTO: cart,
                                        action: "Create",
                                      )));
                          if (result != null) {
                            setState(() {
                              cart.addVaiDienItemToCart(result);
                              Fluttertoast.showToast(
                                  msg: "Thêm vai diễn vào kiếp nạn thành công");
                            });
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
                          child: new Icon(
                            Icons.add,
                            color: Colors.grey,
                            size: 65,
                          ),
                        )),
                  ),
                );
              }
            }),
      ),
      bottomNavigationBar: Container(
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
    );
  }

  void updateCartDienVien(String vaidien, VaiDienItem vaiDienItem) {
    setState(() {
      cart.updateDienVienForVaiDien(vaidien, vaiDienItem);
    });
  }

  void deleteVaiDien(String vaidien) {
    setState(() {
      cart.removeItem(vaidien);
    });
  }
}

class DienVienSingle1 extends StatelessWidget {
  String vaidien;
  UsersDTO dienvien;
  Function(VaiDienItem) updateCartDienVien;
  Function() deleteVaiDien;
  CartDienVienDTO cartDienVienDTO;

  DienVienSingle1(
      {this.vaidien,
      this.dienvien,
      this.updateCartDienVien,
      this.deleteVaiDien,
      this.cartDienVienDTO});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5),
      height: 150,
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
                      builder: (context) => ShoppingVaiDien(
                            vaidien: vaidien,
                            cartDienVienDTO: cartDienVienDTO,
                            action: "Edit",
                          )));
              if (result != null) {
                this.updateCartDienVien(result);
              }
            },
          ),
          IconSlideAction(
            caption: 'Delete',
            color: Colors.red[900],
            icon: Icons.delete,
            onTap: () {
              this.deleteVaiDien();
            },
          ),
        ],
        child: Card(
          color: Colors.white,
          semanticContainer: true,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(color: Colors.red[900], width: 2)),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Vai diễn: ",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      vaidien,
                      style: TextStyle(
                        color: Colors.red[900],
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 1,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Diễn viên: ",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                    dienvien == null
                        ? Padding(
                            padding:
                                const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.white,
                              ),
                              child: ListTile(
                                onTap: () async {
                                  dynamic result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ShoppingVaiDien(
                                                vaidien: vaidien,
                                                cartDienVienDTO:
                                                    cartDienVienDTO,
                                                action: "Edit",
                                              )));
                                  if (result != null) {
                                    this.updateCartDienVien(result);
                                  }
                                },
                                title: Text(
                                  "Chọn diễn viên cho vai diễn",
                                  style: TextStyle(
                                    color: Colors.red[900],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                trailing: Icon(
                                  Icons.navigate_next,
                                  color: Colors.red[900],
                                ),
                              ),
                            ))
                        : ListTile(
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
                                    Text(
                                      dienvien.soDienThoai,
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text("Email: "),
                                    Text(
                                      dienvien.email,
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
