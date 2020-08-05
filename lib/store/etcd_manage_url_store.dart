import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

final EtcdManageUrlReducer = combineReducers<String>([
  TypedReducer<String, UpdateEtcdManageUrlAction>(_updateLoaded),
]);

/// 更新全局对象时候调用的方法
String _updateLoaded(String manageUrl, action) {
  manageUrl = action.manageUrl;
  if (manageUrl == null) {
    manageUrl = '';
  }
  SharedPreferences.getInstance().then((SharedPreferences prefs) async {
    bool ok = await prefs.setString("etcd_manage_url", manageUrl);
    if (ok) {
      print('存储etcd url到磁盘成功' + manageUrl);
    }
  });
  return manageUrl;
}

class UpdateEtcdManageUrlAction {
  final String manageUrl;
  UpdateEtcdManageUrlAction(this.manageUrl);
}
