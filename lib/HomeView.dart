// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';

import 'package:laisiangtho/StoreModel.dart';
import 'package:laisiangtho/Home.dart';
import 'package:laisiangtho/WidgetCommon.dart';

class HomeView extends HomeState {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: FutureBuilder(
        future: store.bookList,
        builder: (BuildContext context, AsyncSnapshot<List<ModelBible>> e){
          if (e.hasData){
            booksGenerate(e);
            return _buildBody();
          } else if (e.hasError) {
            return WidgetError(message: e.error);
          } else {
            return WidgetLoad();
          }
        }
      )
    );
  }

  Widget _buildBody() {
    return CustomScrollView(
      key: scaffoldKey,
      controller: scrollController,
      slivers: <Widget>[
        SliverAppBar(
          // backgroundColor: Theme.of(context).backgroundColor,
          // pinned: true,
          elevation: 0,
          expandedHeight: 150.0,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              store.appTitle,
              style: TextStyle(
                color: Colors.grey,
                shadows: <Shadow>[
                  Shadow(offset: Offset(0, 1),blurRadius:15,color: Colors.white)
                ],
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate([_testingView(),_offlineView(),_availableView()]),
        )
      ]
    );
  }

  Widget _testingView() {
    return Container(
      // color: Theme.of(context).backgroundColor,
      child: Container(
        child: Column(
          children: <Widget>[
            FlatButton(
              child: Text('Note'),
              onPressed: ()=> Navigator.pushNamed(context, 'note')
            ),
            FlatButton(
              child: Text('Tab'),
              onPressed: ()=> Navigator.pushNamed(context, 'tab')
            ),
            FlatButton(
              child: Text('CustomScrollOne'),
              onPressed: ()=> Navigator.pushNamed(context, 'CustomScrollOne')
            ),
            FlatButton(
              child: Text('ScrollsAnimation'),
              onPressed: ()=> Navigator.pushNamed(context, 'ScrollsAnimation')
            ),
            FlatButton(
              child: Text('Testing'),
              onPressed: ()=> Navigator.pushNamed(context, 'Testing')
            )
          ],
        )
      ),
    );
  }

  Widget _offlineView() {
    return Container(
      // color: Theme.of(context).backgroundColor,
      child: Container(
        margin: new EdgeInsets.all(15),
        // padding: new EdgeInsets.all(5),
        // alignment: Alignment.topCenter,
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(2)),
          color: Colors.white,
          boxShadow: [
            new BoxShadow(color: Colors.grey[500], offset: Offset(0, -1),spreadRadius: 0.1,blurRadius: 1)
          ]
        ),
        child: _offlineList(booksOffline)
      ),
    );
  }

  Widget _offlineList(List<ModelBible> e) {
    return Container(
      child: ListView.separated(
        padding: EdgeInsets.only(top: 0),
        separatorBuilder: (context, index) => Divider(
          color: Colors.grey[100], height: 1, indent: 0,
        ),
        itemCount:e.length,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) => _offlineItem(e[index])
      )
    );
  }

  Widget _offlineItem(ModelBible book) {
    return new ListTile(
      // contentPadding: EdgeInsets.symmetric(horizontal: 10),
      dense: true,
      // leading: new Text(book.lang.toUpperCase(),style: TextStyle(color: Colors.grey, fontSize: 10)),
      title: Text(
        book.name, maxLines: 1, overflow: TextOverflow.ellipsis,
        style: TextStyle(fontWeight: FontWeight.w300)
      ),
      // isThreeLine: true,
      // subtitle: Text(
      //   ${book.year}, maxLines: 1, overflow: TextOverflow.ellipsis,
      //   style: TextStyle(fontWeight: FontWeight.w300, fontSize: 9)
      // ),
      // trailing: Icon(Icons.keyboard_arrow_right, color: Colors.indigo, size: 20.0),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(book.shortname,style: TextStyle(fontWeight: FontWeight.w300, color: Colors.blueAccent, fontSize: 9)),
          // Text('${book.year}',style: TextStyle(fontWeight: FontWeight.w300, color: Colors.blueAccent, fontSize: 9)),
          Icon(Icons.keyboard_arrow_right, color: Colors.blueAccent, size: 20.0)
        ],
      ),
      onTap:()=>toBible(book)
    );
  }

  Widget _availableView() {
    return Container(
      // color: Theme.of(context).backgroundColor,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(''),
              ),
              new IconButton(
                icon: isLoading?SizedBox(width:12, height:12,
                  child:CircularProgressIndicator(strokeWidth: 1)
                ):new Icon(Icons.refresh),
                color: Colors.blue,
                iconSize: 20,
                onPressed: updateButtonCallBack
              ),
              new IconButton(
                icon: new Icon(Icons.sort),
                color: Colors.grey,
                iconSize: 18,
                onPressed: null,
              )
            ]
          ),
          Container(
            margin: new EdgeInsets.all(15),
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(2)),
              color: Colors.white,
              boxShadow: [
                new BoxShadow(color: Colors.grey, offset: Offset(0, 1),spreadRadius: 0.2,blurRadius: 0.7)
              ]
            ),
            child: _availableList(booksAvailable),
          )
        ]
      )
    );
  }

  Widget _availableList(List<ModelBible> e) {
    return ListView.separated(
      padding: EdgeInsets.only(top: 0),
      separatorBuilder: (context, index) => Divider(
        color: Colors.grey[100], height: 1, indent: 0,
      ),
      itemCount:e.length,
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) => _availableItem(e[index])
    );
  }

  Widget _availableItem(ModelBible book) {
    return ListTile(
      // contentPadding: EdgeInsets.symmetric(horizontal: 10),
      dense: true,
      // leading: Container(
      //   child: new Text(book.year.toString(),style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w300, fontSize: 13,height: 1))
      // ),
      title: Text(
        book.name, maxLines: 1, overflow: TextOverflow.ellipsis,
        style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12, height: 1)
      ),
      subtitle: Text(book.shortname,style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w300, fontSize: 9, height: 1)),
      trailing: _availableIcon(book.available > 0),
      onTap:()=>toBook(book)
    );
  }

  Widget _availableIcon(bool isAvailable){
    return InkWell(
      child: Icon(
        Icons.cloud_done,
        color: isAvailable?Colors.grey[500]:Colors.grey[200],
        size: 20.0
      ),
      // onTap: (){
      //   print('_availableIcon');
      // }
    );
  }

}