import 'dart:convert';

import 'package:scoped_model/scoped_model.dart';
import 'package:taydukiapp/dtos/UsersDTO.dart';
import 'package:taydukiapp/repositories/DienVienRepository.dart';
import 'package:taydukiapp/repositories/UsersRepository.dart';

class DienVienViewModel extends Model {
  List<UsersDTO> dienvienList = List<UsersDTO>();

  Future<List<UsersDTO>> getAllDienVien() async {
    try {
      String data = await DienVienRepository.apiGetAllDienVien();
      var jsonList = json.decode(data) as List;
      dienvienList = jsonList.map((e) => UsersDTO.fromJson(e)).toList();
      return dienvienList;
    } catch (e) {
      print("error: " + e.toString());
    }
  }

  Future<bool> createDienVien(UsersDTO dto) async {
    try {
      String data = await DienVienRepository.apiCreateDienVien(dto);
      notifyListeners();
      return true;
    } catch (e) {
      print("error: " + e.toString());
    }
    return false;
  }

  Future<bool> updateDienVien(UsersDTO dto) async {
    try {
      String data = await UserRepository.apiUpdateUser(dto);
      notifyListeners();
      return true;
    } catch (e) {
      print("error: " + e.toString());
    }
    return false;
  }

  void deleteDienVien(String username) async {
    try {
      String data = await DienVienRepository.apiDeleteDienVien(username);
      notifyListeners();
    } catch (e) {
      print("error: " + e.toString());
    }
  }
}
