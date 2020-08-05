import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

// 课程详情问答
class Finder extends StatefulWidget {
  Finder({
    Key key,
    GestureTapCallback this.onTap,
    String this.name,
  }) : super(key: key);
  GestureTapCallback onTap;
  String name;

  @override
  _FinderState createState() => _FinderState();
}

class _FinderState extends State<Finder> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 4 - 10;
    double height = MediaQuery.of(context).size.width / 4 + 20;
    if (Platform.isMacOS || Platform.isWindows) {
      width = 100;
      height = 130;
    }
    return GestureDetector(
      onTap: widget.onTap ?? null,
      child: Container(
        width: width,
        height: height,
        child: Column(
          children: <Widget>[
            Container(
              height: width,
              padding: new EdgeInsets.all(10),
              child: new Image(
                image: AssetImage('assets/images/folder.png'),
                fit: BoxFit.fill,
              ),
            ),
            Center(
              child: Text(
                widget.name ?? '',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
