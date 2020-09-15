import 'dart:convert';

import 'package:scoped_model/scoped_model.dart';
import 'package:taydukiapp/dtos/KiepNanDTO.dart';
import 'package:taydukiapp/repositories/KiepNanRepository.dart';

class KiepNanViewModel extends Model {
  List<KiepNanDTO> kiepNanList = List<KiepNanDTO>();

  KiepNanViewModel() {
    this.getAllKiepNan();
  }

  Future<List<KiepNanDTO>>  getAllKiepNan() async {
    try {
      String data = await KiepNanRepository.apiGetAllKiepNan();
      var jsonList = json.decode(data) as List;
      kiepNanList = jsonList.map((e) => KiepNanDTO.fromJson(e)).toList();
      return kiepNanList;
    } catch (e) {
      print("error: " + e.toString());
    }
  }

  Future<bool> createKiepNan(KiepNanDTO dto) async {
    try {
      String data = await KiepNanRepository.apiCreateKiepNan(dto);
      notifyListeners();
      return true;
    } catch (e) {
      print("error: " + e.toString());
    }
    return false;
  }

  Future<bool> updateKiepNan(KiepNanDTO dto) async {
    try {
      String data = await KiepNanRepository.apiUpdateKiepNan(dto);
      notifyListeners();
      return true;
    } catch (e) {
      print("error: " + e.toString());
    }
    return false;
  }

  void deleteKiepNan(String kiepNanId) async {
    try {
      String data = await KiepNanRepository.apiDeleteKiepNan(kiepNanId);
      notifyListeners();
    } catch (e) {
      print("error: " + e.toString());
    }
  }
}
