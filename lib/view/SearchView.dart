import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bible/component/scroll.dart';
import 'Search.dart';

class SearchView extends SearchState {

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: true,
      body: ScrollPage(
        controller: controller,
        child: _body(),
      ),
    );
  }

  Widget _body() {
    return CustomScrollView(
      controller: controller.master,
      // controller: controller,
      slivers: <Widget>[
        new SliverPersistentHeader(pinned: true,floating:true,delegate: new ScrollPageBarDelegate(bar,minHeight: 40, maxHeight: 50)),
        // new SliverToBoxAdapter(
        //   child: Center(
        //     child: RaisedButton(
        //       child: Text("bible to note"),
        //       onPressed: () {
        //         // controller.bottom.heightNotify.value=0.0;
        //         showSearch(context: context, delegate: DataSearch(listWords));
        //       },
        //     ),
        //   )
        // ),
        new SliverPadding(
          padding: EdgeInsets.only(bottom: controller.bottom.height),
          sliver: store.focusNode.hasFocus?suggest():result(),
        )
      ]
    );
  }

  Widget bar(BuildContext context,double offset,bool overlaps, double percentage){
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 12,vertical: 7*percentage),
            // padding: EdgeInsets.symmetric(vertical: 4*stretch),
            // decoration: BoxDecoration(
            //   color: Colors.grey[300],
            //   borderRadius: BorderRadius.all(Radius.circular(100)),
            // ),
            child: input(percentage)
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

  Widget input(double percentage){
    // return TextFormField(
    //   controller: textController,
    //   decoration: InputDecoration(
    //     fillColor: Colors.grey,
    //     focusColor: Colors.grey
    //   ),
    //   validator: (value) {
    //     if (value.isEmpty) {
    //       return 'Your email';
    //     }
    //     return null;
    //   },
    // );
    // return Focus(
    //   child: TextFormField(
    //     controller: textController,
    //     focusNode: store.focusNode,
    //     decoration: InputDecoration(
    //       fillColor: Colors.grey,
    //       focusColor: Colors.grey
    //     ),
    //     validator: (value) {
    //       if (value.isEmpty) {
    //         return 'Your email';
    //       }
    //       return null;
    //     },
    //   ),
    //   onFocusChange: (hasFocus) {
    //     if(hasFocus) {
    //       print('focus');
    //     }
    //   },
    // );
    double stretch = percentage;
    double shrink = percentage;
    return TextFormField(
      controller: textController,
      focusNode: store.focusNode,
      autofocus: false,
      autovalidate: false,
      textInputAction: TextInputAction.search,
      keyboardType: TextInputType.text,
      onFieldSubmitted: inputSubmit,
      // initialValue: null,
      // showCursor: false,
      // enableSuggestions: true,
      // keyboardAppearance: KeyBoardAapp,
      onSaved: (String value) {
        print('save $value');
      },
      onChanged: (String value){
        print('onchanged $value');
      },
      validator: (String value) {
        return value;
      },
      textAlign: store.focusNode.hasFocus?TextAlign.start:TextAlign.center,

      style: TextStyle(
        fontFamily: 'sans-serif',
        // fontSize: (10+(15-10)*stretch),
        height: 1,
        fontSize: 15 + (2*stretch),
        color: Colors.black
      ),
      decoration: InputDecoration(
        // labelText: 'Search',
        // isDense: true,
        // (widget.focusNode.hasFocus && textController.text.isNotEmpty)?
        suffixIcon: Opacity(
          opacity: shrink,
          child: SizedBox.shrink(
            child:(store.focusNode.hasFocus && textController.text.isNotEmpty)?InkWell(
              child: Icon(Icons.cancel,color:Colors.grey,size: 14),
              onTap: inputClear
            ):null
          )
        ),
        prefixIcon: Icon(Icons.search,color:Colors.grey[store.focusNode.hasFocus?100:400],size: 22),
        hintText: " ...search Verse",
        // hintStyle: TextStyle(color: Colors.grey),
        contentPadding: EdgeInsets.symmetric(horizontal: 1,vertical: (3*shrink)),
        // fillColor: Color(0xffeff1f4).withOpacity(shrink),
        fillColor: Colors.grey[store.focusNode.hasFocus?300:200].withOpacity(shrink),
        // fillColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(shrink),
        // fillColor: Theme.of(context).backgroundColor.withOpacity(shrink),
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300].withOpacity(shrink), width: 0.1),
          borderRadius: BorderRadius.all(Radius.circular(100)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[200].withOpacity(shrink), width: 0.1),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        // border: OutlineInputBorder(
        //   borderSide: BorderSide(color: Colors.red, width: 7),
        //   borderRadius: BorderRadius.all(Radius.circular(3)),
        // )
      )
    );
  }

  Widget searchCancel(){
    // if (store.focusNode.hasFocus) return Container(
    //     child: InkWell(
    //       splashColor: Colors.transparent,
    //       highlightColor: Colors.transparent,
    //       child: Padding(
    //         padding: EdgeInsets.only(right: 12,top: 3,bottom: 3),
    //         child: Text('Cancel',style: TextStyle(color: Colors.black87,fontSize: 14),),
    //       ),
    //       onTap: inputCancel,
    //     )
    //   );
    // return Container();
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      child: store.focusNode.hasFocus?InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.only(right: 12,top: 3,bottom: 3),
          child: Text('Cancel',style: TextStyle(color: Colors.black87,fontSize: 14),),
        ),
        onTap: inputCancel,
      ):null,
    );
  }

  Widget suggest(){
    // return FutureBuilder(
    //   future: store.getCollectionKeyword(this.suggestQuery),
    //   builder: (BuildContext context, AsyncSnapshot<List<CollectionKeyword>> snapshot) => SearchSuggestion(
    //     query: this.suggestQuery,
    //     suggestion:snapshot,
    //     onSelected: (String suggestion) {
    //       this.textController.text = suggestion;
    //       this.inputSubmit(suggestion);
    //       this.hideKeyboard();
    //     }
    //   )
    // );
    return new SliverToBoxAdapter(
      child: Center(
        child: RichText(
          textAlign: TextAlign.center,
          // strutStyle: StrutStyle(fontSize: 30.0, height: 0.7),
          text: TextSpan(
            text: 'hello',
            style: Theme.of(context).textTheme.subtitle2.copyWith(fontSize: 29, fontWeight: FontWeight.w300,color: Colors.grey),
            children: <TextSpan>[
              TextSpan(text:'\n'),
              TextSpan(text:textController.text),
            ]
          )
        )
      )
    );
  }

  Widget result(){
    // if (store.searchQuery.isEmpty) return page();
    // return FutureBuilder(
    //   future: store.getVerseSearchAllInOne(store.searchQuery),
    //   builder: (BuildContext context, AsyncSnapshot<List> snapshot) => new SearchResult(result:snapshot)
    // );
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => _resultItem(context, index),
        childCount: 13,
        // addAutomaticKeepAlives: true
      ),
    );
  }

  Widget _resultItem(BuildContext context, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 23),
      color: Color(Random().nextInt(0xffffffff)),
      child: Center(child: Text("result $index")),
    );
  }

}
/*
List<ListWords>  listWords = [
  ListWords('oneWord', 'OneWord definition'),
  ListWords('twoWord', 'TwoWord definition.'),
  ListWords('TreeWord', 'TreeWord definition'),
];

class ListWords {
  String titlelist;
  String definitionlist;

  ListWords(String titlelist, String definitionlist) {
    this.titlelist = titlelist;
    this.definitionlist = definitionlist;
  }
}

class DataSearch extends SearchDelegate<String> {

  final List<ListWords> listWords;

  DataSearch(this.listWords);


  @override
  List<Widget> buildActions(BuildContext context) {
    //Actions for app bar
    return [IconButton(icon: Icon(Icons.clear), onPressed: () {
      query = '';
    })];
  }

  @override
  Widget buildLeading(BuildContext context) {
    //leading icon on the left of the app bar
    return IconButton(
        icon: AnimatedIcon(icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // show some result based on the selection
    return Center(
      child: Text(query),

    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // show when someone searches for something
    // final suggestionList = query.isEmpty ? listWords : listWords.where((p) => p.startsWith(query)).toList();
    final suggestionList = query.isEmpty ? listWords : listWords.where((element) => true).toList();



    return ListView.builder(itemBuilder: (context, index) => ListTile(
      onTap: () {
        showResults(context);
      },
      trailing: Icon(Icons.remove_red_eye),
      title: RichText(
        text: TextSpan(
            text: suggestionList[index].titlelist.substring(0, query.length),
            style: TextStyle(
                color: Colors.red, fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                  text: suggestionList[index].titlelist.substring(query.length),
                  style: TextStyle(color: Colors.grey))
            ]),
      ),
    ),
      itemCount: suggestionList.length,
    );
  }
}

class ListSearch extends StatefulWidget {
  ListSearchState createState() => ListSearchState();
}

class ListSearchState extends State<ListSearch> {

  TextEditingController _textController = TextEditingController();

  static List<String> mainDataList = [
   "Apple",
   "Apricot",
   "Banana",
   "Blackberry",
   "Coconut",
   "Date",
   "Fig",
   "Gooseberry",
   "Grapes",
   "Lemon",
   "Litchi",
   "Mango",
   "Orange",
   "Papaya",
   "Peach",
   "Pineapple",
   "Pomegranate",
   "Starfruit"
  ];

  // Copy Main List into New List.
  List<String> newDataList = List.from(mainDataList);

  onItemChanged(String value) {
    setState(() {
      newDataList = mainDataList
          .where((string) => string.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Search Here...',
              ),
              onChanged: onItemChanged,
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(12.0),
              children: newDataList.map((data) {
                return ListTile(
                  title: Text(data),
                  onTap: ()=> print(data),);
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}
*/