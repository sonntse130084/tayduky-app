import 'package:taydukiapp/dtos/UsersDTO.dart';
import 'package:taydukiapp/dtos/VaiDienItem.dart';

class CartDienVienDTO {
  List<VaiDienItem> cart;

  int checkDienVien(String username) {
    if (cart != null) {
      for (int i = 0; i < cart.length; i++) {
        if (cart[i].dienvien != null) {
          if (cart[i].dienvien.username == username) {
            return i;
          }
        }
      }
    }
    return -1;
  }

  int checkVaiDien(String vaidien) {
    if (cart != null) {
      for (int i = 0; i < cart.length; i++) {
        if (cart[i].vaidien == vaidien) {
          return i;
        }
      }
    }
    return -1;
  }

  bool addItemToCart(String vaidien, UsersDTO UsersDTO) {
    // 1. Kiểm tra xem có cái giỏ chưa
    if (this.cart == null) {
      this.cart = new List<VaiDienItem>();
    }
    // 2. Kiểm tra xem có mặt hàng đó trong giỏ chưa
    int flgExist1 = checkVaiDien(vaidien);
    int flgExist2 = checkDienVien(UsersDTO.username);
    if (flgExist1 == -1 && flgExist2 == -1) {
      this.cart.add(new VaiDienItem(vaidien: vaidien, dienvien: UsersDTO));
    }
  }

  bool addVaiDienItemToCart(VaiDienItem vaiDienItem) {
    // 1. Kiểm tra xem có cái giỏ chưa
    if (this.cart == null) {
      this.cart = new List<VaiDienItem>();
    }
    // 2. Kiểm tra xem có mặt hàng đó trong giỏ chưa
    int flgExist1 = checkVaiDien(vaiDienItem.vaidien);
    int flgExist2 = -1;
    if (vaiDienItem.dienvien != null) {
      flgExist2 = checkDienVien(vaiDienItem.dienvien.username);
    }
    if (flgExist1 == -1 && flgExist2 == -1) {
      this.cart.add(new VaiDienItem(
          vaidien: vaiDienItem.vaidien, dienvien: vaiDienItem.dienvien));
    }
  }

  void updateDienVienForVaiDien(String vaidien, VaiDienItem vaiDienItem) {
    if (this.cart != null) {
      {
        int flgExist = checkVaiDien(vaidien);
        if (flgExist != -1) {
          this.cart[flgExist].vaidien = vaiDienItem.vaidien;
          this.cart[flgExist].dienvien = vaiDienItem.dienvien;
        }
      }
    }
  }

  void removeItem(String vaidien) {
    if (this.cart != null) {
      {
        int flgExist = checkVaiDien(vaidien);
        if (flgExist != -1) {
          this.cart.removeAt(flgExist);
        }
      }
    }
  }
}
