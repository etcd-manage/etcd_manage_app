import 'package:flutter/material.dart';

class ZAppBar extends PreferredSize {
  @override
  final Widget appBar;
  @override
  final Size preferredSize;

  ZAppBar({this.appBar, this.preferredSize});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: appBar,
    );
  }
}
