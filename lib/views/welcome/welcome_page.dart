import 'dart:convert';

import 'package:etcd_manage_app/api/api.dart';
import 'package:etcd_manage_app/i18n/i18n.dart';
import 'package:etcd_manage_app/models/server_info.dart';
import 'package:etcd_manage_app/models/userinfo.dart';
import 'package:etcd_manage_app/store/etcd_manage_url_store.dart';
import 'package:etcd_manage_app/store/etcd_store.dart';
import 'package:etcd_manage_app/store/lang_store.dart';
import 'package:etcd_manage_app/store/locale_store.dart';
import 'package:etcd_manage_app/store/store.dart';
import 'package:etcd_manage_app/store/theme_store.dart';
import 'package:etcd_manage_app/store/user_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:etcd_manage_app/api/const.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();
    initStore();
    new Future.delayed(new Duration(milliseconds: 300), () async{
      Navigator.pushReplacementNamed(context, '/tabs');
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  // 初始化状态数据
  void initStore() async {
    final SharedPreferences prefs = await _prefs;
    String userStr = prefs.getString("userinfo");
    if (userStr != null && userStr != "") {
      try {
        var userinfo = UserInfo.fromJson(json.decode(userStr));
        StoreProvider.of<ZState>(context)
            .dispatch(new UpdateUserInfoAction(userinfo));
      } catch (e) {}
    }
    // 选择的etcd id
    String serverInfoStr = prefs.getString("server_info");
    if (serverInfoStr != null && serverInfoStr != "") {
      try {
        var serverInfo = ServerInfo.fromJson(json.decode(serverInfoStr));
        StoreProvider.of<ZState>(context)
            .dispatch(new UpdateEtcdServerAction(serverInfo));
      } catch (e) {}
    }
    String locale = prefs.getString("locale");
    I18N lang = I18N();
    if (locale == 'zh') {
      lang.init('zh');
    } else {
      lang.init('en');
    }
    String theme = prefs.getString("theme");
    String manageUrl = prefs.getString("etcd_manage_url");
    StoreProvider.of<ZState>(context).dispatch(new UpdateLocaleAction(locale));
    StoreProvider.of<ZState>(context).dispatch(new UpdateLangAction(lang));
    StoreProvider.of<ZState>(context).dispatch(new UpdateThemeAction(theme));
    StoreProvider.of<ZState>(context).dispatch(new UpdateEtcdManageUrlAction(manageUrl));
    // 初始化http请求库
    manageBaseAddress = manageUrl;
    DioUtil();
  }

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<ZState>(builder: (context, store) {
      return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Stack(
          children: <Widget>[
            Center(
              child: Container(
                child: new Image(
                  image: AssetImage('assets/images/launch.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
