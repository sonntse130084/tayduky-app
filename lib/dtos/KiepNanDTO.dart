import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taydukiapp/dtos/CartDaoCuDTO.dart';
import 'package:taydukiapp/dtos/CartDienVienDTO.dart';
import 'package:taydukiapp/dtos/DaoCuDTO.dart';
import 'package:taydukiapp/dtos/VaiDienItem.dart';
import 'package:taydukiapp/pages/CartDienVienPage.dart';

class KiepNanDTO {
  String kiepNanId;
  String kiepNanNm;
  String diaDiemQuay;
  String thoiGianBatDau;
  String thoiGianKetThuc;
  int soLanQuay;
  String moTa;
  String dacTaVaiDien;
  CartDaoCuDTO cartDaoCuDTO;
  CartDienVienDTO cartDienVienDTO;
  String implementer;

  KiepNanDTO(
      {this.kiepNanId,
      this.kiepNanNm,
      this.diaDiemQuay,
      this.thoiGianBatDau,
      this.thoiGianKetThuc,
      this.soLanQuay,
      this.moTa,
      this.dacTaVaiDien,
      this.cartDaoCuDTO,
      this.cartDienVienDTO,
      this.implementer});

//  UsersDTO.fromJson(Map<String, dynamic> json)
//      : kiepNanId = json['username'],
//        kiepNanNm = json['ten'],
//        diaDiemQuay = json['diaDiemQuay'],
//        thoiGianBatDau = json['thoiGianBatDau'],
//        thoiGianKetThuc = json['thoiGianKetThuc'],
//        moTa = json['mota'],
//        soLanQuay = json['soLanQuay'],
//        dacTaVaiDien = json['dacTaVaiDien'],
//        cartDaoCuDTO.cart = json['daoCuItems'] .map((e) => DaoCuDTO.fromJson(e)).toList(),
//        cartUsersDTO = json['soLanQuay'];

  factory KiepNanDTO.fromJson(Map<String, dynamic> json) {
    CartDaoCuDTO cartDaoCu = CartDaoCuDTO();
    CartDienVienDTO cartDienVien = CartDienVienDTO();
    if (json['daoCuItems'] != null) {
      var x = json['daoCuItems'] as List;
      cartDaoCu.cart = x.map((e) => DaoCuDTO.fromJson(e)).toList();
    }
    if (json['vaiDienItems'] != null) {
      var y = json['vaiDienItems'] as List;
      cartDienVien.cart = y.map((e) => VaiDienItem.fromJson(e)).toList();
    }

    String batdau = json['thoiGianBatDau'];
    DateTime startTime = DateTime.parse(batdau);
    batdau = DateFormat("dd/MM/yyyy").format(startTime);

    String ketthuc = json['thoiGianKetThuc'];
    DateTime endTime = DateTime.parse(ketthuc);
    ketthuc = DateFormat("dd/MM/yyyy").format(endTime);

    KiepNanDTO dto = KiepNanDTO(
        kiepNanId: json['kiepNanId'],
        kiepNanNm: json['ten'],
        diaDiemQuay: json['diaDiemQuay'],
        thoiGianBatDau: batdau,
        thoiGianKetThuc: ketthuc,
        moTa: json['mota'],
        soLanQuay: json['soLanQuay'],
        dacTaVaiDien: json['dacTaVaiDien'],
        cartDaoCuDTO: cartDaoCu,
        cartDienVienDTO: cartDienVien);
    return dto;
  }

  Map<String, dynamic> toJson() {
    DateTime start = DateFormat("dd/MM/yyyy").parse(thoiGianBatDau);
    DateTime end = DateFormat("dd/MM/yyyy").parse(thoiGianKetThuc);
    return {
      'kiepNanId': kiepNanId,
      'ten': kiepNanNm,
      'diaDiemQuay': diaDiemQuay,
      'thoiGianBatDau': DateFormat("yyyy-MM-ddThh:mm:ss").format(start),
      'thoiGianKetThuc': DateFormat("yyyy-MM-ddThh:mm:ss").format(end),
      'moTa': moTa,
      "soLanQuay": soLanQuay,
      "dacTaVaiDien": dacTaVaiDien,
      'daoCuItems': cartDaoCuDTO.cart != null ? cartDaoCuDTO.cart : [],
      'vaiDienItems': cartDienVienDTO.cart != null ? cartDienVienDTO.cart : [],
      'implementer': implementer,
    };
  }

//  Map<String, dynamic> toJson() => {
//    'kiepNanId': kiepNanId,
//    'ten': kiepNanNm,
//    'diaDiemQuay': diaDiemQuay,
//    'thoiGianBatDau': DateFormat("dd/MM/yyyy").parse(thoiGianBatDau),
//    'thoiGianKetThuc': DateFormat("dd/MM/yyyy").parse(thoiGianKetThuc),
//    'moTa': moTa,
//    'daoCuItems': cartDaoCuDTO.cart != null ? cartDaoCuDTO.cart : [],
//    'vaiDienItems':
//    cartUsersDTO.cart != null ? cartUsersDTO.cart : [],
//    'implementer': "sonmap",
//  };
}
