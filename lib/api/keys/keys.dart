import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:etcd_manage_app/api/api.dart';
import 'package:etcd_manage_app/models/member_info.dart';
import 'package:etcd_manage_app/models/msg.dart';
import 'package:etcd_manage_app/models/keyinfo.dart';

class Keys {
  // 获取路径下列表
  static keys(String path) async {
    Response response = await DioUtil().get(
      "/v1/keys",
      data: {'path': path},
    );
    // print(response);
    Msg msg = Msg(code: response.statusCode);
    if (response.statusCode == 400) {
      Map map = json.decode(response.toString());
      msg.msg = map["msg"];
    } else if (response.statusCode == 200) {
      msg.code = 200;
      List<KeyInfo> list = [];
      try {
        response.data.forEach((val) {
          list.add(KeyInfo.fromJson(val));
        });
      } catch (e) {}
      msg.data = list;
    }
    return msg;
  }

  // 获取一个key的值
  static val(String path) async {
    Response response = await DioUtil().get(
      "/v1/keys/val",
      data: {'path': path},
    );
    Msg msg = Msg(code: response.statusCode);
    if (response.statusCode == 400) {
      Map map = json.decode(response.toString());
      msg.msg = map["msg"];
    } else if (response.statusCode == 200) {
      msg.code = 200;
      KeyInfo keyInfo;
      try {
        keyInfo = KeyInfo.fromJson(response.data);
      } catch (e) {}
      msg.data = keyInfo;
    }
    return msg;
  }

  // 获取一个etcd服务的
  static members() async {
    Response response = await DioUtil().get(
      "/v1/keys/members",
    );
    Msg msg = Msg(code: response.statusCode);
    if (response.statusCode == 400) {
      Map map = json.decode(response.toString());
      msg.msg = map["msg"];
    } else if (response.statusCode == 200) {
      msg.code = 200;
      List<MemberInfo> list = [];
      try {
        response.data.forEach((val) {
          print('循环中');
          print(val);
          print(list);
          list.add(MemberInfo.fromJson(val));
        });
        msg.data = list;
      } catch (e) {
        print("列表处理错误 $e");
        msg.data = list;
      }
    }
    print(9);
    print(msg.data);
    return msg;
  }
}
