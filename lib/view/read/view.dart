// import 'dart:math';
// import 'package:flutter/cupertino.dart';
// // import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:bible/component.dart';
// import 'package:bible/widget.dart';
// // import 'package:bible/avail.dart';
// import 'package:bible/inherited.dart';
// import 'package:bible/model.dart';
// import 'main.dart';
// import 'bar.dart';

part of 'main.dart';

class View extends _State with _Bar, _Bottom, _Gesture {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: ScrollPage(
        controller: controller,
        child: _scrollView()
      ),
      extendBody: true,
      bottomNavigationBar: bottomStack(),
    );
  }

  // Widget _stackView() {
  //   return Stack(
  //     children: <Widget>[
  //       _scrollView(),
  //       Align(
  //         alignment: Alignment.topLeft,
  //         child:Container( height: 20, width: 20, color: Colors.blue,)
  //       ),
  //       // Expanded(child: null)
  //       Positioned(
  //         top: 150,
  //         left: 200,
  //         // height: 20,
  //         // width: 20,
  //         child:Container( height: 20, width: 20, color: Colors.red,)
  //       )
  //     ],
  //   );
  // }

  Widget _scrollView() {
    return CustomScrollView(
      controller: controller,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: <Widget>[
        sliverPersistentHeader(),
        new SliverPadding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom+40.0),
          // padding: EdgeInsets.zero,
          // sliver: hasNotResult?_loadChapter():_loadVerse()
          sliver: _loadChapter()
        )
      ]
    );
  }

  Widget _loadChapter(){
    if (isNotReady) return _msg('no Book is loaded for reading');
    // if (hasNotResult == false) return _loadVerse();
    return FutureBuilder<BIBLE>(
      future: getResult(),
      builder: (BuildContext context, AsyncSnapshot<BIBLE> snapshot){
        if (snapshot.hasError) {
          return _msg(snapshot.error.toString());
        }
        if (snapshot.hasData) {
          if (snapshot.data.book.length > 0) {
            return _loadChapterBuilder(snapshot);
          } else {
            return _msg('Something wrong');
          }
        } else {
          return _msg('A moment');
        }
      }
    );
  }

  Widget _loadChapterBuilder(AsyncSnapshot<BIBLE> snapshot){
    // print(3);
    return _loadVerse();
  }

  Widget _loadVerse(){
    // print(4);
    return new SliverToBoxAdapter(
      child: chapterGesture(
        child: ListView.builder(
          addAutomaticKeepAlives: true,
          // physics: ScrollPhysics(),
          shrinkWrap: true,
          primary: false,
          itemCount: tmpverse.length,
          padding: EdgeInsets.symmetric(vertical: 7.0),
          itemBuilder: (BuildContext context, int id) => _inheritedVerse(context, id, tmpverse[id]),
        )
      ),
    );
  }

  Widget _inheritedVerse(BuildContext context, int index, VERSE verse){
    return VerseInheritedWidget(
      size: core.fontSize,
      lang: core.getCollectionLanguage.name,
      selected: verseSelectionList.indexWhere((id) => id == verse.id) >= 0,
      child: WidgetVerse(
        verse: verse,
        selection: verseSelection,
      )
    );
  }

  Widget _msg(String value){
    return WidgetMessage(message: value);
  }

}
