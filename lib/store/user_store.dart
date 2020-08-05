import 'dart:convert';

import 'package:etcd_manage_app/models/userinfo.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

final UserInfoReducer = combineReducers<UserInfo>([
  TypedReducer<UserInfo, UpdateUserInfoAction>(_updateLoaded),
]);

/// 如果有 UpdateUserAction 发起一个请求时
/// 就会调用到 _updateLoaded
/// _updateLoaded 这里接受一个新的userInfo，并返回
/// 更新全局对象时候调用的方法
UserInfo _updateLoaded(UserInfo userInfo, action) {
  userInfo = action.userInfo;
  if (userInfo == null) {
    return userInfo;
  }
  SharedPreferences.getInstance().then((SharedPreferences prefs) async {
    bool ok = await prefs.setString("userinfo", json.encode(userInfo.toJson()));
    if (ok) {
      print('用户信息存储主题到磁盘成功');
    }
  });
  return userInfo;
}

class UpdateUserInfoAction {
  final UserInfo userInfo;
  UpdateUserInfoAction(this.userInfo);
}
