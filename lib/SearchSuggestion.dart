import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

import 'StoreModel.dart';
import 'Store.dart';
import 'Common.dart';


class SearchSuggestion extends StatefulWidget {
  SearchSuggestion({this.query, this.suggestion, this.onSelected});
  final AsyncSnapshot<List<CollectionKeyword>> suggestion;
  final String query;
  final ValueChanged<String> onSelected;

  @override
  _SearchSuggestionState createState() => _SearchSuggestionState();
}

class _SearchSuggestionState extends State<SearchSuggestion> {

  Store store = new Store();

  @override
  Widget build(BuildContext context) {

    if (widget.suggestion.hasError) {
      return new SliverFillRemaining(
        child: WidgetError(message: widget.suggestion.error)
      );
    }
    if (widget.suggestion.hasData) {
      return new SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) => _item(context, widget.suggestion.data,index),
          childCount: widget.suggestion.data.length
        )
      );
    }
    return new SliverFillRemaining();
  }

  Widget _item(BuildContext context, List<CollectionKeyword> o, int index){
    CollectionKeyword keyword = o[index];

    return Dismissible(
      key: Key(store.uniqueIdentify.toString()),
      onDismissed: (direction) {
        setState(() {
          o.removeAt(index);
        });
      },
      // background: Container(
      //   color: Colors.redAccent,
      //   child: Text('Delete background'),
      // ),
      background: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Container(
              alignment: Alignment(-0.7,0),
              color: Colors.red,
              child: Text('Delete',style: Theme.of(context).textTheme.title)
            ),
          )
        ],
      ),
      secondaryBackground: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Container(
              alignment: Alignment(0.7,0),
              color: Colors.red,
              child: Text('Delete',style: Theme.of(context).textTheme.title)
            ),
          )
        ],
      ),
      // secondaryBackground: Container(
      //   color: Colors.blue,
      //   child: Text('Delete secondaryBackground'),
      // ),
      child: new ListTile(
        leading: const Icon(Icons.subdirectory_arrow_right,color: Colors.black26),
        title: RichText(
          // strutStyle: StrutStyle(fontSize: 30),
          text: TextSpan(
            text: keyword.word.substring(0, widget.query.length),
            style: TextStyle(fontSize: 25,color: Colors.red),
            children: <TextSpan>[
              TextSpan(
                text: keyword.word.substring(widget.query.length),
                style: TextStyle(color: Colors.black)
              )
            ]
          )
        ),
        onTap: () => widget.onSelected(keyword.word)
      )
    );
    // return ListTile(
    //   leading: const Icon(Icons.subdirectory_arrow_right,color: Colors.black26),
    //   title: RichText(
    //     text: TextSpan(
    //       text: keyword.word.substring(0, widget.query.length),
    //       style: Theme.of(context).textTheme.subhead.copyWith(fontWeight: FontWeight.w500),
    //       children: <TextSpan>[
    //         TextSpan(
    //           text: keyword.word.substring(widget.query.length),
    //           style: Theme.of(context).textTheme.subhead,
    //         ),
    //       ],
    //     ),
    //   ),
    //   onTap: () => widget.onSelected(keyword.word)
    // );
  }
}