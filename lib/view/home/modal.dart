part of 'main.dart';

// _Sheet _Sheet
mixin _Modal on _State {
  showModal(BookType book){
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => _ModalSheet(book: book, core: core),
      barrierColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8)
    )..whenComplete(() => setState(() {}));
  }
}

class _ModalSheet extends StatefulWidget {
  final BookType book;
  final Core core;

  _ModalSheet({
    Key? key,
    required this.book,
    required this.core,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ModalSheetState();
}

class _ModalSheetState extends State<_ModalSheet> {
  bool isDownloading=false;
  String message='';

  Core get core => widget.core;
  BookType get book => widget.book;

  // final core = Core();
  // CollectionBible get bible => widget.bible;
  bool get isAvailable => this.book.available > 0;

  void updateAvailableAction() async{
    // setState(() {
    //   isDownloading = !isDownloading;
    // });
    // core.updateBibleAvailability(widget.book.identify).then((_){
    //   setState(() {
    //     isDownloading = !isDownloading;
    //     message = 'finish';
    //   });

    //   Future.delayed(const Duration(milliseconds: 300), () {
    //     Navigator.pop(context,'done');
    //   });

    //   // store.googleAnalytics.then((e)=>e.sendEvent(store.identify, store.appVersion));
    // }).catchError((errorMessage){
    //   setState(() {
    //     isDownloading = !isDownloading;
    //     message = errorMessage;
    //   });
    // });
    setState(() {
      isDownloading = !isDownloading;
    });
    core.switchAvailabilityUpdate(book.identify).then((_){
      setState(() {
        isDownloading = !isDownloading;
        message = 'finish';
      });

      Future.delayed(const Duration(milliseconds: 300), () {
        Navigator.pop(context,'done');
      });

      // store.googleAnalytics.then((e)=>e.sendEvent(store.identify, store.appVersion));
    }).catchError((error){
      setState(() {
        isDownloading = !isDownloading;
        debugPrint('33: $error');
        if (error is String){
          message = error;
        } else {
          message = message.toString();
        }
      });
    });

    // setState(() {
    //   isDownloading = !isDownloading;
    // });

    // await core.switchAvailabilityUpdate(book.identify).catchError(
    //   (errorMessage) {
    //     message = errorMessage;
    //   }
    // );

    // await Future.delayed(Duration(milliseconds: 1500), () {
    //   // Navigator.pop(context,'done');
    // });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.hardEdge,
      elevation:10,
      borderRadius: BorderRadius.all( Radius.elliptical(5,3)),
      shadowColor: Colors.grey,
      color: Theme.of(context).primaryColor,
      child: _body()
    );
  }

  Widget _body(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Text(
            widget.book.name,textAlign: TextAlign.end,
            semanticsLabel: widget.book.name,
            style: Theme.of(context).textTheme.headline3
          ),
        ),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text:widget.book.year.toString(),
            style: Theme.of(context).textTheme.headline6,
            children: <TextSpan>[
              TextSpan(text:'/'),
              TextSpan(text:widget.book.langName.toUpperCase()),
              TextSpan(
                text:' (${widget.book.identify})',
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
            style: TextStyle(fontSize: 25),
            children: <TextSpan>[
              TextSpan(text:'...'),
              TextSpan(text:message,style: TextStyle(color:Colors.red)),
              TextSpan(text:'...'),
            ]
          )
        ),

        Padding(
          padding: EdgeInsets.symmetric(vertical: 30),
          child: ElevatedButton.icon(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                // isAvailable?Colors.red: Colors.black45
                isAvailable?Colors.red: Theme.of(context).scaffoldBackgroundColor
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  // side: BorderSide(color: Colors.red)
                )
              )
            ),
            // style: TextButton.styleFrom(primary: Colors.green),
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
        )
      ]
    );
  }

}