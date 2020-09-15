import 'package:intl/intl.dart';

class ThongKeDaoCuDTO {
  String trangThai;
  String thoiGianBatDau;
  String thoiGianKetThuc;

  ThongKeDaoCuDTO({this.trangThai, this.thoiGianBatDau, this.thoiGianKetThuc});

  Map<String, String> toJson() {
    String stringFrom = "";
    String stringTo = "";
    if (thoiGianBatDau != null && thoiGianBatDau.isNotEmpty) {
      DateTime from = DateFormat("dd/MM/yyyy").parse(thoiGianBatDau);
      stringFrom = DateFormat("yyyy-MM-ddThh:mm:ss").format(from);
    }
    if (thoiGianKetThuc != null && thoiGianKetThuc.isNotEmpty) {
      DateTime to = DateFormat("dd/MM/yyyy").parse(thoiGianKetThuc);
      stringTo = DateFormat("yyyy-MM-ddThh:mm:ss").format(to);
    }
    return {
      'TimeFrom': stringFrom,
      'TimeTo': stringTo,
      'TrangThai': trangThai,
    };
  }
}
