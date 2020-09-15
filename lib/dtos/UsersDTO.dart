class UsersDTO {
  String username;
  String password;
  String ten;
  String moTa;
  String hinhAnh;
  String soDienThoai;
  String email;
  String diaChi;
  String role;
  String implementer;

  UsersDTO(
      {this.username,
      this.password,
      this.ten,
      this.moTa,
      this.hinhAnh,
      this.soDienThoai,
      this.email,
      this.diaChi,
      this.role,
      this.implementer});

  UsersDTO.fromJson(Map<String, dynamic> json)
      : username = json['username'],
        ten = json['fullName'],
        soDienThoai = json['phonenumber'],
        email = json['email'],
        diaChi = json['address'],
        moTa = json['description'],
        hinhAnh = json['photo'],
        role = json['roleId'];

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
        'fullName': ten,
        'phonenumber': soDienThoai,
        'email': email,
        'address': diaChi,
        'description': moTa,
        'photo': hinhAnh,
        'address': diaChi,
        'implementer': implementer,
      };
}
