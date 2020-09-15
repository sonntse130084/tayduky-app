import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:taydukiapp/constants/Contants.dart';
import 'package:taydukiapp/dtos/UsersDTO.dart';

class DienVienRepository {
  static Future<String> apiGetAllDienVien() async {
    var response = await http.get("${Constants.IP_ADDRESS}/api/Users/DienVien",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );
    if (response.statusCode == 200) {
      return response.body;
    }
  }

  static Future<String> apiCreateDienVien(UsersDTO dto) async {
    var response = await http.post("${Constants.IP_ADDRESS}/api/Users/DienVien",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(dto.toJson()));
    if (response.statusCode == 200) {
      return response.body;
    }
  }



  static Future<String> apiDeleteDienVien(String username) async {
    var response = await http.delete("${Constants.IP_ADDRESS}/api/Users/DienVien/$username",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );
    if (response.statusCode == 200) {
      return response.body;
    }
  }
}
