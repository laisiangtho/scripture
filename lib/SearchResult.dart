import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'SearchResultBook.dart';
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
            (BuildContext context, int index) => _books(context, result.data,index), childCount: result.data.length
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

  Widget _books(BuildContext context, List o,int index){
    Map book = o[index];
    List<String> chapters = [];
    List<String> verses = [];
    for (Map chapter in book['child']) {
      chapters.add(chapter['id'].toString());
      for (Map verse in chapter['child']) {
        verses.add(verse['id']);
      }
    }
    // bool isTestament=int.parse(book['id']) > 39?false:true;
    bool isTestament=book['id'] > 39?false:true;
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isTestament?Colors.grey:Colors.red,
        child: Text((++index).toString()),
      ),
      title: Text(book['name'],style: Theme.of(context).textTheme.headline),
      // subtitle: Text('Chapter: 1, 2, 4, 6...'),
      // trailing: Text('Verse: 120'),
      subtitle: RichText(
        text: TextSpan(
          text: 'Chapter: ',
          style: Theme.of(context).textTheme.caption,
          children: <TextSpan>[
            TextSpan(
              text: chapters.join(', '),
              style: Theme.of(context).textTheme.subhead.copyWith(fontSize: 14),
            ),
            TextSpan(
              text: '...'
            )
          ]
        ),

      ),
      trailing: RichText(
        text: TextSpan(
          text: 'Verse: ',
          style: Theme.of(context).textTheme.caption,
          children: <TextSpan>[
            TextSpan(
              text: verses.length.toString(),
              style: Theme.of(context).textTheme.subhead.copyWith(fontSize: 15),
            )
          ]
        )
      ),
      onTap: (){
        Navigator.push(
          context, MaterialPageRoute(builder: (BuildContext context) => new SearchResultBook(book:book))
        ).then((e){
          if (e != null) {
            store.bookId = e['book'];
            store.chapterId = e['chapter'];
            store.pageController.jumpToPage(1);
          }
        });
      },
    );
  }
}