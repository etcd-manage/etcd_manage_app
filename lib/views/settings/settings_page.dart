import 'package:etcd_manage_app/api/server/server.dart';
import 'package:etcd_manage_app/components/app_bar.dart';
import 'package:etcd_manage_app/models/msg.dart';
import 'package:etcd_manage_app/models/server_info.dart';
import 'package:etcd_manage_app/models/userinfo.dart';
import 'package:etcd_manage_app/store/etcd_store.dart';
import 'package:etcd_manage_app/store/store.dart';
import 'package:etcd_manage_app/store/user_store.dart';
import 'package:etcd_manage_app/views/settings/about_page.dart';
import 'package:etcd_manage_app/views/settings/donation_page.dart';
import 'package:etcd_manage_app/views/settings/help_page.dart';
import 'package:etcd_manage_app/views/settings/lang_page.dart';
import 'package:etcd_manage_app/views/settings/theme_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:etcd_manage_app/i18n/i18n.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    getServers();
  }

  I18N lang; // 语言
  List<ServerInfo> etcdServers = [];

  // 获取etcd服务列表
  void getServers() async {
    Msg msg = await Server.servers();
    if (msg.code == 401) {
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }
    if (msg.code != 200) {
      Fluttertoast.showToast(
        msg: msg.msg,
        gravity: ToastGravity.CENTER,
      );
      return;
    }
    etcdServers = msg.data;
    if (mounted) {
      setState(() {});
    }
  }

  void _showEtcdServersPicker() {
    List<dynamic> list = [];
    if (etcdServers == null || etcdServers.length == 0) {
      Fluttertoast.showToast(
        msg: lang.get('setings.switch_etcd_alert'),
        gravity: ToastGravity.CENTER,
      );
      return;
    }
    etcdServers.forEach((val) {
      list.add(val.name);
    });
    new Picker(
        adapter: PickerDataAdapter<String>(pickerdata: list),
        changeToFirst: true,
        hideHeader: false,
        cancelText: lang.get('public.cancel'),
        confirmText: lang.get('public.confirm'),
        onConfirm: (Picker picker, List value) {
          // 切换etcd服务
          StoreProvider.of<ZState>(context)
              .dispatch(new UpdateEtcdServerAction(etcdServers[value[0]]));

          print(value.toString());
          print(picker.adapter.text);
        }).showModal(this.context);
  }

  void _logout() {
    // 存储用户信息
    StoreProvider.of<ZState>(context)
        .dispatch(new UpdateUserInfoAction(new UserInfo()));
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<ZState>(builder: (context, store) {
      lang = StoreProvider.of<ZState>(context).state.lang;
      UserInfo userinfo = StoreProvider.of<ZState>(context).state.userInfo;
      if (userinfo == null) {
        userinfo = UserInfo();
      }
      if (userinfo.email == '' || userinfo.email == null) {
        userinfo.email = 'Email not set';
      }
      // print(userinfo.toJson());
      return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: ZAppBar(
          preferredSize: Size.fromHeight(40),
          appBar: AppBar(
            elevation: 0,
            title: Text(
              lang.get('public.setings'),
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            centerTitle: true,
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Container(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      backgroundImage: AssetImage('assets/images/logo.png'),
                    ),
                    title: Text(
                      userinfo.username ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyText1.color,
                      ),
                    ),
                    subtitle: Text(
                      userinfo.email ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.caption.color,
                      ),
                    ),
                  ),
                ),
              ),
              // 以下设置项
              Container(
                height: 10,
              ),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        lang.get('setings.switch_etcd'),
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).textTheme.bodyText1.color,
                        ),
                      ),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () {
                        _showEtcdServersPicker();
                      },
                    ),
                    Divider(
                      height: 1.0,
                      indent: 0.0,
                    ),
                    ListTile(
                      title: Text(
                        lang.get('setings.lang'),
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).textTheme.bodyText1.color,
                        ),
                      ),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => LangPage()));
                      },
                    ),
                    Divider(
                      height: 1.0,
                      indent: 0.0,
                    ),
                    ListTile(
                      title: Text(
                        lang.get('setings.theme'),
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).textTheme.bodyText1.color,
                        ),
                      ),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ThemePage()));
                      },
                    ),
                  ],
                ),
              ),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        lang.get('setings.about'),
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).textTheme.bodyText1.color,
                        ),
                      ),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AboutPage()));
                      },
                    ),
                    Divider(
                      height: 1.0,
                      indent: 0.0,
                    ),
                    ListTile(
                      title: Text(
                        lang.get('setings.help'),
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).textTheme.bodyText1.color,
                        ),
                      ),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => HelpPage()));
                      },
                    ),
                  ],
                ),
              ),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ListTile(
                  title: Text(
                    lang.get('setings.donation'),
                    style: TextStyle(
                      color: Colors.green[400],
                    ),
                  ),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DonationPage()));
                  },
                ),
              ),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ListTile(
                  title: Text(
                    lang.get('setings.logout'),
                    style: TextStyle(
                      color: Colors.redAccent,
                    ),
                  ),
                  onTap: () {
                    _logout();
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
