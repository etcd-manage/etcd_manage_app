import 'package:etcd_manage_app/components/app_bar.dart';
import 'package:etcd_manage_app/store/store.dart';
import 'package:etcd_manage_app/store/theme_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:etcd_manage_app/i18n/i18n.dart';

class ThemePage extends StatefulWidget {
  @override
  _ThemePageState createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {
  @override
  void initState() {
    super.initState();
  }

  // 跟随系统
  bool autoTheme = false;
  // 白
  bool lightTheme = false;
  // 黑
  bool darkTheme = false;

  // 设置主题
  void changeTheme() {
    setState(() {});
    String themeStr = 'auto';
    if (lightTheme == true) {
      themeStr = 'light';
    } else if (darkTheme == true) {
      themeStr = 'dark';
    }
    // 存储一下
    StoreProvider.of<ZState>(context).dispatch(new UpdateThemeAction(themeStr));
    // 更新一下主题
  }

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<ZState>(builder: (context, store) {
      I18N lang = StoreProvider.of<ZState>(context).state.lang;
      String theme = StoreProvider.of<ZState>(context).state.theme;
      if (theme == 'auto') {
        autoTheme = true;
      } else if (theme == 'light') {
        lightTheme = true;
      } else if (theme == 'dark') {
        darkTheme = true;
      } else {
        autoTheme = true;
      }

      return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: ZAppBar(
          preferredSize: Size.fromHeight(40),
          appBar: AppBar(
            elevation: 0,
            title: Text(
              lang.get('setings.theme'),
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            centerTitle: true,
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: Card(
            // elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: SizedBox(
              height: 170,
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(
                      lang.get('setings_theme.auto'),
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).textTheme.bodyText1.color,
                      ),
                    ),
                    trailing: CupertinoSwitch(
                        value: autoTheme,
                        onChanged: (bool ok) {
                          if (ok == true) {
                            autoTheme = true;
                            darkTheme = false;
                            lightTheme = false;
                          }
                          changeTheme();
                        }),
                  ),
                  Divider(
                    height: 1.0,
                    indent: 0.0,
                  ),
                  ListTile(
                    title: Text(
                      lang.get('setings_theme.dark'),
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).textTheme.bodyText1.color,
                      ),
                    ),
                    trailing: CupertinoSwitch(
                        value: darkTheme,
                        onChanged: (bool ok) {
                          if (ok == true) {
                            autoTheme = false;
                            darkTheme = true;
                            lightTheme = false;
                          }
                          changeTheme();
                        }),
                  ),
                  Divider(
                    height: 1.0,
                    indent: 0.0,
                  ),
                  ListTile(
                    title: Text(
                      lang.get('setings_theme.light'),
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).textTheme.bodyText1.color,
                      ),
                    ),
                    trailing: CupertinoSwitch(
                        value: lightTheme,
                        onChanged: (bool ok) {
                          if (ok == true) {
                            autoTheme = false;
                            darkTheme = false;
                            lightTheme = true;
                          }
                          changeTheme();
                        }),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
