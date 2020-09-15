import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:taydukiapp/constants/Contants.dart';
import 'package:taydukiapp/dtos/KiepNanDTO.dart';

class KiepNanRepository {
  static Future<String> apiGetAllKiepNan() async {
    var response = await http.get("${Constants.IP_ADDRESS}/api/KiepNan",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );
    if (response.statusCode == 200) {
      return response.body;
    }
  }

  static Future<String> apiCreateKiepNan(KiepNanDTO dto) async {
    var json = dto.toJson();
    print(json);
    var response = await http.post("${Constants.IP_ADDRESS}/api/KiepNan",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(json));
    print("Response code ${response.statusCode}");
    if (response.statusCode == 200) {
      return response.body;
    }
  }

  static Future<String> apiUpdateKiepNan(KiepNanDTO dto) async {
    var json = dto.toJson();
    var response = await http.put("${Constants.IP_ADDRESS}/api/KiepNan/${dto.kiepNanId}",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(json));
    if (response.statusCode == 200) {
      return response.body;
    }
  }

  static Future<String> apiDeleteKiepNan(String kiepNanId) async {
    var response = await http.delete("${Constants.IP_ADDRESS}/api/KiepNan/$kiepNanId",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );
    if (response.statusCode == 200) {
      return response.body;
    }
  }
}
