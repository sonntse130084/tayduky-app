import 'dart:convert';

import 'package:scoped_model/scoped_model.dart';
import 'package:taydukiapp/dtos/DaoCuDTO.dart';
import 'package:taydukiapp/dtos/ThongKeDaoCuDTO.dart';
import 'package:taydukiapp/repositories/DaoCuRepository.dart';

class DaoCuViewModel extends Model {
  List<DaoCuDTO> daocuList = List<DaoCuDTO>();
  List<DaoCuDTO> cart;

  DaoCuViewModel({this.cart});

  Future<List<DaoCuDTO>> getAllDaoCu(String action) async {
    try {
      String data = await DaoCuRepository.apiGetAllDaoCu(action);
      var jsonList = json.decode(data) as List;
      daocuList = jsonList.map((e) => DaoCuDTO.fromJson(e)).toList();
      if (action == "Shopping") {
        if (this.cart != null) {
          this.addDaoCuFromCart();
        }
      }
      return daocuList;
    } catch (e) {
      print("error: " + e.toString());
    }
  }

  Future<List<DaoCuDTO>> thongKeDaoCu(
      String action, ThongKeDaoCuDTO thongKeDaoCuDTO) async {
    try {
      if (thongKeDaoCuDTO != null) {
        String data = await DaoCuRepository.apiThongKeDaoCu(thongKeDaoCuDTO);
        var jsonList = json.decode(data) as List;
        daocuList = jsonList.map((e) => DaoCuDTO.fromJson(e)).toList();
        if (action == "Shopping") {
          if (this.cart != null) {
            this.addDaoCuFromCart();
          }
        }
        return daocuList;
      }
      return null;
    } catch (e) {
      print("error: " + e.toString());
    }
  }

  void addDaoCuFromCart() {
    for (DaoCuDTO dto in this.cart) {
      if (checkExist(dto) == -1) {
        daocuList.add(dto);
      }
    }
  }

  Future<bool> createDaoCu(DaoCuDTO dto) async {
    try {
      String data = await DaoCuRepository.apiCreateDaoCu(dto);
      notifyListeners();
      return true;
    } catch (e) {
      print("error: " + e.toString());
    }
    return false;
  }

  Future<bool> updateDaoCu(DaoCuDTO dto) async {
    try {
      String data = await DaoCuRepository.apiUpdateDaoCu(dto);
      notifyListeners();
      return true;
    } catch (e) {
      print("error: " + e.toString());
    }
    return false;
  }

  void deleteDaoCu(String daoCuId) async {
    try {
      String data = await DaoCuRepository.apiDeleteDaoCu(daoCuId);
      notifyListeners();
    } catch (e) {
      print("error: " + e.toString());
    }
  }

  int checkExist(DaoCuDTO dto) {
    if (daocuList != null) {
      for (int i = 0; i < daocuList.length; i++) {
        if (daocuList[i].daoCuId == dto.daoCuId) {
          return i;
        }
      }
    }
    return -1;
  }
}
