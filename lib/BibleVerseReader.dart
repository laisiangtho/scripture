import 'package:flutter/material.dart';
import 'package:laisiangtho/StoreModel.dart';

class BibleVerseReader extends StatelessWidget {
  final AsyncSnapshot snapshot;
  BibleVerseReader({Key key, this.snapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Container verseContainerRichText(ModelVerse verse) => Container(
      // color: Colors.blue,
      // margin: EdgeInsets.symmetric(horizontal:30.0, vertical: 3.0),
      margin: EdgeInsets.symmetric(horizontal:0.0, vertical: 4.0),
      child: RichText(
        text:TextSpan(
          text:  verse.verseTitle!=null?'\n${verse.verseTitle}\n\n'.toUpperCase():'',
          style: TextStyle(color: Colors.black54,fontWeight: FontWeight.w300,fontSize: 10),
          children: <TextSpan>[
            TextSpan(
              text: '     ${verse.verse} ',
              style: TextStyle(color: Colors.red, fontSize: 10)
            ),
            TextSpan(
              text: verse.verseText,
              // Myanmar only -> info.book
              style: TextStyle(color: Colors.black,  fontSize:11),
            ),
          ]
        ),
      )
    );

    if (snapshot.hasError) print(snapshot.error);
    return snapshot.hasData? Container(
      // padding: EdgeInsets.all(4.0),
      child: ListView.builder(
        padding: EdgeInsets.only(top: 0),
        scrollDirection: Axis.vertical,
        // shrinkWrap: true,
        // physics: ScrollPhysics(),
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        // itemCount: 10,
        itemCount: snapshot.data.length,
        itemBuilder: (BuildContext context, int index) {
          return verseContainerRichText(snapshot.data[index]);
        }
      )
    ):Center(child: CircularProgressIndicator());
  }
}