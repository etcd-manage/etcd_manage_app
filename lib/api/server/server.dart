import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:etcd_manage_app/api/api.dart';
import 'package:etcd_manage_app/models/msg.dart';
import 'package:etcd_manage_app/models/server_info.dart';

class Server {
  // 获取配置的etcd服务列表
  static servers() async {
    Response response = await DioUtil().get(
      "/v1/server",
    );
    Msg msg = Msg(code: response.statusCode);
    if (response.statusCode == 400) {
      Map map = json.decode(response.toString());
      msg.msg = map["msg"];
    } else if (response.statusCode == 200) {
      msg.code = 200;
      List<ServerInfo> list = [];
      try {
        response.data.forEach((val) {
          list.add(ServerInfo.fromJson(val));
        });
      } catch (e) {}
      msg.data = list;
    }
    return msg;
  }
}