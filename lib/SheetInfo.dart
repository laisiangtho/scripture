import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Common.dart';
import 'Store.dart';
import 'StoreModel.dart';

class SheetInfo extends StatefulWidget {
  SheetInfo(
    this.book,
    {
      Key key,
    }
  ) : super(key: key);
  final CollectionBook book;

  @override
  State<StatefulWidget> createState() => _StateSheet();
}

class _StateSheet extends State<SheetInfo> {
  bool isDownloading=false;

  @protected
  Store store = new Store();

  @override
  void initState() {
    super.initState();
    store.identify = widget.book.identify;
  }

  @override
  Widget build(BuildContext context) {
    return new WidgetSheet(
      child: view(widget.book)
    );
  }

  void updateAvailableAction() {
    // _bottomSheet?
    setState(() {
      isDownloading = !isDownloading;
    });
    store.updateCollectionAvailable().catchError((_e){
      print(_e);
    }).then((_isAvailable){
      setState(() {
        isDownloading = !isDownloading;
      });
      Navigator.pop(context,'done');
    });
  }

  Widget view(CollectionBook book){
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Align(
                alignment: Alignment(0.26,0.0),
                child: Text(book.name,textAlign: TextAlign.end,style: Theme.of(context).textTheme.headline.copyWith(color: Colors.white70,fontSize: 17)),
              ),
            ),
            CupertinoButton(
              child: Icon(Icons.keyboard_arrow_down,color: Colors.white),
              onPressed: ()=>Navigator.pop(context,'done'),
            )
          ]
        ),
        RichText(
          text: TextSpan(
            text:book.year.toString(),
            style: Theme.of(context).textTheme.subhead.copyWith(color: Colors.white24),
            children: <TextSpan>[
                TextSpan(text:'/'),
                TextSpan(text:book.language.name.toUpperCase())
            ]
          )
        ),

        Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: RaisedButton.icon(
            color: Colors.grey[400],
            textColor: Colors.white,
            disabledTextColor: Colors.white,
            elevation: 0,
            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
            disabledColor: Colors.grey,
            icon: isDownloading?SizedBox(width:13, height:13,
              child:CircularProgressIndicator(strokeWidth: 1)
            ):new Icon(book.available > 0?Icons.delete:Icons.cloud_download),
            label: Text(book.available > 0?'Delete':'Download'),
            onPressed: isDownloading?null:updateAvailableAction
          )
        ),
        ConstrainedBox(
          constraints: new BoxConstraints(
            maxHeight: 300
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: SingleChildScrollView(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text:book.description == null?'...${book.name}':book.description,
                  style: Theme.of(context).textTheme.body2.copyWith(color: Colors.white)
                )
              )
            )
          )
        )
      ]
    );
  }
}

/*

  void updateAvailableAction() {
    // _bottomSheet?
    setState(() {
      isDownloading = true;
      updateAvailableCallBack = null;
    });
    bottomSheet?.setState(() { });
    store.updateCollectionAvailable().catchError((_e){
      print(_e);
    }).then((_isAvailable){
      setState(() {
        isDownloading = false;
        updateAvailableCallBack = updateAvailableAction;
      });
      bottomSheet?.setState(() { });
      bottomSheet?.close();
    });
    // bottomSheet.setState(() { });
  }

  void _showConfigurationSheet(CollectionBook book) {
    if (bottomSheet == null) {
      _showBottomSheet(book);
    } else {
      bottomSheet?.close();
    }
  }
  void _showBottomSheet(CollectionBook book) {
    setState(() {
      store.identify = book.identify;
      bottomSheet = scaffoldKey.currentState.showBottomSheet<void>((BuildContext bottomSheetContext) {
        return ConstrainedBox(
          constraints: new BoxConstraints(
            // minHeight: 35.0,
            // maxHeight: MediaQuery.of(context).size.height - 180,
          ),
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(7)),
              color: Colors.grey,
            ),
            margin: EdgeInsets.only(top: 0, left: 1, right: 1),
            // padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            // height: MediaQuery.of(context).size.height - 200,
            width: MediaQuery.of(context).size.width,
            // child: Text(book.name),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: Text(book.name,style: Theme.of(context).textTheme.headline.copyWith(color: Colors.white70,fontSize: 17))
                  )
                ),
                RichText(
                  text: TextSpan(
                    text:book.year.toString(),
                    style: Theme.of(context).textTheme.subhead.copyWith(color: Colors.white24),
                    children: <TextSpan>[
                       TextSpan(text:'/'),
                       TextSpan(text:book.language.name.toUpperCase())
                    ]
                  )
                ),

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: RaisedButton.icon(
                    color: Colors.grey[400],
                    textColor: Colors.white,
                    disabledTextColor: Colors.white,
                    elevation: 1.0,
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                    disabledColor: Colors.grey,
                    icon: isDownloading?SizedBox(width:13, height:13,
                      child:CircularProgressIndicator(strokeWidth: 1)
                    ):new Icon(book.available > 0?Icons.delete:Icons.cloud_download),
                    label: Text(book.available > 0?'Delete':'Download'),
                    onPressed: updateAvailableCallBack,
                  )
                ),
                ConstrainedBox(
                  constraints: new BoxConstraints(
                    maxHeight: 300
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    child: SingleChildScrollView(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text:book.description == null?'...${book.name}':book.description,
                          style: Theme.of(context).textTheme.body2.copyWith(color: Colors.white)
                        )
                      )
                    )
                  )
                )
              ]
            )
          )
        );
      });

      // Garbage collect the bottom sheet when it closes.
      bottomSheet.closed.whenComplete(() {
        if (mounted) {
          setState(() {
            bottomSheet = null;
          });
        }
      });
    });
  }
*/