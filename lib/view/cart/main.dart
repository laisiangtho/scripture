// import 'dart:async';
// import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';

// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:in_app_purchase_android/billing_client_wrappers.dart';
// import 'package:in_app_purchase_android/in_app_purchase_android.dart';

// import 'keep.consumable.dart';

class CartMain extends StatefulWidget {
  const CartMain({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => View();
}

abstract class _State extends State<CartMain> with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class View extends _State {
  @override
  Widget build(BuildContext context) {
    const List<Widget> _lst = [Text('Working')];
    return SliverList(delegate: SliverChildListDelegate(_lst));
  }
}
