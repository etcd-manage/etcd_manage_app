class KeyInfo {
  bool isDir;
  String path;
  String name;
  String value;
  int version;

  KeyInfo({this.isDir, this.path, this.name, this.value, this.version});

  KeyInfo.fromJson(Map<String, dynamic> json) {
    isDir = json['is_dir'];
    path = json['path'];
    name = json['name'];
    value = json['value'];
    version = json['version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_dir'] = this.isDir;
    data['path'] = this.path;
    data['name'] = this.name;
    data['value'] = this.value;
    data['version'] = this.version;
    return data;
  }
}
