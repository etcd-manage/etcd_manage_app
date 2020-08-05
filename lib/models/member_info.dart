class MemberInfo {
  String iD;
  String name;
  List<String> peerURLs;
  List<String> clientURLs;
  String role;
  String status;
  int dbSize;

  MemberInfo(
      {this.iD,
      this.name,
      this.peerURLs,
      this.clientURLs,
      this.role,
      this.status,
      this.dbSize});

  MemberInfo.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['name'];
    peerURLs = json['peerURLs'].cast<String>();
    clientURLs = json['clientURLs'].cast<String>();
    role = json['role'];
    status = json['status'];
    dbSize = json['db_size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['name'] = this.name;
    data['peerURLs'] = this.peerURLs;
    data['clientURLs'] = this.clientURLs;
    data['role'] = this.role;
    data['status'] = this.status;
    data['db_size'] = this.dbSize;
    return data;
  }
}
