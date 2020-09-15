import 'package:taydukiapp/dtos/UsersDTO.dart';

class VaiDienItem {
  String vaidien;
  UsersDTO dienvien;

  VaiDienItem({this.vaidien, this.dienvien});

//  factory VaiDienItem.fromJson(Map<String, dynamic> json) {
//    return VaiDienItem(
//        vaidien: json['vaidien'],
//        dienvien:  UsersDTO.fromJson(json['dienvien']),);
//  }
  VaiDienItem.fromJson(Map<String, dynamic> json)
      : vaidien = json['vaidien'],
        dienvien = UsersDTO.fromJson(json['dienvien']);

  Map<String, dynamic> toJson() => {
    'vaidien': vaidien,
    'dienvien': dienvien.toJson(),
  };
}
