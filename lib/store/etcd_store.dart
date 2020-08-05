import 'dart:convert';

import 'package:etcd_manage_app/models/server_info.dart';
import 'package:etcd_manage_app/models/userinfo.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

final EtcdServerReducer = combineReducers<ServerInfo>([
  TypedReducer<ServerInfo, UpdateEtcdServerAction>(_updateLoaded),
]);

ServerInfo _updateLoaded(ServerInfo serverInfo, action) {
  serverInfo = action.serverInfo;
  if (serverInfo == null) {
    return serverInfo;
  }
  SharedPreferences.getInstance().then((SharedPreferences prefs) async {
    bool ok = await prefs.setString("server_info", json.encode(serverInfo.toJson()));
    if (ok) {
      print('etcd server信息存储主题到磁盘成功');
    }
  });
  return serverInfo;
}

class UpdateEtcdServerAction {
  final ServerInfo serverInfo;
  UpdateEtcdServerAction(this.serverInfo);
}
