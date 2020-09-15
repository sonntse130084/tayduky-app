import 'dart:convert';

import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taydukiapp/dtos/AuthDTO.dart';
import 'package:taydukiapp/dtos/UsersDTO.dart';
import 'package:taydukiapp/repositories/UsersRepository.dart';

class UsersViewModel extends Model {
  UsersDTO usersDTO;

  UsersViewModel({this.usersDTO});

  Future<String> login(String username, String password) async {
    try {
      var data = await UserRepository.apiLoginAuth(username, password);
      return data;
    } catch (e) {
      print("Login error: " + e.toString());
    }
  }

  Future<UsersDTO> getUsers(String username) async {
    try {
      var data = await UserRepository.apiGetUser(username);
      var jsonData = json.decode(data);
      this.usersDTO = UsersDTO.fromJson(jsonData);
      return this.usersDTO;
    } catch (e) {
      print("Login error: " + e.toString());
    }
  }

  Future<UsersDTO> checkUser(String username) async {
    try {
      var data = await UserRepository.apiCheckUser(username);
      var jsonData = json.decode(data);
      this.usersDTO = UsersDTO.fromJson(jsonData);
      return this.usersDTO;
    } catch (e) {
      print("Login error: " + e.toString());
    }
  }

  Future<bool> updateUser(UsersDTO dto) async {
    try {
      String data = await UserRepository.apiUpdateUser(dto);
      notifyListeners();
      return true;
    } catch (e) {
      print("error: " + e.toString());
    }
    return false;
  }


  Future<UsersDTO> getUsersSession() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      AuthDTO authDTO = AuthDTO.fromJson(json.decode(prefs.getString("UserInfo")));
      var data = await UserRepository.apiGetUser(authDTO.username);
      var jsonData = json.decode(data);
      this.usersDTO = UsersDTO.fromJson(jsonData);
      return this.usersDTO;
    } catch (e) {
      print("Login error: " + e.toString());
    }
  }
}
