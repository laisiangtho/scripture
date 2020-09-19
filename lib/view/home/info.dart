part of 'main.dart';

mixin _Info on _State {
  showInfo (CollectionBible bible) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => _SheetInfo(bible)
    )..whenComplete(() => setState(() {}));
  }
}

class _SheetInfo extends StatefulWidget {
  _SheetInfo(
    this.bible,
    {
      Key key,
    }
  ) : super(key: key);
  final CollectionBible bible;

  @override
  State<StatefulWidget> createState() => _SheetInfoState();
}

class _SheetInfoState extends State<_SheetInfo> {
  bool isDownloading=false;
  String message='';

  final core = new Core();

  CollectionBible get bible => widget.bible;
  bool get isAvailable => bible.available > 0;

  void updateAvailableAction() {
    setState(() {
      isDownloading = !isDownloading;
    });
    core.updateBibleAvailability(bible.identify).then((_){
      setState(() {
        isDownloading = !isDownloading;
        message = 'finish';
      });

      Future.delayed(const Duration(milliseconds: 300), () {
        Navigator.pop(context,'done');
      });

      // store.googleAnalytics.then((e)=>e.sendEvent(store.identify, store.appVersion));
    }).catchError((errorMessage){
      setState(() {
        isDownloading = !isDownloading;
        message = errorMessage;
      });
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.only(top:30),
      margin: EdgeInsets.only(top:3),
      decoration: BoxDecoration(
        // color: Theme.of(context).primaryColor,
        // borderRadius: new BorderRadius.vertical(
        //   top: Radius.circular(5),
        // ),
        // boxShadow: [
        //   BoxShadow(
        //     blurRadius: 1.0,
        //     // color: Theme.of(context).backgroundColor,
        //     color: Colors.black38,
        //     spreadRadius: 0.2,
        //     offset: Offset(0.0, .5),
        //   )
        // ]
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              bible.name,textAlign: TextAlign.end,
              semanticsLabel: bible.name,
              style: Theme.of(context).textTheme.headline5
            ),
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text:bible.year.toString(),
              style: Theme.of(context).textTheme.headline6,
              children: <TextSpan>[
                TextSpan(text:'/'),
                TextSpan(text:bible.language.name.toUpperCase()),
                TextSpan(
                  text:' (${bible.identify})',
                ),
                // TextSpan(text:book.publisher)
              ]
            )
          ),

          if(message.isNotEmpty) RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text:'\n',
              // style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 14),
              style: TextStyle(color:Colors.grey, fontSize: 21, fontWeight: FontWeight.w300),
              children: <TextSpan>[
                TextSpan(text:'...'),
                TextSpan(text:message,style: TextStyle(color:Colors.red)),
                TextSpan(text:'...'),
              ]
            )
          ),

          Padding(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: RaisedButton.icon(
              padding: EdgeInsets.symmetric(horizontal:15, vertical:10),
              color:isAvailable?Colors.red: Colors.black45,
              textColor: Colors.white,
              disabledTextColor: Colors.grey,
              disabledColor: Colors.grey[200],
              elevation: 0,
              highlightElevation: 0,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
              icon: isDownloading?SizedBox(width:20, height:20,
                child:CircularProgressIndicator(
                  strokeWidth: 1,
                  backgroundColor: Colors.grey[200],
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.grey),
                )
              ):new Icon(isAvailable?Icons.remove_circle:Icons.add_circle, size: 20.0,),
              label: Text(
                isAvailable?'Delete':'Download', textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,height: 1.05
                )
              ),
              onPressed: isDownloading?null:updateAvailableAction
            )
          ),
          // ConstrainedBox(
          //   constraints: new BoxConstraints(
          //     maxHeight: 300
          //   ),
          //   child: Padding(
          //     padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          //     child: SingleChildScrollView(
          //       child: RichText(
          //         textAlign: TextAlign.center,
          //         text: TextSpan(
          //           text:book.description == null?'...${book.name}':book.description,
          //           style: Theme.of(context).textTheme.body2
          //         )
          //       )
          //     )
          //   )
          // )
        ]
      ),
    );
  }

  // Widget decoration(BuildContext context){
  //   return Container(
  //     padding: EdgeInsets.only(top:30),
  //     // margin: EdgeInsets.only(top:30),
  //     decoration: BoxDecoration(
  //       color: Theme.of(context).backgroundColor,
  //       borderRadius: new BorderRadius.vertical(
  //         top: Radius.circular(5),
  //       ),
  //       boxShadow: [
  //         BoxShadow(
  //           blurRadius: 0.0,
  //           color: Theme.of(context).primaryColor,
  //           // color: Colors.black38,
  //           spreadRadius: 0.0,
  //           offset: Offset(0.0, .0),
  //         )
  //       ]
  //     ),
  //   );
  // }
}
