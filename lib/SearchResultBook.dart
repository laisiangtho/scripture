import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'Store.dart';
import 'Search.dart';

class SearchResultBook extends StatefulWidget {
  SearchResultBook({Key key,this.book}) : super(key: key);
  final Map book;

  @override
  _SearchResultBookState createState() => _SearchResultBookView();
}

abstract class _SearchResultBookState extends State<SearchResultBook>{
  Store store = new Store();

  @override
  void initState() {
    super.initState();
  }
}

class _SearchResultBookView extends _SearchResultBookState {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        top: false,
        bottom: false,
        child: new Scaffold(
          body: CustomScrollView(
            // controller: store.scrollController,
            slivers: <Widget>[
              new SliverPersistentHeader(pinned: true, floating: true, delegate: WidgetHeaderSliver(bar)),
              new SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) => _testChapters( widget.book['child'][index]),
                  childCount: widget.book['child'].length
                )
              )
            ]
          )
        )
      )
    );
  }

  Widget bar(BuildContext context,double offset,bool overlaps, double stretch,double shrink){
    return Stack(
      children: <Widget>[
        Align(
          widthFactor: 1,
          alignment: Alignment.centerLeft,
          child: CupertinoButton(
            padding: EdgeInsets.symmetric(vertical: 0,horizontal: 7),
            // padding: EdgeInsets.lerp(EdgeInsets.symmetric(vertical: 0,horizontal: 0), EdgeInsets.symmetric(vertical: 0,horizontal: 0), shrink),
            minSize: 30,
            child:Icon(Icons.arrow_back_ios,color:Colors.grey[300],size: (10*shrink)+20),
            onPressed: () => Navigator.pop(context)
          )
        ),
        Align(
          alignment: Alignment.center,
          // child: Text(widget.book['name'])
          child: Text(store.searchQuery)
        )
      ]
    );
  }

  Widget _testChapters(chapters){
    // return Table(
    //   // border: TableBorder.all(width: 0.1),
    //   // defaultColumnWidth: FixedColumnWidth(40),
    //   columnWidths: {
    //     0:FixedColumnWidth(70)
    //   },
    //   children: <TableRow>[
    //     TableRow(
    //       children: <Widget>[
    //         Align(
    //           alignment: Alignment.center,
    //           child: Text(
    //             chapters['id'],
    //             style: Theme.of(context).textTheme.body2.copyWith(
    //               fontSize: 22
    //             )
    //           )
    //         ),
    //         Column(
    //           children: _testVerse(chapters['child']),
    //         )
    //       ]
    //     )
    //   ]
    // );
    /*
    return new ExpansionTile(
      leading: Text(chapters['id']),
      title: Text('data'),
      children: _testVerse(chapters['child'])
    );
    return new ListBody(
      // leading: Text(chapters['id']),
      // title: Text('data'),
      children: _testVerse(chapters['child'])
    );
    */
    return new ListTile(

      // leading: Text(chapters['id']),
      // title: Text(widget.book['name'] +' '+ chapters['id'].toString()),
      title: FlatButton(
        child: Text(widget.book['name'] +' '+ chapters['id'].toString()),
        onPressed: ()=>Navigator.pop(context,{'book':widget.book['id'],'chapter':chapters['id']})
      ),
      contentPadding: EdgeInsets.all(10),
      // title: InkWell(
      //   child: Text(widget.book['name'] +' '+ chapters['id'].toString(),style: Theme.of(context).textTheme.title,),
      //   onTap: (){},
      // ),
      subtitle: new ListBody(
        children: _testVerse(chapters['child'])
      )
    );
  }

  List<Widget> _testVerse(data){
    final style = TextStyle(color: Colors.red, fontSize: 22);
    List<Widget> list = new List();
    for (var verse in data) {
      list.add(
        Container(
          // padding: EdgeInsets.only(bottom: 10, right: 20),
          // padding: EdgeInsets.only(top: 10, left: 20),
          padding: EdgeInsets.symmetric(vertical: 7,horizontal: 20),
          child: RichText(
            text: TextSpan(
              // text: verse['id'],
              // style: TextStyle(inherit: ),
              style: Theme.of(context).textTheme.body2.copyWith(
                fontSize: 20,
              ),
              // children: _getSpans(verse['text'], query, style),
              children: <TextSpan>[
                TextSpan(
                  text: verse['id'],
                  style: Theme.of(context).textTheme.body2.copyWith(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),
                TextSpan(
                  text: '  ',
                  children: _getSpans(verse['text'], store.searchQuery, style),
                ),
                // TextSpan(
                //   text: verse['text']
                // )

              ]
            )
          ),
        )
      );
    }
    return list;
  }
  List<TextSpan> _getSpans(String text, String matchWord, TextStyle style) {
    List<TextSpan> spans = [];
    int spanBoundary = 0;
    do {
      // look for the next match
      final startIndex = text.toLowerCase().indexOf(matchWord.toLowerCase(), spanBoundary);
      // final startIndex = text.indexOf(matchWord, spanBoundary);
      // if no more matches then add the rest of the string without style
      if (startIndex == -1) {
        spans.add(TextSpan(text: text.substring(spanBoundary)));
        return spans;
      }
      // add any unstyled text before the next match
      if (startIndex > spanBoundary) {
        spans.add(TextSpan(text: text.substring(spanBoundary, startIndex)));
      }
      // style the matched text
      final endIndex = startIndex + matchWord.length;
      final spanText = text.substring(startIndex, endIndex);
      spans.add(TextSpan(text: spanText, style: style));
      // mark the boundary to start the next search from
      spanBoundary = endIndex;
    // continue until there are no more matches
    } while (spanBoundary < text.length);
    return spans;
  }

  /*
  Widget body(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[

        OutlineButton(
          child: Text('to Book'),
          onPressed: (){
            // store.pageController.jumpToPage(0);
            Navigator.pop(context,store.pageController.jumpToPage(0));
          },
        ),
        OutlineButton(
          child: Text('to Bible'),
          onPressed: (){
            Navigator.pop(context,store.pageController.jumpToPage(1));
            // store.pageController.jumpToPage(1);
          },
        ),
        OutlineButton(
          child: Text('Back'),
          onPressed: (){
            Navigator.pop(context,'back');
          },
        )
      ],
    );
    // return new CustomScrollView(
    //   controller: store.scrollController,
    //   slivers: <Widget>[
    //     new SliverPersistentHeader(pinned: true, floating: true, delegate: WidgetHeaderSliver(bar,minHeight: 20)),
    //     new SliverPadding(
    //       padding: EdgeInsets.only(bottom: store.contentBottomPadding),
    //       sliver: futureBuilderSliver()
    //     )
    //   ]
    // );
  }
  */
}

// class InheritedStateContainer extends InheritedWidget {
//   @override
//   bool updateShouldNotify(InheritedWidget oldWidget) {
//     // TODO: implement updateShouldNotify
//     return null;
//   }
// }