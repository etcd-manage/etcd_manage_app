import 'package:etcd_manage_app/i18n/i18n.dart';
import 'package:etcd_manage_app/store/store.dart';
import 'package:etcd_manage_app/views/home/home_page.dart';
import 'package:etcd_manage_app/views/members/members_page.dart';
import 'package:etcd_manage_app/views/settings/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';

class TabsPage extends StatefulWidget {
  @override
  _TabsPageState createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  List<String> tabbarTitles = ['首页', '集群信息', '设置'];

  int _currentIndex = 0;
  List<Widget> controllers = List();

  @override
  void initState() {
    controllers..add(HomePage())..add(MembersPage())..add(SettingsPage());
    super.initState();
    var _duration = new Duration(milliseconds: 300);
    new Future.delayed(_duration, () {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<ZState>(builder: (context, store) {
      I18N lang = StoreProvider.of<ZState>(context).state.lang;
      tabbarTitles = [
        lang.get('public.kv'),
        lang.get('public.members'),
        lang.get('public.setings')
      ];
      return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: controllers[_currentIndex],
        bottomNavigationBar: CupertinoTabBar(
          // backgroundColor: Theme.of(context).accentColor,
          items: [
            BottomNavigationBarItem(
              title: Text(tabbarTitles[0]),
              icon: Icon(
                Icons.home,
                size: 28,
              ),
            ),
            BottomNavigationBarItem(
              title: Text(tabbarTitles[1]),
              icon: Icon(
                Icons.devices,
                size: 28,
              ),
            ),
            BottomNavigationBarItem(
              title: Text(tabbarTitles[2]),
              icon: Icon(
                Icons.settings,
                size: 28,
              ),
            ),
          ],
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      );
    });
  }
}
