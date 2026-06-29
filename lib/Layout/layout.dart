import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Layout extends StatelessWidget {

  const Layout({super.key, this.appBar, required this.body});
  final PreferredSizeWidget? appBar;
  final Widget body;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: appBar,
      body: body,
    );
  }
}
