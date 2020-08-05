class ServerInfo {
  int id;
  String version;
  String name;
  String address;
  String tlsEnable;
  String certFile;
  String keyFile;
  String caFile;
  String username;
  String password;
  String desc;
  String createdAt;
  String updatedAt;

  ServerInfo(
      {this.id,
      this.version,
      this.name,
      this.address,
      this.tlsEnable,
      this.certFile,
      this.keyFile,
      this.caFile,
      this.username,
      this.password,
      this.desc,
      this.createdAt,
      this.updatedAt});

  ServerInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    version = json['version'];
    name = json['name'];
    address = json['address'];
    tlsEnable = json['tls_enable'];
    certFile = json['cert_file'];
    keyFile = json['key_file'];
    caFile = json['ca_file'];
    username = json['username'];
    password = json['password'];
    desc = json['desc'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['version'] = this.version;
    data['name'] = this.name;
    data['address'] = this.address;
    data['tls_enable'] = this.tlsEnable;
    data['cert_file'] = this.certFile;
    data['key_file'] = this.keyFile;
    data['ca_file'] = this.caFile;
    data['username'] = this.username;
    data['password'] = this.password;
    data['desc'] = this.desc;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
