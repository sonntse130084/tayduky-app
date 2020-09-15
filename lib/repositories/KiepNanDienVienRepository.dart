import 'package:taydukiapp/constants/Contants.dart';
import 'package:http/http.dart' as http;

class KiepNanDienVienRepository{
  static Future<String> apiGetKiepNanOfDienVien(String isFinished, String username) async {
    var response = await http.get("${Constants.IP_ADDRESS}/api/KiepNanDienVien?isFinished=${isFinished}&dienvienUsername=${username}",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );
    if (response.statusCode == 200) {
      return response.body;
    }
  }
  static Future<String> apiGetVaiDien(String kiepNanId, String username) async {
    var response = await http.get("${Constants.IP_ADDRESS}/api/KiepNanDienVien/vaidien?kiepNanId=${kiepNanId}&dienvienUsername=${username}",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );
    if (response.statusCode == 200) {
      return response.body;
    }
  }
}