import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:taydukiapp/constants/Contants.dart';
import 'package:taydukiapp/dtos/UsersDTO.dart';

class UserRepository {
  static Future<String> apiGetUser(String username) async {
    var response = await http.get("${Constants.IP_ADDRESS}/api/Users/${username}",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );
    if (response.statusCode == 200) {
      return response.body;
    }
  }
  static Future<String> apiCheckUser(String username) async {
    var response = await http.get("${Constants.IP_ADDRESS}/api/Users/Key/${username}",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );
    if (response.statusCode == 200) {
      return response.body;
    }
  }

  static Future<String> apiUpdateUser(UsersDTO dto) async {
    var response = await http.put("${Constants.IP_ADDRESS}/api/Users/${dto.username}",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(dto.toJson()));
    if (response.statusCode == 200) {
      return response.body;
    }
  }

  static Future<String> apiLoginAuth(String username, String password) async {
    var response = await http.post("${Constants.IP_ADDRESS}/api/Auth",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: json.encode(
            <String, String>{'username': username, 'password': password}));
    if (response.statusCode == 200) {
      return response.body;
    }
  }
}
