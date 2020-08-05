import 'package:etcd_manage_app/components/app_bar.dart';
import 'package:etcd_manage_app/store/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:etcd_manage_app/i18n/i18n.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<ZState>(builder: (context, store) {
      I18N lang = StoreProvider.of<ZState>(context).state.lang;
      return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: ZAppBar(
          preferredSize: Size.fromHeight(40),
          appBar: AppBar(
            elevation: 0,
            title: Text(
              lang.get('setings.about'),
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
              Container(
                height: 150,
                child: Center(
                  child: Image.asset("assets/images/logo.png",
                      width: 90, height: 90),
                ),
              ),
              Container(
                child: Center(
                    child: Text('Etcd Manage',
                        style: TextStyle(
                          fontSize: 18,
                        ))),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                child: Text(lang.get('setings_about.about')),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                child: GestureDetector(
                  onTap: (){
                    launch('https://github.com/etcd-manage');
                  },
                  child: Text(
                    lang.get('setings_about.source_url'),
                    style: TextStyle(
                      color: Colors.blue,
                    ),
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
