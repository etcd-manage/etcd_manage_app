import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:etcd_manage_app/api/keys/keys.dart';
import 'package:etcd_manage_app/components/app_bar.dart';
import 'package:etcd_manage_app/models/msg.dart';
import 'package:etcd_manage_app/store/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:etcd_manage_app/i18n/i18n.dart';
import 'package:etcd_manage_app/models/keyinfo.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ValPage extends StatefulWidget {
  final String path;
  ValPage({this.path});

  @override
  _ValPageState createState() => _ValPageState();
}

class _ValPageState extends State<ValPage> {
  @override
  void initState() {
    super.initState();
    getVal();
  }

  KeyInfo keyInfo = null;

  // 获取一个path的值
  void getVal() async {
    Msg msg = await Keys.val(widget.path);
    if (msg.code == 401) {
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }
    if (mounted) {
      setState(() {
        keyInfo = msg.data;
      });
    }
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
              lang.get('public.key_val'),
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            centerTitle: true,
          ),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Container(
                height: 30,
                padding: new EdgeInsets.only(left: 10),
                alignment: Alignment.centerLeft,
                child: Text(keyInfo != null ? keyInfo.path : ''),
              ),
              Expanded(
                child: SyntaxView(
                  code: keyInfo != null ? keyInfo.value : '',
                  syntax: Syntax.JAVASCRIPT,
                  syntaxTheme: SyntaxTheme.dracula(),
                  withZoom: false,
                  withLinesCount: true,
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (keyInfo == null) {
              Fluttertoast.showToast(
                msg: lang.get('key_val.copy_null'),
                gravity: ToastGravity.CENTER,
              );
              return;
            }
            ClipboardManager.copyToClipBoard(keyInfo.value).then((result) {
              Fluttertoast.showToast(
                msg: lang.get('key_val.copy_ok'),
                gravity: ToastGravity.CENTER,
              );
            });
          },
          child: Text(
            lang.get('key_val.copy'),
          ),
        ),
      );
    });
  }
}
