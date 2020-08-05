import 'package:etcd_manage_app/components/app_bar.dart';
import 'package:etcd_manage_app/store/lang_store.dart';
import 'package:etcd_manage_app/store/locale_store.dart';
import 'package:etcd_manage_app/store/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:etcd_manage_app/i18n/i18n.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LangPage extends StatefulWidget {
  @override
  _LangPageState createState() => _LangPageState();
}

class _LangPageState extends State<LangPage> {
  @override
  void initState() {
    super.initState();
  }

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  // 语言选择
  bool langEn = true;
  bool langZh = false;

  void changeLang() {
    if (mounted) {
      setState(() {
        langEn = !langEn;
        langZh = !langZh;
      });
    }

    print(langZh);
    print(langEn);
    I18N lang = I18N();
    if (langEn == true) {
      // 存储用户信息
      StoreProvider.of<ZState>(context).dispatch(new UpdateLocaleAction('en'));
      lang.init('en');
    }
    if (langZh == true) {
      StoreProvider.of<ZState>(context).dispatch(new UpdateLocaleAction('zh'));
      lang.init('zh');
    }
    StoreProvider.of<ZState>(context).dispatch(new UpdateLangAction(lang));
  }

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<ZState>(builder: (context, store) {
      I18N lang = StoreProvider.of<ZState>(context).state.lang;
      if (StoreProvider.of<ZState>(context).state.locale == "zh") {
        langZh = true;
        langEn = false;
      } else {
        langZh = false;
        langEn = true;
      }
      return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: ZAppBar(
          preferredSize: Size.fromHeight(40),
          appBar: AppBar(
            elevation: 0,
            title: Text(
              lang.get('setings.lang'),
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
              height: 113,
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(
                      lang.get('setings_lang.en'),
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).textTheme.bodyText1.color,
                      ),
                    ),
                    trailing: CupertinoSwitch(
                        value: langEn,
                        onChanged: (bool ok) {
                          changeLang();
                        }),
                  ),
                  Divider(
                    height: 1.0,
                    indent: 0.0,
                  ),
                  ListTile(
                    title: Text(
                      lang.get('setings_lang.zh'),
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).textTheme.bodyText1.color,
                      ),
                    ),
                    trailing: CupertinoSwitch(
                        value: langZh,
                        onChanged: (bool ok) {
                          changeLang();
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
