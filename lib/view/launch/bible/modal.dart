part of 'main.dart';

// _Sheet _Sheet
mixin _Modal on _State {
  Future showModal(BookType book) {
    return showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      builder: (BuildContext context) => _ModalSheet(book: book, core: core),
      barrierColor: Theme.of(context).backgroundColor.withOpacity(0.5),
      // barrierColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }
}

class _ModalSheet extends StatefulWidget {
  final BookType book;
  final Core core;

  const _ModalSheet({
    Key? key,
    required this.book,
    required this.core,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ModalSheetState();
}

class _ModalSheetState extends State<_ModalSheet> {
  bool isDownloading = false;
  String message = '';

  Core get core => widget.core;
  BookType get book => widget.book;

  Preference get preference => core.preference;

  // final core = Core();
  // CollectionBible get bible => widget.bible;
  bool get isAvailable => book.available > 0;

  void updateAvailableAction() async {
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
    core.switchAvailabilityUpdate(book.identify).then((_) {
      setState(() {
        isDownloading = !isDownloading;
        message = 'finish';
      });

      Future.delayed(const Duration(milliseconds: 300), () {
        Navigator.pop(context, 'done');
      });

      // store.googleAnalytics.then((e)=>e.sendEvent(store.identify, store.appVersion));
    }).catchError((error) {
      setState(() {
        isDownloading = !isDownloading;
        debugPrint('33: $error');
        if (error is String) {
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
    // return Material(
    //   clipBehavior: Clip.hardEdge,
    //   elevation: 10,
    //   borderRadius: const BorderRadius.all(Radius.elliptical(5, 3)),
    //   // shadowColor: Colors.grey,
    //   color: Theme.of(context).primaryColor,
    //   child: _body(),
    // );
    return Container(
      margin: const EdgeInsets.only(top: 1),
      decoration: BoxDecoration(
        // color: Theme.of(context).scaffoldBackgroundColor,
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.elliptical(3, 3),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 0,
            color: Theme.of(context).backgroundColor,
            spreadRadius: 0,
            offset: const Offset(0, -1),
          )
        ],
      ),
      child: _body(),
    );
  }

  Widget _body() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
          child: Text(
            widget.book.name,
            textAlign: TextAlign.center,
            semanticsLabel: widget.book.name,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: widget.book.year.toString(),
            style: Theme.of(context).textTheme.titleLarge,
            children: <TextSpan>[
              const TextSpan(text: '/'),
              TextSpan(text: widget.book.langName.toUpperCase()),
              TextSpan(
                text: '\n(${widget.book.identify})',
              ),
              // TextSpan(text:book.publisher)
            ],
          ),
        ),
        if (message.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(message),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          /*
          child: ElevatedButton.icon(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                // isAvailable?Colors.red: Colors.black45
                isAvailable ? Colors.red : Theme.of(context).scaffoldBackgroundColor,
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  // side: BorderSide(color: Colors.red)
                ),
              ),
            ),
            // style: TextButton.styleFrom(primary: Colors.green),
            icon: isDownloading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 1,
                      backgroundColor: Colors.grey[200],
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.grey),
                    ))
                : Icon(
                    isAvailable ? Icons.remove_circle : Icons.add_circle,
                    size: 20.0,
                  ),
            label: Text(
              isAvailable ? 'Delete' : 'Download',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, height: 1.05),
            ),
            onPressed: isDownloading ? null : updateAvailableAction,
          ),
          */
          child: CupertinoButton(
            color: Theme.of(context).highlightColor,
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 15),
            borderRadius: const BorderRadius.all(Radius.circular(100)),
            child: Chip(
              // backgroundColor: isAvailable ? null : Theme.of(context).backgroundColor,
              // backgroundColor: isAvailable ? null : Theme.of(context).backgroundColor,
              // backgroundColor: Theme.of(context).primaryColor,
              padding: EdgeInsets.zero,
              // labelPadding: EdgeInsets.zero,
              // avatar: Icon(
              //   isAvailable ? Icons.remove_circle : Icons.add_circle,
              // ),
              // avatar: const SizedBox(
              //   width: 20,
              //   height: 20,
              //   child: CircularProgressIndicator(
              //     strokeWidth: 1.5,
              //     value: 1.0,
              //     // backgroundColor: Theme.of(context).primaryColor,
              //     // valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
              //   ),
              // ),
              avatar: isDownloading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                      ),
                    )
                  : Icon(
                      isAvailable ? Icons.remove_circle : Icons.add_circle,
                      size: 30,
                      color: Theme.of(context).primaryColor,
                    ),
              label: Text(
                isAvailable ? preference.text.delete : preference.text.download,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
              ),
            ),
            onPressed: isDownloading ? null : updateAvailableAction,
          ),
        ),
      ],
    );
  }
}
