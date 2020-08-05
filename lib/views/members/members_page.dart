import 'dart:convert';

import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:etcd_manage_app/api/keys/keys.dart';
import 'package:etcd_manage_app/components/app_bar.dart';
import 'package:etcd_manage_app/components/member_card.dart';
import 'package:etcd_manage_app/models/member_info.dart';
import 'package:etcd_manage_app/models/msg.dart';
import 'package:etcd_manage_app/store/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:etcd_manage_app/i18n/i18n.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MembersPage extends StatefulWidget {
  @override
  _MembersPageState createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
  @override
  void initState() {
    super.initState();
    getMembers();
  }

  List<MemberInfo> memberList = [];

  // 首次进入提示

  // 获取集群信息
  void getMembers() async {
    Msg msg = await Keys.members();
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
    memberList = msg.data;
    if (mounted) {
      setState(() {});
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
              lang.get('public.members'),
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            centerTitle: true,
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: ListView.builder(
            itemCount: memberList?.length,
            itemBuilder: (BuildContext context, int index) {
              return MemberCard(
                memberInfo: memberList[index],
                onTap: () {
                  print(memberList[index].toString());
                  if (memberList[index] == null) {
                    return;
                  }
                  MemberInfo memberInfo = memberList[index];
                  String peerURLs = memberInfo.peerURLs.join(";");
                  String clientURLs = memberInfo.clientURLs.join(";");
                  String copyData = '''Name: ${memberInfo.name}
ID: ${memberInfo.iD}
Role: ${memberInfo.role}
Status: ${memberInfo.status}
DbSize: ${memberInfo.dbSize}
PeerURLs: ${peerURLs}
ClientURLs: ${clientURLs}
''';
                  ClipboardManager.copyToClipBoard(copyData).then((result) {
                    Fluttertoast.showToast(
                      msg: lang.get('key_val.copy_ok'),
                      gravity: ToastGravity.CENTER,
                    );
                  });
                },
              );
            },
          ),
        ),
      );
    });
  }
}
