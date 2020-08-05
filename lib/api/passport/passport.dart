import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:etcd_manage_app/api/api.dart';
import 'package:etcd_manage_app/models/msg.dart';
import 'package:etcd_manage_app/models/userinfo.dart';

class Passport {
  // 登录
  static login(String username, String password) async {
    Response response = await DioUtil().post(
      "/v1/passport/login",
      data: {'username': username, 'password': password},
      options: Options(headers: {"Content-Type": "application/json;charset=UTF-8"}),
    );
    print(response);
    Msg msg = Msg(code: 400);
    if (response.statusCode == 400) {
      Map map = json.decode(response.toString());
      msg.msg = map["msg"];
    } else if (response.statusCode == 200) {
      msg.code = 200;
      msg.data = UserInfo.fromJson(json.decode(response.toString()));
    }
    return msg;
  }
}
