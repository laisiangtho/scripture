part of 'main.dart';

class View extends _State with _Bar, _Sheet {

  @override
  Widget build(BuildContext context) {
    // return FutureBuilder<DefinitionBible>(
    //   future: initiator,
    //   builder: (BuildContext context, AsyncSnapshot<DefinitionBible> snapshot) {
    //     switch (snapshot.connectionState) {
    //       case ConnectionState.done:
    //         return reader();
    //       default:
    //         return WidgetMsg(message: 'A moment',);
    //         // return Center(child: Text('A moment'));
    //     }
    //   }
    // );
    return reader();
  }

  Widget reader() {
    return Scaffold(
      key: scaffoldKey,
      body: ViewPage(
        controller: scrollController,
        child: body()
      ),
      bottomNavigationBar: showSheet()
    );
  }

  Widget body() {
    return CustomScrollView(
      controller: scrollController,
      // primary: true,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: <Widget>[
        bar(),
        SliverToBoxAdapter(
          child: Selector<Core, String>(
            selector: (_, e) => e.message,
            builder: (BuildContext context, String message, Widget? child) => message.isNotEmpty?Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Text(
                  '...$message'
                ),
              ),
            ):Container(),
          ),
        ),

        Selector<Core,BIBLE>(
          selector: (_, e) => e.scripturePrimary.verseChapter,
          builder: (BuildContext context, BIBLE message, Widget? child) => new SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) => _inheritedVerse(tmpverse[index]),
              childCount: tmpverse.length,
              // addAutomaticKeepAlives: true
            ),
          ),
        )
      ]
    );
  }

  Widget _inheritedVerse(VERSE verse){
    return VerseInheritedWidget(
      key: verse.key,
      size: core.collection.fontSize,
      lang: core.scripturePrimary.info.langCode,
      selected: verseSelectionList.indexWhere((id) => id == verse.id) >= 0,
      child: WidgetVerse(
        verse: verse,
        onPressed: verseSelection,
      )
    );
  }
}
