import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:lidea/scroll.dart';

import 'package:bible/core.dart';
import 'package:bible/widget.dart';
import 'package:bible/icon.dart';

part 'view.dart';
part 'data.dart';
part 'bar.dart';
part 'suggest.dart';
part 'result.dart';

class Main extends StatefulWidget {
  Main({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => View();
}

abstract class _State extends State<Main> with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  final core = Core();
  final controller = ScrollController();
  final textController = new TextEditingController();
  final focusNode = new FocusNode();

  String get searchQuery => this.textController.text;

  // void inputKeyboardShow() => FocusScope.of(context).requestFocus(focusNode);
  // void inputKeyboardShow() => focusNode.requestFocus();
  // FocusScope.of(context).unfocus()
  void inputKeyboardHide() => focusNode.unfocus();
  void inputClear() => textController.clear();
  void inputCancel() => inputKeyboardHide();
  void inputSubmit(String word) {
    inputKeyboardHide();
    this.textController.text = word;
    // core.searchQuery = word;
    core.analyticsSearch(this.searchQuery);
  }

  @override
  void initState() {
    super.initState();
    textController.text = core.searchQuery;
    textController.addListener(() {
      setState(() {
        core.searchQuery = searchQuery;
      });
    });
    focusNode.addListener(() {
      if(focusNode.hasFocus) {
        textController?.selection = TextSelection(baseOffset: 0, extentOffset: textController.value.text.length);
      }
    });
  }

  @override
  dispose() {
    controller.dispose();
    focusNode.dispose();
    textController.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if(mounted) super.setState(fn);
  }
}
