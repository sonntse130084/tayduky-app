class AuthDTO{
  String token;
  String username;
  String ten;
  String email;
  String role;

  AuthDTO({this.token, this.username, this.ten, this.email, this.role});

  AuthDTO.fromJson(Map<String, dynamic> json)
      : username = json['username'],
        token = json['token'],
        ten = json['fullName'],
        email = json['email'],
        role = json['role'];

}