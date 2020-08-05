import 'package:etcd_manage_app/views/home/home_page.dart';
import 'package:etcd_manage_app/views/login/login_page.dart';
import 'package:etcd_manage_app/views/tabs/tabs_page.dart';
import 'package:etcd_manage_app/views/welcome/welcome_page.dart';
import 'package:flutter/material.dart';

final routes = <String, WidgetBuilder>{
  // 登录
  '/login': (_) => LoginPage(),
  // 欢迎
  '/welcome': (_) => WelcomePage(),
  // tabs切换主页
  '/tabs': (_) => TabsPage(),
  // 首页
  '/home': (_) => HomePage(),

};
