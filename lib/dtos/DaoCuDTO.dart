class DaoCuDTO {
  String daoCuId;
  String ten;
  String dacTa;
  String hinhAnh;
  String trangThai;
  String implementer;

  DaoCuDTO(
      {this.daoCuId,
      this.ten,
      this.dacTa,
      this.hinhAnh,
      this.trangThai,
      this.implementer});

  DaoCuDTO.fromJson(Map<String, dynamic> json)
      : daoCuId = json['daoCuId'],
        ten = json['ten'],
        dacTa = json['dacTa'],
        hinhAnh = json['hinhAnh'],
        trangThai = json['trangThai'];

//  factory DaoCuDTO.fromJson(Map<String, dynamic> json) {
//    return DaoCuDTO(
//        daoCuId: json['daoCuId'],
//        ten: json['ten'],
//        dacTa: json['dacTa'],
//        hinhAnh: json['hinhAnh'],
//        trangThai: json['trangThai']);
//  }

  Map<String, dynamic> toJson() => {
        'daoCuId': daoCuId,
        'ten': ten,
        'dacTa': dacTa,
        'hinhAnh': hinhAnh,
        'trangThai': trangThai,
        'implementer': implementer
      };
}
