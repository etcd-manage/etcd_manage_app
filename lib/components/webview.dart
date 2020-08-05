import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:etcd_manage_app/components/app_bar.dart';

class WebPage extends StatefulWidget {
  final String myUrl;
  final String title;
  WebPage({this.myUrl, this.title});

  @override
  _WebPageState createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: ZAppBar(
          preferredSize: Size.fromHeight(44),
          appBar: AppBar(
            title: Text(
              widget.title ?? 'web page',
            ),
            centerTitle: true,
          ),
        ),
        body: WebviewScaffold(
          url: widget.myUrl,
          withJavascript: true,
          withLocalStorage: true,
          withZoom: true,
          withOverviewMode: false,
          userAgent: Platform.isIOS ? 'app-ios' : 'app-android',
        ),
      );
}
