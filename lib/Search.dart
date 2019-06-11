import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'StoreModel.dart';
import 'Store.dart';
import 'Common.dart';

class Search extends StatefulWidget {
  Search({
    Key key,
    this.scrollController,
    this.offset,
    this.focusNode,
  }) : super(key: key);

  final ScrollController scrollController;
  final FocusNode focusNode;
  final double offset;

  @override
  SearchView createState() => new SearchView();
}

abstract class SearchState extends State<Search> with TickerProviderStateMixin, WidgetsBindingObserver{

  final TextEditingController textController = TextEditingController();
  // TextEditingController textController = TextEditingController(text: 'ပြည်ထောင်စု');
  // TextEditingController textController = TextEditingController(text: 'world');
  // FocusNode focusNode = new FocusNode();

  // bool keyboardVisibilitiy=false;
  // bool textControllerActive=false;
  // bool textControllerEmpty=false;

  Store store = new Store();

  // BIBLE bible;
  double shrinkOffsetPercentage=1.0;
  double barMaxHeight=40.0; //54
  double barMinHeight=20.0;

  @override
  void initState() {

    textController.text = store.searchQuery;
    // widget.scrollController?.addListener(() => setState(() {}));
    // widget.focusNode.addListener(() => setState(() {}));
    textController.addListener(() => setState(() {}));
    WidgetsBinding.instance.addObserver(this);
    widget.focusNode.addListener((){
      if(widget.focusNode.hasFocus) {
        textController.selection = TextSelection(baseOffset: 0, extentOffset: textController.text.length);
      }
    });
    super.initState();
  }

  @override
  dispose() {
    textController.removeListener(() => setState(() {}));
    WidgetsBinding.instance.removeObserver(this);
    // textController.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if(mounted) super.setState(fn);
  }

  @override
  void didChangeMetrics() {
    // print(WidgetsBinding.instance.window.physicalSize);
    // print('didChangeMetrics');
    // print(MediaQuery.of(context).size);

  }
  String get suggestQuery => this.textController.text;
  String get searchQuery => store.searchQuery;

  // void hideKeyboard() => FocusScope.of(context).detach();
  // void showKeyboard() => FocusScope.of(context).requestFocus(new FocusNode());
  void hideKeyboard() => widget.focusNode.unfocus();
  void showKeyboard() => FocusScope.of(context).requestFocus(widget.focusNode);
  // bool get hasFocusNode => widget.focusNode.hasFocus;
  void inputClear() {
    // textController.clearComposing();
    if(widget.focusNode.hasFocus)textController.clear();
  }
  // void inputClear() => textController.text='';
  // bool get hasTextField => textController.text.isNotEmpty;
  void inputCancel() {
    // this.textController.text = store.searchQuery;
    hideKeyboard();
  }
  void inputSubmit(String word) {
    store.searchQuery = word;
  }

// W/IInputConnectionWrapper(19121): getTextBeforeCursor on inactive InputConnection
// W/IInputConnectionWrapper(19121): getSelectedText on inactive InputConnection
// W/IInputConnectionWrapper(19121): getTextAfterCursor on inactive InputConnection

}

class SearchView extends SearchState {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: widget.key,
      body: FutureBuilder(
        future: store.activeName(),
        builder: (BuildContext context, AsyncSnapshot e){
          if (e.hasData){
            // collectionGenerate(e);
            return body();
          } else if (e.hasError) {
            return WidgetError(message: e.error.toString());
          } else {
            return WidgetLoad();
          }
        }
      )
    );
  }

  CustomScrollView body() {
    return CustomScrollView(
      key: widget.key,
      controller: widget.scrollController,
      semanticChildCount: 0,
      slivers: <Widget>[
        new SliverPersistentHeader(
          pinned: true,
          floating: true,
          delegate: WidgetHeaderSliver(bar)
        ),
        new SliverPadding(
          padding: EdgeInsets.only(bottom: widget.focusNode.hasFocus?0:54),
          // padding: EdgeInsets.only(bottom: 54),
          sliver: widget.focusNode.hasFocus?suggest():result(),
        )
      ]
    );
  }

  Widget suggest(){
    return FutureBuilder(
      future: store.getCollectionKeyword(this.suggestQuery),
      builder: (BuildContext context, AsyncSnapshot<List<CollectionKeyword>> snapshot) => _SearchSuggestion(
        query: this.suggestQuery,
        suggestion:snapshot,
        onSelected: (String suggestion) {
          this.textController.text = suggestion;
          this.inputSubmit(suggestion);
          this.hideKeyboard();
        }
      )
    );
  }

  Widget result(){
    if (this.searchQuery.isEmpty) return page();
    return FutureBuilder(
      future: store.verseSearchTesting(this.searchQuery),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) => _SearchResult(query:this.searchQuery, result:snapshot)
    );
  }
  Widget page(){
    return new SliverFillRemaining(
      child: Center(
        // child: Text('search a word or two')
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: '...search \na ',
            style: Theme.of(context).textTheme.subhead,
            children: <TextSpan>[
              TextSpan(
                text: 'word',
                style: Theme.of(context).textTheme.subhead.copyWith(color: Colors.red,fontSize: 23),
              ),
              TextSpan(
                text: ' or ',
              ),
              TextSpan(
                text: 'two',
                style: Theme.of(context).textTheme.subhead.copyWith(color: Colors.red,fontSize: 17),
              ),
              TextSpan(
                text: '\n in verses!',
              )
            ]
          )
        )
      )
    );
  }

  Row bar(BuildContext context,double offset,bool overlaps, double stretch,double shrink){
    shrinkOffsetPercentage = stretch;
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 12,vertical: 7*shrink),
            // padding: EdgeInsets.symmetric(vertical: 4*stretch),
            // decoration: BoxDecoration(
            //   color: Colors.grey[300],
            //   borderRadius: BorderRadius.all(Radius.circular(100)),
            // ),
            child: input(stretch,shrink)
            // child: AnimatedSize(
            //   vsync: this,
            //   // curve: Curves.easeOut,
            //   duration: Duration(milliseconds: 300),
            //   child: input(stretch,shrink)
            // )
          )
        ),
        searchCancel()
      ]
    );

  }
  Widget searchCancel(){
    // return Container(
    //     child: AnimatedSize(
    //       vsync: this,
    //       duration: Duration(milliseconds: 300),
    //       child: InkWell(
    //         splashColor: Colors.transparent,
    //         highlightColor: Colors.transparent,
    //         child: Padding(
    //           padding: EdgeInsets.only(right: widget.focusNode.hasFocus?12:0),
    //           child: Text(widget.focusNode.hasFocus?'Cancel':'',style: TextStyle(color: Colors.black87,fontSize: 12),),
    //         ),
    //         onTap: inputCancel,
    //       )
    //     )
    //   );
    if (widget.focusNode.hasFocus) return Container(
        child: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.only(right: 12),
            child: Text('Cancel',style: TextStyle(color: Colors.black87,fontSize: 12),),
          ),
          onTap: inputCancel,
        )
      );
    return Container();
  }

  TextFormField input(double stretch,double shrink){
    return TextFormField(
      controller: textController,
      focusNode: widget.focusNode,
      autofocus: false,
      autovalidate: false,
      textInputAction: TextInputAction.search,
      keyboardType: TextInputType.text,
      onFieldSubmitted: inputSubmit,
      textAlign: widget.focusNode.hasFocus?TextAlign.start:TextAlign.center,

      style: TextStyle(
        fontFamily: 'sans-serif',
        // fontSize: (10+(15-10)*stretch),
        height: 0.9,
        fontSize: 15 - (2*stretch),
        color: Colors.black
      ),
      decoration: InputDecoration(
        // isDense: true,
        // (widget.focusNode.hasFocus && textController.text.isNotEmpty)?
        suffixIcon: Opacity(
          opacity: shrink,
          child: SizedBox.shrink(
            child:(widget.focusNode.hasFocus && textController.text.isNotEmpty)?InkWell(
              child: Icon(Icons.cancel,color:Colors.grey,size: 13,),
              onTap: inputClear
            ):null
          )
        ),
        prefixIcon: Container(
          // constraints: BoxConstraints(
          //   maxHeight:20,
          //   maxWidth: 20
          // ),
          // color: Colors.red,
          child: Icon(Icons.search,color:Colors.grey[400],size: 15,),
        ),
        hintText: " ...search Verse",
        // hintStyle: TextStyle(color: Colors.grey),
        contentPadding: EdgeInsets.symmetric(horizontal: 15,vertical: (3*shrink)),
        // fillColor: Color(0xffeff1f4).withOpacity(shrink),
        fillColor: Colors.grey[widget.focusNode.hasFocus?200:100].withOpacity(shrink),
        // fillColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(shrink),
        // fillColor: Theme.of(context).backgroundColor.withOpacity(shrink),
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300].withOpacity(shrink), width: 0.1),
          borderRadius: BorderRadius.all(Radius.circular(3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[200].withOpacity(shrink), width: 0.1),
          borderRadius: BorderRadius.all(Radius.circular(3)),
        ),
        // border: OutlineInputBorder(
        //   borderSide: BorderSide(color: Colors.grey, width: 0.1),
        //   borderRadius: BorderRadius.all(Radius.circular(3)),
        // )
      )
    );
  }
}

class _SearchResult extends StatelessWidget {
  const _SearchResult({this.query, this.result});
  final String query;
  final AsyncSnapshot<List> result;

  @override
  Widget build(BuildContext context) {
    if (result.hasError) {
      return new SliverFillRemaining(
        child: WidgetError(message: result.error)
      );
    }

    if (result.hasData) {
      if (result.data.length > 0) {
        // Store().getCollectionKeyword(query,add: true);
        return new SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) => _books(context, result.data[index]),
            childCount: result.data.length
          )
        );
      } else {
        return new SliverFillRemaining(
          child: Center(
            // child: Text('$query ...no verse found!')
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: '"',
                style: Theme.of(context).textTheme.subhead,
                children: <TextSpan>[
                  TextSpan(
                    text: query,
                    style: Theme.of(context).textTheme.subhead.copyWith(color: Colors.red,fontSize: 19),
                  ),
                  TextSpan(
                    text: '"\n...found no verse!',
                  ),
                ],
              ),
            ),
          )
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
                  fontSize: 10
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
                  children: _getSpans(verse['text'], query, style),
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


class _SearchSuggestion extends StatelessWidget {
  const _SearchSuggestion({this.query, this.suggestion, this.onSelected});
  final AsyncSnapshot<List<CollectionKeyword>> suggestion;
  final String query;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {

    if (suggestion.hasError) {
      return new SliverFillRemaining(
        child: WidgetError(message: suggestion.error)
      );
    }
    if (suggestion.hasData) {
      return new SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) => _item(context, suggestion.data[index]),
          childCount: suggestion.data.length
        )
      );
    }
    return new SliverFillRemaining();
  }
  Widget _item(BuildContext context, CollectionKeyword keyword){
    return ListTile(
      leading: const Icon(Icons.subdirectory_arrow_right,color: Colors.black26),
      title: RichText(
        text: TextSpan(
          text: keyword.word.substring(0, query.length),
          style: Theme.of(context).textTheme.subhead.copyWith(fontWeight: FontWeight.w500),
          children: <TextSpan>[
            TextSpan(
              text: keyword.word.substring(query.length),
              style: Theme.of(context).textTheme.subhead,
            ),
          ],
        ),
      ),
      onTap: () => onSelected(keyword.word)
    );
  }
}