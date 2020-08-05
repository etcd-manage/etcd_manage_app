class UserInfo {
  int id;
  String username;
  String password;
  String email;
  int roleId;
  String token;

  UserInfo(
      {this.id,
      this.username,
      this.password,
      this.email,
      this.roleId,
      this.token});

  UserInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    password = json['password'];
    email = json['email'];
    roleId = json['role_id'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['password'] = this.password;
    data['email'] = this.email;
    data['role_id'] = this.roleId;
    data['token'] = this.token;
    return data;
  }
}
