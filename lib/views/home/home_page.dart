import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:etcd_manage_app/api/keys/keys.dart';
import 'package:etcd_manage_app/api/server/server.dart';
import 'package:etcd_manage_app/components/app_bar.dart';
import 'package:etcd_manage_app/components/file.dart';
import 'package:etcd_manage_app/components/finder.dart';
import 'package:etcd_manage_app/i18n/i18n.dart';
import 'package:etcd_manage_app/models/keyinfo.dart';
import 'package:etcd_manage_app/models/msg.dart';
import 'package:etcd_manage_app/models/server_info.dart';
import 'package:etcd_manage_app/store/etcd_store.dart';
import 'package:etcd_manage_app/store/store.dart';
import 'package:etcd_manage_app/views/home/val_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    getServers();
  }

  // 加载中
  bool isLoading = true;
  // key列表
  List<KeyInfo> keyList = [];
  // 当前路径
  String path = '';
  List<String> paths = [];
  // 面包线控制
  ScrollController _lineController = ScrollController();
  // 路径根是否是 /
  bool isPathRoot = false;

  // etcd 服务列表
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<ServerInfo> etcdServers = [];
  int etcdId = 0;
  // 语言
  I18N lang;

  // TODO
  // 记录最常访问 记录最后更新时间 访问次数 sqllite
  // 可以返回key字节数

  // 获取key列表
  void getKeys() async {
    if (mounted) {
      setState(() {
        this.isLoading = true;
        this.keyList = [];
      });
    }

    Msg msg = await Keys.keys(path);
    if (msg.code == 401) {
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }
    if (mounted) {
      setState(() {
        this.isLoading = false;
      });
    }
    if (msg.code != 200) {
      Fluttertoast.showToast(
        msg: msg.msg,
        gravity: ToastGravity.CENTER,
      );
      return;
    }
    // print(path.split);
    this.paths = path.split('/');
    if (this.paths?.length == 0 && this.paths[0] == '') {
      this.isPathRoot = false;
      this.paths = ['🏠'];
    }
    if (this.paths[0] == '') {
      this.paths[0] = '🏠';
      this.isPathRoot = true;
    } else {
      this.paths.insert(0, '🏠');
      this.isPathRoot = false;
    }

    if (msg.data == null || msg.data.length == 0) {
      Fluttertoast.showToast(
        msg: lang.get('home.list_none'),
        gravity: ToastGravity.CENTER,
      );
    }

    if (mounted) {
      setState(() {
        this.keyList = msg.data;
        this.paths = this.paths;
      });
    }

    Timer(Duration(milliseconds: 200),
        () => _lineController.jumpTo(_lineController.position.maxScrollExtent));
  }

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
    // 防止未选etcd服务时获取不到数据
    final SharedPreferences prefs = await _prefs;
    String serverInfoStr = prefs.getString("server_info");
    if (serverInfoStr != null && serverInfoStr != "") {
      try {
        var serverInfo = ServerInfo.fromJson(json.decode(serverInfoStr));
        etcdId = serverInfo.id;
      } catch (e) {}
    }
    if (etcdServers != null && etcdServers.length > 0 && etcdId == 0) {
      StoreProvider.of<ZState>(context)
          .dispatch(new UpdateEtcdServerAction(etcdServers[0]));
    }
    getKeys(); // 获取etcd key列表
  }

  // 切换etcd服务
  void changeServer() {
    print(etcdId);
    if (etcdServers == null || etcdServers.length == 0) {
      return;
    }
    ServerInfo oneServer = null;
    etcdServers.forEach((val) {
      if (val.id == etcdId) {
        oneServer = val;
        return;
      }
    });
    if (oneServer != null) {
      StoreProvider.of<ZState>(context)
          .dispatch(new UpdateEtcdServerAction(oneServer));
      path = '';
      getKeys();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<ZState>(builder: (context, store) {
      lang = StoreProvider.of<ZState>(context).state.lang;
      double childAspectRatio = (MediaQuery.of(context).size.width / 4 - 10) /
          (MediaQuery.of(context).size.width / 4 + 20);
      int crossAxisCount = 4;
      if (Platform.isMacOS || Platform.isWindows) {
        crossAxisCount =
            ((MediaQuery.of(context).size.width - 50) ~/ 130).toInt();
      }
      return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: ZAppBar(
          preferredSize: Size.fromHeight(40),
          appBar: AppBar(
            elevation: 0,
            title: Text(
              lang.get('public.kv'),
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            centerTitle: true,
            actions: <Widget>[
              new PopupMenuButton<int>(
                icon: Icon(Icons.format_list_bulleted),
                tooltip: lang.get('home.server_list'),
                itemBuilder: (BuildContext context) {
                  var items = <PopupMenuItem<int>>[];
                  if (etcdServers != null && etcdServers.length > 0) {
                    etcdServers.forEach((val) {
                      bool serverEnabled = true;
                      if (etcdId == val.id) {
                        serverEnabled = false;
                      }
                      items.add(PopupMenuItem<int>(
                          value: val.id,
                          enabled: serverEnabled,
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              new Text(val.name),
                            ],
                          )));
                    });
                  }
                  return items;
                },
                onSelected: (int action) {
                  etcdId = action;
                  changeServer();
                },
              ),
            ],
          ),
        ),
        body: Container(
          // height: 900,
          padding: new EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: Column(
            children: <Widget>[
              Container(
                height: 39,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 1, color: Colors.grey[400]))),
                child: ListView.builder(
                    controller: _lineController,
                    scrollDirection: Axis.horizontal,
                    itemCount: paths?.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Row(
                        children: <Widget>[
                          paths[index] == '🏠'
                              ? GestureDetector(
                                  onTap: () {
                                    this.path = '';
                                    getKeys();
                                  },
                                  child: Icon(
                                    Icons.home,
                                    color: Colors.grey[600],
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    var path1 = paths.sublist(1, index + 1);
                                    var path2 = path1.join('/');
                                    if (isPathRoot == true) {
                                      path2 = '/' + path2;
                                    }
                                    this.path = path2;
                                    getKeys();
                                  },
                                  child: Text(
                                    paths[index],
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                          paths?.length - 1 == index
                              ? Container()
                              : Container(
                                  child: Icon(
                                    Icons.keyboard_arrow_right,
                                    color: Colors.grey[600],
                                  ),
                                ),
                        ],
                      );
                    }),
              ),
              keyList?.length == 0 
                  ? Container(
                      child: Center(
                        child: isLoading == true ? Text(lang.get('public.loading')) : Text(''),
                      ),
                    )
                  : Expanded(
                      child: Container(
                        child: GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                            childAspectRatio: childAspectRatio,
                          ),
                          itemCount: keyList?.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (keyList[index].isDir) {
                              return Finder(
                                name: keyList[index].name,
                                onTap: () {
                                  setState(() {
                                    this.path = keyList[index].path;
                                  });
                                  this.getKeys();
                                },
                              );
                            }
                            return File(
                              name: keyList[index].name,
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        ValPage(path: keyList[index].path)));
                              },
                            );
                          },
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
