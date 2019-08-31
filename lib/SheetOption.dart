import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'Common.dart';
import 'Store.dart';
import 'StoreModel.dart';

class SheetOption extends StatefulWidget {
  SheetOption(
    {
      Key key,
      this.setState,
      this.verse
    }
  ) : super(key: key);
  final VoidCallback setState;
  final List<String> verse;

  @override
  State<StatefulWidget> createState() => _StateSheet();
}

class _StateSheet extends State<SheetOption> {

  @protected
  Store store = new Store();

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return new WidgetSheet(
      child: view()
    );
  }
  get selectedVerse {
    List<String> list = [];
    return store.getVerseChapter.then((List<VERSE> e){
      widget.verse..sort((a, b) => a.compareTo(b))..forEach((id) {
        var o = e.where((i)=> i.verse == id).single;
        list.add(o.verse+': '+o.verseText);
      });
      return list.join("\n");
    });
  }
  Widget view(){
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      verticalDirection: VerticalDirection.up,
      children: <Widget>[
        CupertinoButton(
          padding: EdgeInsets.all(0),
          // child: Text('Copy'),
          child: Icon(Icons.content_copy),
          onPressed:(){
            selectedVerse.then((e){
              Clipboard.setData(new ClipboardData(text: e)).whenComplete((){
                Navigator.pop(context,'copy');
              });
            });
          }
        ),
        CupertinoButton(
          padding: EdgeInsets.all(0),
          // child: Text(widget.verse.length.toString()),
          child: Icon(Icons.bookmark_border),
          onPressed:(){}
        ),
        CupertinoButton(
          padding: EdgeInsets.all(0),
          child: Icon(Icons.share),
          onPressed:(){}
        ),
        CupertinoButton(
          padding: EdgeInsets.all(0),
          child: Icon(Icons.clear_all),
          onPressed:(){
            widget.verse.clear();
            Navigator.pop(context,'clear');
          }
        )
      ]
    );
  }
}