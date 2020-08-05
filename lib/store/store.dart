import 'package:etcd_manage_app/i18n/i18n.dart';
import 'package:etcd_manage_app/models/server_info.dart';
import 'package:etcd_manage_app/models/userinfo.dart';
import 'package:etcd_manage_app/store/etcd_manage_url_store.dart';
import 'package:etcd_manage_app/store/etcd_store.dart';
import 'package:etcd_manage_app/store/lang_store.dart';
import 'package:etcd_manage_app/store/locale_store.dart';
import 'package:etcd_manage_app/store/theme_store.dart';
import 'package:etcd_manage_app/store/user_store.dart';

class ZState {
  String locale = "en"; // 语言
  I18N lang;
  UserInfo userInfo; // 用户信息
  ServerInfo serverInfo; // 用户选中
  String theme = "auto"; // 语言
  String manageUrl = ""; // etcd 管理服务端地址

  ZState(
      {this.locale,
      this.lang,
      this.userInfo,
      this.serverInfo,
      this.theme,
      this.manageUrl});
}

// 创建store使用
ZState appReducer(ZState state, action) {
  return ZState(
    // 将全局对象和action关联
    locale: LocaleReducer(state.locale, action),
    lang: LangReducer(state.lang, action),
    userInfo: UserInfoReducer(state.userInfo, action),
    serverInfo: EtcdServerReducer(state.serverInfo, action),
    theme: ThemeReducer(state.theme, action),
    manageUrl: EtcdManageUrlReducer(state.manageUrl, action),
  );
}
