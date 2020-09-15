import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:taydukiapp/constants/Contants.dart';
import 'package:taydukiapp/dtos/DaoCuDTO.dart';
import 'package:taydukiapp/dtos/ThongKeDaoCuDTO.dart';

class DaoCuRepository {
  static Future<String> apiGetAllDaoCu(String action) async {
    var uri = Uri.http('${Constants.IP}:8085', '/api/DaoCu');
    var response = await http.get(uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );
    if (response.statusCode == 200) {
      return response.body;
    }
  }

  static Future<String> apiThongKeDaoCu(ThongKeDaoCuDTO thongKeDaoCuDTO) async {
    var uri = Uri.http('${Constants.IP}:8085', '/api/DaoCu/ThongKeDaoCu', thongKeDaoCuDTO.toJson());
    var response = await http.get(uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );
    if (response.statusCode == 200) {
      return response.body;
    }
  }

  static Future<String> apiCreateDaoCu(DaoCuDTO dto) async {
    var response = await http.post("${Constants.IP_ADDRESS}/api/DaoCu",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(dto.toJson()));
    if (response.statusCode == 200) {
      return response.body;
    }
  }

  static Future<String> apiUpdateDaoCu(DaoCuDTO dto) async {
    var response = await http.put("${Constants.IP_ADDRESS}/api/DaoCu/${dto.daoCuId}",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(dto.toJson()));
    if (response.statusCode == 200) {
      return response.body;
    }
  }

  static Future<String> apiDeleteDaoCu(String daoCuId) async {
    var response = await http.delete("${Constants.IP_ADDRESS}/api/DaoCu/$daoCuId",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );
    if (response.statusCode == 200) {
      return response.body;
    }
  }
}
