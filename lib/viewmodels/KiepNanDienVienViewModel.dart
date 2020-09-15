import 'dart:convert';

import 'package:scoped_model/scoped_model.dart';
import 'package:taydukiapp/dtos/KiepNanDTO.dart';
import 'package:taydukiapp/repositories/KiepNanDienVienRepository.dart';
import 'package:taydukiapp/viewmodels/UsersViewModels.dart';

class KiepNanDienVienViewModel extends Model {
  List<KiepNanDTO> kiepNanList = List<KiepNanDTO>();

  Future<List<KiepNanDTO>> getKiepNanOfDienVien({String isFinished}) async {
    try {
      UsersViewModel model = UsersViewModel();
      await model.getUsersSession();
      String data = await KiepNanDienVienRepository.apiGetKiepNanOfDienVien(
          isFinished, model.usersDTO.username);
      var jsonList = json.decode(data) as List;
      kiepNanList = jsonList.map((e) => KiepNanDTO.fromJson(e)).toList();
      return kiepNanList;
    } catch (e) {
      print("error: " + e.toString());
    }
  }

  Future<String> getVaiDien({String kiepNanId}) async {
    try {
      UsersViewModel model = UsersViewModel();
      await model.getUsersSession();
      String data = await KiepNanDienVienRepository.apiGetVaiDien(
          kiepNanId, model.usersDTO.username);
      return data;
    } catch (e) {
      print("error: " + e.toString());
    }
  }
}
