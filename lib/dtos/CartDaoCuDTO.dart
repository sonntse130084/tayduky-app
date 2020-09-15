
import 'package:taydukiapp/dtos/DaoCuDTO.dart';
import 'package:taydukiapp/dtos/DaoCuItem.dart';

class CartDaoCuDTO{
  List<DaoCuDTO> cart;

  int isExist(String daoCuId){
    if(cart != null){
      for(int i = 0; i < cart.length; i++){
        if(cart[i].daoCuId == daoCuId){
          return i;
        }
      }
    }
    return -1;
  }

  void addItemToCart(DaoCuDTO dto) {
    // 1. Kiểm tra xem có cái giỏ chưa
    if (this.cart == null) {
      this.cart = new List<DaoCuDTO>();
    }
    // 2. Kiểm tra xem có mặt hàng đó trong giỏ chưa
    int flgExist = isExist(dto.daoCuId);
    if (flgExist == -1) {
      this.cart.add(dto);
    }
  }



  void removeItemFromCart(DaoCuDTO dto) {
    // 1. Kiểm tra xem có giỏ không
    if (this.cart == null) {
      return;
    } else {
      int flgExist = isExist(dto.daoCuId);
      if (flgExist != -1) {
        this.cart.removeAt(flgExist);
      }
    }
  }
}