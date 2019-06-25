import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// import 'StoreModel.dart';
import 'Store.dart';
import 'Common.dart';


class SearchResult extends StatelessWidget {
  SearchResult({this.result});

  final AsyncSnapshot<List> result;
  final Store store = new Store();

  @override
  Widget build(BuildContext context) {
    if (result.hasError) {
      return new SliverFillRemaining(
        child: WidgetError(message: result.error)
      );
    }

    if (result.hasData) {
      if (result.data.length > 0) {
        store.getCollectionKeyword(store.searchQuery,add: true);
        return new SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) => _books(context, result.data[index]),
            childCount: result.data.length
          )
        );
      } else {
        return new SliverFillRemaining(
          // found no match of ABC in verses
          child: WidgetEmptyIdentify(atLeast: 'found no match\nof ',enable:store.searchQuery,task: '\nin ',message:'verses')
        );
      }
    }
    return new SliverFillRemaining();
  }
  Widget _books(BuildContext context, book){
    return Column(
      mainAxisSize: MainAxisSize.max,
      // mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          // color: Colors.grey,
          padding: EdgeInsets.all(10),
          // height: 50,
          child: Text(book['name'],style: Theme.of(context).textTheme.title),
        ),
        /*
        TableCell(
          child: Text(book['name']),
        ),
        */
        Table(
          // border: TableBorder.all(width: 0.1),
          // defaultColumnWidth: FixedColumnWidth(40),
          columnWidths: {
            0:FixedColumnWidth(70)
          },
          children: _testChapters(context,book['child']),
          // children: <TableRow>[
          //   TableRow(
          //     children: <Widget>[
          //       // TableCell(
          //       //   verticalAlignment: TableCellVerticalAlignment.top,
          //       //   child: Text('1'),
          //       // ),
          //       // TableCell(
          //       //   child: Text('hild : Useful to show loading until the image is displayed.'),
          //       // ),
          //       Align(
          //         alignment: Alignment.center,
          //         child: Text('1'),
          //       ),
          //       // Align(
          //       //   alignment: Alignment.centerLeft,
          //       //   child: Text('hild : Useful to show loading until the image is displayed..'),
          //       // ),
          //       Column(
          //         children: <Widget>[
          //           Text('1. hild : Useful to show loading until the image is displayed..'),
          //           Text('2. hild : Useful to show loading until the image is displayed..')
          //         ]
          //       )
          //     ]
          //   )
          // ],
        )
      ]
    );
  }
  List<TableRow> _testChapters(BuildContext context, data){
    List<TableRow> list = new List();
    // _testVerse(context, chapter['child'])
    for (var chapter in data) {
      list.add(
        TableRow(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Text(
                chapter['id'],
                style: Theme.of(context).textTheme.body2.copyWith(
                  fontSize: 22
                )
              )
            ),
            Column(
              children: _testVerse(context, chapter['child']),
            )
          ]
        )
      );
    }
    return list;
  }
  List<Widget> _testVerse(BuildContext context, data){
    final style = TextStyle(color: Colors.red, fontSize: 15);
    List<Widget> list = new List();
    for (var verse in data) {
      list.add(
        Container(
          padding: EdgeInsets.only(bottom: 10, right: 20),
          child: RichText(
            text: TextSpan(
              // text: verse['id'],
              // style: TextStyle(inherit: ),
              style: Theme.of(context).textTheme.body2.copyWith(
                fontSize: 13,
              ),
              // children: _getSpans(verse['text'], query, style),
              children: <TextSpan>[
                TextSpan(
                  text: verse['id'],
                  style: Theme.of(context).textTheme.body2.copyWith(
                    color: Colors.grey,
                    fontSize: 10,
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
        // Column(
        //   mainAxisAlignment: MainAxisAlignment.start,
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   mainAxisSize: MainAxisSize.max,
        //   children: <Widget>[
        //     Text(verse['id']),
        //     // Text(verse['text']),
        //     RichText(
        //       text: TextSpan(
        //         text: verse['text'],
        //         style: Theme.of(context).textTheme.body2.copyWith(),
        //       )
        //     )
        //   ],
        // )
      );
    }
    return list;
  }
  /*
  Widget _chapters(BuildContext context, chapter){
    return ListTile(
      // contentPadding: EdgeInsets.symmetric(horizontal:5.0),
      leading: CircleAvatar(
        backgroundColor: Colors.grey[300],
        child: Text(new Store().digit(chapter['id']),style: TextStyle(color: Colors.white)),
      ),
      // subtitle: ListView.builder(
      //   physics: ScrollPhysics(),
      //   shrinkWrap: true,
      //   itemCount: chapter['child'].length,
      //   itemBuilder: (BuildContext context, int index) => _verse(context, chapter['child'][index])
      // )
      subtitle: new SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) => _verse(context, chapter['child'][index]),
          childCount: chapter['child'].length
        )
      )
      // subtitle: ListView.builder(
      //   // physics: ScrollPhysics(),
      //   // shrinkWrap: true,
      //   itemCount: chapter['child'].length,
      //   itemBuilder: (BuildContext context, int index) => _verse(context, chapter['child'][index])
      // )
    );
  }
  Widget _verse(BuildContext context, verse){
    // final wordToStyle = 'text';
    final style = TextStyle(color: Colors.red);
    // final spans = _getSpans(verse['text'], wordToStyle, style);

    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
      leading: CircleAvatar(
        radius: 15,
        backgroundColor: Colors.grey,
        child: Text(new Store().digit(verse['id']),style: TextStyle(fontSize: 11,color: Colors.white,fontWeight: FontWeight.w300)),
      ),
      // subtitle: Text(verse['text'],style: TextStyle(fontSize:13,fontWeight: FontWeight.w300)),
      subtitle: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.body2.copyWith(),
          children: _getSpans(verse['text'], query, style),
        ),
      ),
      onTap: () => null
      // onTap: () => searchDelegate.close(context, {'book':verse['bid'],'chapter':verse['cid'],'verse':verse['id'],'query':query})
    );
  }
    */
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

}