import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// import 'StoreModel.dart';
// import 'Store.dart';
// import 'Common.dart';

import 'Search.dart';
import 'SearchSuggestion.dart';
import 'SearchResult.dart';

class SearchView extends SearchState {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: FutureBuilder(
        future: store.activeName(),
        builder: (BuildContext context, AsyncSnapshot e){
          if (e.hasData){
            return body();
          } else if (e.hasError) {
            if (store.identify.isEmpty){
              return WidgetEmptyIdentify(message: 'search',);
            } else {
              return WidgetError(message: e.error.toString());
            }
          } else {
            return WidgetLoad();
          }
        }
      )
    );
  }

  CustomScrollView body() {
    return CustomScrollView(
      controller: store.scrollController,
      // semanticChildCount: 1,
      slivers: <Widget>[
        new SliverPersistentHeader(pinned: true,floating: true,delegate: WidgetHeaderSliver(bar)),
        new SliverPadding(
          padding: EdgeInsets.only(bottom: store.contentBottomPadding),
          // store.focusNode.hasFocus?0:
          sliver: store.focusNode.hasFocus?suggest():result(),
        )
      ]
    );
  }

  Widget suggest(){
    return FutureBuilder(
      future: store.getCollectionKeyword(this.suggestQuery),
      builder: (BuildContext context, AsyncSnapshot<List<CollectionKeyword>> snapshot) => SearchSuggestion(
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
    if (store.searchQuery.isEmpty) return page();
    return FutureBuilder(
      future: store.verseSearchAllInOne(store.searchQuery),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) => new SearchResult(result:snapshot)
    );
  }

  Widget page(){
    // return new SliverToBoxAdapter(
    //   child: WidgetEmptyIdentify(atLeast: 'search\na',enable:' Word ',task: 'or two\nin ',message:'verses')
    // );
    return new SliverFillRemaining(
      child: WidgetEmptyIdentify(atLeast: 'search\na',enable:' Word ',task: 'or two\nin ',message:'verses')
    );
  }

  Row bar(BuildContext context,double offset,bool overlaps, double stretch,double shrink){
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
    if (store.focusNode.hasFocus) return Container(
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
      focusNode: store.focusNode,
      autofocus: false,
      autovalidate: false,
      textInputAction: TextInputAction.search,
      keyboardType: TextInputType.text,
      onFieldSubmitted: inputSubmit,
      textAlign: store.focusNode.hasFocus?TextAlign.start:TextAlign.center,

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
            child:(store.focusNode.hasFocus && textController.text.isNotEmpty)?InkWell(
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
        fillColor: Colors.grey[store.focusNode.hasFocus?200:100].withOpacity(shrink),
        // fillColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(shrink),
        // fillColor: Theme.of(context).backgroundColor.withOpacity(shrink),
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300].withOpacity(shrink), width: 0.1),
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[200].withOpacity(shrink), width: 0.1),
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        // border: OutlineInputBorder(
        //   borderSide: BorderSide(color: Colors.grey, width: 0.1),
        //   borderRadius: BorderRadius.all(Radius.circular(3)),
        // )
      )
    );
  }
}