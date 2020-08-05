import 'package:etcd_manage_app/api/passport/passport.dart';
import 'package:etcd_manage_app/i18n/i18n.dart';
import 'package:etcd_manage_app/models/msg.dart';
import 'package:etcd_manage_app/store/etcd_manage_url_store.dart';
import 'package:etcd_manage_app/store/store.dart';
import 'package:etcd_manage_app/store/user_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:etcd_manage_app/api/const.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String username = '';
  String password = '';
  String etcdManageUrl = '';

  I18N lang;

  @override
  void initState() {
    super.initState();
  }

  // 登录点击
  void onLogin() async {
    if (username?.length == 0 || password?.length == 0) {
      Fluttertoast.showToast(
          msg: lang.get('login.warn_username_password'),
          gravity: ToastGravity.CENTER,
          fontSize: 16.0);
      return;
    }
    // Fluttertoast.showToast(msg: etcdManageUrl,gravity: ToastGravity.CENTER, fontSize: 16.0);
    if (etcdManageUrl != null && etcdManageUrl != '') {
      bool isHttp = etcdManageUrl.contains('http');
      if (isHttp == false) {
        Fluttertoast.showToast(
            msg: lang.get('login.warn_http'),
            gravity: ToastGravity.CENTER,
            fontSize: 16.0);
        return;
      }
      manageBaseAddress = etcdManageUrl;
    }
    Msg msg = await Passport.login(username, password);
    if (msg.code != 200) {
      Fluttertoast.showToast(
          msg: msg.msg ?? lang.get('public.unknown_err'),
          gravity: ToastGravity.CENTER,
          fontSize: 16.0);
      return;
    }
    // 存储用户信息
    StoreProvider.of<ZState>(context)
        .dispatch(new UpdateUserInfoAction(msg.data));
    // 存储服务地址
    print(etcdManageUrl);
    if (etcdManageUrl != null && etcdManageUrl != '') {
      bool isHttp = etcdManageUrl.contains('http');
      if (isHttp == false) {}
      StoreProvider.of<ZState>(context)
          .dispatch(new UpdateEtcdManageUrlAction(etcdManageUrl));
    }
    // 进入tab页面
    Navigator.pushReplacementNamed(context, '/tabs');
  }

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<ZState>(builder: (context, store) {
      String initialEtcdManageUrl =
          StoreProvider.of<ZState>(context).state.manageUrl;
      print(initialEtcdManageUrl);
      if (initialEtcdManageUrl == null || initialEtcdManageUrl == "") {
        initialEtcdManageUrl = ApiConfig.BaseAddress;
      }
      lang = StoreProvider.of<ZState>(context).state.lang;
      return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Center(
          child: ListView(
            children: <Widget>[
              Container(
                height: 150,
                child: Center(
                  child: Image.asset("assets/images/logo.png",
                      width: 90, height: 90),
                ),
              ),
              Container(
                padding: new EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        initialValue: initialEtcdManageUrl,
                        decoration: InputDecoration(
                            hintText: StoreProvider.of<ZState>(context)
                                .state
                                .lang
                                .get('login.url')),
                        onChanged: (value) {
                          etcdManageUrl = value;
                        },
                        onSaved: (value) {
                          etcdManageUrl = value;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            hintText: StoreProvider.of<ZState>(context)
                                .state
                                .lang
                                .get('login.username')),
                        onChanged: (value) {
                          username = value;
                        },
                        onSaved: (value) {
                          username = value;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            hintText: StoreProvider.of<ZState>(context)
                                .state
                                .lang
                                .get('login.password')),
                        obscureText: true,
                        onChanged: (value) {
                          password = value;
                        },
                        onSaved: (value) {
                          password = value;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      MaterialButton(
                        minWidth: MediaQuery.of(context).size.width - 30,
                        height: 42,
                        color: Colors.blue[400],
                        onPressed: () {
                          onLogin();
                        },
                        child: Text(
                          StoreProvider.of<ZState>(context)
                              .state
                              .lang
                              .get('login.login_btn'),
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
