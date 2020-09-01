part of 'main.dart';

class View extends _State with _Bar, _Suggest, _Result {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      // resizeToAvoidBottomInset: true,
      // resizeToAvoidBottomPadding: true,
      body: ScrollPage(
        controller: controller.master,
        child: _scroll(),
      ),
    );
  }

  CustomScrollView _scroll() {
    return CustomScrollView(
      controller: controller.master,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: <Widget>[
        sliverPersistentHeader(),
        new SliverPadding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
          sliver: _body
        )
      ]
    );
  }

  Widget get _body {
    return VerseInheritedWidget(
      size: core.fontSize,
      lang: core.collectionLanguagePrimary.name,
      child:focusNode.hasFocus?suggest():result()
      // child:result()
    );
  }
}
