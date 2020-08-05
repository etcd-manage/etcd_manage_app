import 'package:etcd_manage_app/i18n/i18n.dart';
import 'package:etcd_manage_app/router/index.dart';
import 'package:etcd_manage_app/store/store.dart';
import 'package:etcd_manage_app/theme/dark.dart';
import 'package:etcd_manage_app/theme/light.dart';
import 'package:etcd_manage_app/views/welcome/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // 获取主题
  ThemeData darkTheme = DarkTheme;
  ThemeData lightTheme = LightTheme;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    I18N lang = I18N();
    lang.init('en');

    final store = new Store<ZState>(
      appReducer,
      initialState: new ZState(locale: 'en', lang: lang),
    );

    return StoreProvider(
      store: store,
      child: StoreBuilder<ZState>(builder: (context, store) {
        String theme = StoreProvider.of<ZState>(context).state.theme;
        if (theme == 'light') {
          darkTheme = LightTheme;
          lightTheme = LightTheme;
        } else if (theme == 'dark') {
          darkTheme = DarkTheme;
          lightTheme = DarkTheme;
        } else {
          darkTheme = DarkTheme;
          lightTheme = LightTheme;
        }

        return MaterialApp(
          title: 'Etcd Manage',
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          routes: routes,
          home: WelcomePage(),
        );
      }),
    );
  }
}
