part of 'main.dart';

mixin _Bar on _State {
  Widget bar(bool innerBoxIsScrolled){
    return SliverAppBar(
      pinned: true,
      floating: true,
      // snap: false,
      centerTitle: true,
      elevation: 0.7,
      forceElevated: innerBoxIsScrolled,
      title: _barTitle(),
      // expandedHeight: 120,
      // backgroundColor: innerBoxIsScrolled?Theme.of(context).primaryColor:Theme.of(context).scaffoldBackgroundColor,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.elliptical(3, 2)
        ),
      ),
      automaticallyImplyLeading: false,
      leading: Navigator.canPop(context)?IconButton(
        icon: Icon(CupertinoIcons.back, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(),
      ):null,
      actions: [
        WidgetHint(
          label: "Shop",
          message: "Restore purchase",
          child: CupertinoButton(
            child: Icon(Icons.restore),
            // child: Icon(MyOrdbokIcon.history),
            onPressed: () async {
              // await InAppPurchase.instance.restorePurchases().whenComplete(() =>setState);
              // core.store.doRestore().whenComplete((){
              //    ScaffoldMessenger.of(context).showSnackBar(
              //     SnackBar(
              //       content: const Text('Restore purchase completed.'),
              //     ),
              //   );
              // });
            }
          ),
        )
      ],
      // flexibleSpace: LayoutBuilder(
      //   builder: (BuildContext context, BoxConstraints constraints) {
      //     double top = constraints.biggest.height;
      //     return FlexibleSpaceBar(
      //       centerTitle: true,
      //       title: AnimatedOpacity(
      //         duration: Duration(milliseconds: 200),
      //         // opacity: top > 71 && top < 91 ? 1.0 : 0.0,
      //         opacity: top < 120 ? 0.0 : 1.0,
      //         child: Text(
      //           "...",
      //           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      //         )
      //       ),
      //     );
      //   }
      // ),
    );
  }

  Widget _barTitle() {
    return Semantics(
      label: "Page",
      child: Text(
        'Setting',
        semanticsLabel: 'Setting',
        // style: Theme.of(context).textTheme.headline3!.copyWith(fontWeight:FontWeight.w400),
        // style: TextStyle(
        //   // fontFamily: "sans-serif",
        //   // color: Color.lerp(Colors.white, Colors.white24, stretch),
        //   // color: Colors.black,
        //   // fontWeight: FontWeight.w300,
        //   // fontWeight: FontWeight.lerp(FontWeight.w200, FontWeight.w300, stretch),
        //   // fontSize:35.0,
        //   // fontSize:(35*stretch).clamp(25.0, 35.0),
        //   // shadows: <Shadow>[
        //   //   Shadow(offset: Offset(0, 1),blurRadius:1,color: Colors.black87)
        //   // ]
        // )
      )
    );
  }
}
