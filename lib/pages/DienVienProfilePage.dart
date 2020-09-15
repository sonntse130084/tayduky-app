import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:taydukiapp/dtos/UsersDTO.dart';
import 'package:taydukiapp/pages/ProfileForm.dart';
import 'package:taydukiapp/viewmodels/UsersViewModels.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(45.0),
        child: AppBar(
          backgroundColor: Colors.white10,
        ),
      ),
      backgroundColor: Colors.grey[200],
      body: ScopedModel(
        model: UsersViewModel(),
        child: ScopedModelDescendant<UsersViewModel>(builder:
            (BuildContext buildContext, Widget child, UsersViewModel model) {
          return FutureBuilder<UsersDTO>(
              future: model.getUsersSession(),
              builder: (context, AsyncSnapshot<UsersDTO> snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: <Widget>[
                      Stack(
                        overflow: Overflow.visible,
                        alignment: Alignment.center,
                        children: <Widget>[
                          Image.asset(
                            "assets/taydukybackground.jpg",
                            fit: BoxFit.cover,
                            height: MediaQuery.of(context).size.height / 3,
                            width: double.infinity,
                          ),
                          Positioned(
                            bottom: -60.0,
                            child: CircleAvatar(
                              radius: 80,
                              backgroundColor: Colors.white,
                              backgroundImage:
                                  snapshot.data.hinhAnh.contains("assets/")
                                      ? AssetImage(
                                          snapshot.data.hinhAnh,
                                        )
                                      : NetworkImage(
                                          snapshot.data.hinhAnh,
                                        ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 80.0,
                      ),
                      Center(
                          child: Text(
                        snapshot.data.ten,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      )),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Số điện thoại: "),
                                (snapshot.data.soDienThoai != null &&
                                        snapshot.data.soDienThoai.isNotEmpty)
                                    ? Expanded(
                                        child: Text(
                                          "${snapshot.data.soDienThoai}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    : Text("Không có"),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("Email: "),
                                (snapshot.data.email != null &&
                                        snapshot.data.email.isNotEmpty)
                                    ? Expanded(
                                        child: Text(
                                          "${snapshot.data.email}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    : Text("Không có"),
                              ],
                            ),
                            (snapshot.data.diaChi != null &&
                                    snapshot.data.diaChi.isNotEmpty)
                                ? Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text("Địa chỉ: "),
                                      Expanded(
                                        child: Text(
                                          "${snapshot.data.diaChi}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    ],
                                  )
                                : Container(),
                            (snapshot.data.moTa != null &&
                                    snapshot.data.moTa.isNotEmpty)
                                ? Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text("Mô tả: "),
                                      Expanded(
                                        child: Text(
                                          "${snapshot.data.moTa}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    ],
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      Material(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.white.withOpacity(0.5),
                          elevation: 0.0,
                          child: Material(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.red[900],
                            child: MaterialButton(
                              onPressed: () async {
                                dynamic result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProfileForm(
                                              user: snapshot.data,
                                            )));
                                if (result != null) {
                                  bool flg = await model.updateUser(result);
                                  if (flg) {
                                    Fluttertoast.showToast(
                                        msg: "Cập nhật diễn viên thành công");
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: "Cập nhật diễn viên thất bại");
                                  }
                                }
                              },
                              minWidth: MediaQuery.of(context).size.width / 2,
                              child: Text(
                                "Edit Profile",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                              ),
                            ),
                          )),
                    ],
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              });
        }),
      ),
    );
  }
}
