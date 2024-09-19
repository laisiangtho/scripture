import 'package:flutter/material.dart';

import '/app.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

abstract class _State extends CommonStates<Main> with TickerProviderStateMixin {
  late final _formKey = GlobalKey<FormState>();
  late final _textController = TextEditingController();
  late final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      _textController.text = state.param.map['text'];
      if (_focusNode.canRequestFocus && autoFocus) {
        _focusNode.requestFocus();
      }
    });
  }

  bool get autoFocus {
    return state.param.map.isNotEmpty && state.param.map['focus'] != null;
  }

  String get pageTitle {
    // return args.isNotEmpty && args['title'] != null;
    if (state.param.map.isNotEmpty) {
      if (state.param.map['pageTitle'] != null) {
        return state.param.map['pageTitle'];
      }
    }
    return '...';
  }

  String get pageLabel {
    // return args.isNotEmpty && args['title'] != null;
    if (state.param.map.isNotEmpty) {
      if (state.param.map['pageLabel'] != null) {
        return state.param.map['pageLabel'];
      }
    }
    return app.preference.of(context).text('true');
  }

  void onSubmit(String str) {
    Navigator.of(context, rootNavigator: true).maybePop({'text': str});
  }
}

mixin _Header on _State {
  Widget _header() {
    return ViewHeaderLayouts.fixed(
      height: kTextTabBarHeight,
      left: [
        OptionButtons.backOrCancel(
          back: app.preference.of(context).back,
          cancel: app.preference.of(context).cancel,
        ),
      ],
      primary: ViewHeaderTitle.dual(
        label: pageLabel,
        // header: '....',
        // header: title.result.book.first.info.name,
        // header: itemBooks.first.info.name,
        // header: title.result.book.first.info.name,
        header: pageTitle,
        // header: title.result.book.first.info.name,
        shrinkMax: 16,
      ),
      // right: [
      //   OptionButtons.icon(
      //     onPressed: () {},
      //     icon: Icons.check,
      //   ),
      // ],
    );
  }
}

class _MainState extends _State with _Header {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // primary: true,
      resizeToAvoidBottomInset: false,
      appBar: ViewBars(
        height: kTextTabBarHeight,
        // forceOverlaps: false,
        forceStretch: true,
        backgroundColor: Theme.of(context).primaryColor,
        // overlapsBackgroundColor: Theme.of(context).primaryColor,
        overlapsBorderColor: Theme.of(context).dividerColor,
        child: _header(),
      ),
      body: Views(
        heroController: HeroController(),
        child: editor,
      ),
    );
  }

  Widget get editor {
    // return ConstrainedBox(
    //   constraints: const BoxConstraints(
    //     maxHeight: 300.0,
    //   ),
    //   child: const Scrollbar(
    //     child: SingleChildScrollView(
    //       scrollDirection: Axis.vertical,
    //       reverse: true,
    //       child: Padding(
    //         padding: EdgeInsets.all(8.0),
    //         child: TextField(
    //           maxLines: null,
    //         ),
    //       ),
    //     ),
    //   ),
    // );

    // return Scrollbar(
    //   child: SingleChildScrollView(
    //     scrollDirection: Axis.vertical,
    //     reverse: true,
    //     child: field(),
    //   ),
    // );
    // return const TextField(
    //   maxLines: null,
    // );
    return field();
  }

  Widget field() {
    // TextField(
    //   maxLines: null,
    // );
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        key: _formKey,
        controller: _textController,
        focusNode: _focusNode,
        // initialValue: state.asMap['text'],
        minLines: 3,
        maxLines: 7,
        // cursorHeight: 20,
        // expands: true,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          filled: true,
          hintText: ' . . .',
          contentPadding: const EdgeInsets.symmetric(vertical: 7, horizontal: 11),
          fillColor: Theme.of(context).primaryColor,
        ),
        onFieldSubmitted: onSubmit,
      ),
    );
  }
}
