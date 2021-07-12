part of 'main.dart';

mixin _Bar on _State {
  Widget bar() {
    return new SliverPersistentHeader(
      pinned: true,
      floating:false,
      delegate: new ViewHeaderDelegate(
        Navigator.canPop(context)?_barPopup:_barMain,
        // maxHeight: widget.barMaxHeight
        maxHeight: 116,
        minHeight: 56 + MediaQuery.of(context).padding.top,
      )
    );
  }

  Widget _barPopup(BuildContext context,double offset,bool overlaps, double shrink, double stretch){
    return ViewHeaderDecoration(
      overlaps: stretch >= 0.5,
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment(-.95,0),
            child: CupertinoButton(
              onPressed: () => Navigator.of(context).pop(),
              padding: EdgeInsets.zero,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  new Icon(
                    // Icons.arrow_back_ios,
                    LaiSiangthoIcon.left_open_big,
                    // size: 27,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text('Back'),
                  )
                ],
              )
            ),
          ),
          // if (widget.title != null)Align(
          //   // alignment: Alignment.lerp(Alignment(-0.2,0.5),Alignment(-0.5,-.4), stretch),
          //   alignment: Alignment(-.6,0),
          //   child: _barTitle(shrink)
          // ),
          Align(
            alignment: Alignment(.95,0),
            child: _barSortButton(),
          ),
        ]
      )
    );
  }

  Widget _barMain(BuildContext context,double offset,bool overlaps, double shrink, double stretch){
    return ViewHeaderDecoration(
      overlaps: stretch >= 0.5,
      child: Stack(
        children: <Widget>[
          // Align(
          //   alignment: Alignment.lerp(Alignment(0.5,0),Alignment(-0.7,0), stretch),
          //   child:Transform.rotate(
          //     angle:6*shrink,
          //     child: Container(
          //       child: Text(core.version),
          //       padding: EdgeInsets.all(2),
          //       decoration: BoxDecoration(
          //         color: Theme.of(context).backgroundColor,
          //         borderRadius: new BorderRadius.all(Radius.circular(3))
          //       )
          //     )
          //   )
          // ),
          Align(
            // alignment: Alignment.lerp(Alignment(-0.5,0.5),Alignment(-0.7,-.1), stretch)!,
            alignment: Alignment.lerp(Alignment(0.0,0.8),Alignment(0.0,0.0), stretch)!,
            // alignment: Alignment(-.9,0),
            child: _barTitle(shrink)
          ),
          // Align(
          //   alignment: Alignment(1,1),
          //   child: Text('Abc')
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   crossAxisAlignment: CrossAxisAlignment.end,
          //   children: <Widget>[
          //     _barSortButton()
          //   ]
          // ),
          Align(
            // alignment: Alignment(.95,-1),
            alignment: Alignment(1,-1),
            child: Padding(
              padding: EdgeInsets.only(top: 4, right: 5),
              child: _barSortButton(),
            )
          ),
        ]
      )
      // child: Row(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   crossAxisAlignment: CrossAxisAlignment.stretch,
      //   children: <Widget>[
      //     _barSortButton()
      //   ]
      // )
    );
  }

  Widget _barSortButton(){
    return Tooltip(
      message: 'Sort available Bible list',
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        // padding: EdgeInsets.symmetric(vertical:10,horizontal:10),
        // color: Colors.blue,
        // minSize: 30,
        child: new Icon(
          // Icons.sort,
          // LaiSiangthoIcon.swatchbook,
          Icons.short_text_rounded,
          color: this.isSorting?Colors.red:null,
          size: 33,
        ),
        onPressed: () {
          setState(() {
            isSorting = !isSorting;
          });
        }
      ),
    );
  }

  Widget _barTitle(double shrink){
    return Text(
      // core.collection.env.name,
      'the Holy Bible',
      // 'ABC-XYZ',
      // semanticsLabel: widget.title??core.appName,
      style: TextStyle(
        fontFamily: "sans-serif",
        // color: Color.lerp(Colors.white, Colors.white24, stretch),
        // color: Colors.black,
        // fontWeight: FontWeight.w200,
        fontWeight: FontWeight.lerp(FontWeight.w300, FontWeight.w200, shrink),
        // fontSize:35 - (16*stretch),
        fontSize:(35*shrink).clamp(22.0, 35.0),
        // shadows: <Shadow>[
        //   Shadow(offset: Offset(0, 1),blurRadius:1,color: Colors.black87)
        // ]
      )
    );
  }
  // Widget bar() {
  //   return new SliverPersistentHeader(
  //     pinned: true,
  //     floating:false,
  //     delegate: new ViewHeaderDelegate(
  //       _barBuilder,
  //       maxHeight: focusNode.hasFocus?70:120,
  //       minHeight: 70
  //     )
  //     // delegate: new ScrollHeaderDelegate(
  //     //   Navigator.canPop(context)?_barPopup:_barMain,
  //     //   maxHeight: widget.barMaxHeight
  //     // )
  //   );
  // }
  // // Widget bar() {
  // //   return new SliverPersistentHeader(
  // //     pinned: true,
  // //     // floating:false,
  // //     // delegate: new ScrollHeaderDelegate(
  // //     //   Navigator.canPop(context)?_barPopup:_barMain,
  // //     //   maxHeight: widget.barMaxHeight
  // //     // )
  // //   );
  // // }

  // Widget _barBuilder(BuildContext context,double offset,bool overlaps, double shrink, double stretch){
  //   return Container(
  //     height: double.infinity,
  //     width: double.infinity,
  //     padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
  //     decoration: BoxDecoration(
  //       // color: this.backgroundColor??Theme.of(context).primaryColor,
  //       // color: Theme.of(context).scaffoldBackgroundColor,
  //       color:focusNode.hasFocus?Theme.of(context).primaryColor:Theme.of(context).scaffoldBackgroundColor,
  //       // color: Colors.blue,
  //       // borderRadius: new BorderRadius.vertical(
  //       //   bottom: Radius.elliptical(3, 2)
  //       // ),
  //       border: Border(
  //         bottom: BorderSide(
  //           color: Theme.of(context).backgroundColor.withOpacity(focusNode.hasFocus?1.0:stretch >= 0.5?stretch:0.0),
  //           width: 0.9,
  //         ),
  //       ),
  //       // boxShadow: [
  //       //   BoxShadow(
  //       //     blurRadius: 0.2,
  //       //     // color: Colors.black38,
  //       //     color: Theme.of(context).backgroundColor.withOpacity(stretch >= 0.5?stretch:0.0),
  //       //     spreadRadius: 0.2,
  //       //     offset: Offset(0.5, .7),
  //       //   )
  //       // ]
  //     ),
  //     child: Stack(
  //       // crossAxisAlignment: CrossAxisAlignment.end,
  //       // mainAxisAlignment: MainAxisAlignment.spaceAround,
  //       children: [
  //         // Text('abc'),
  //         Align(
  //           // alignment: Alignment.topCenter,
  //           // alignment: Alignment(0.0,-.7),
  //           alignment: Alignment.lerp(Alignment(0.0,-.7),Alignment.center, shrink>0.8?0.0:shrink)!,
  //           // child: Text('Top'),
  //           child: AnimatedOpacity(
  //             opacity: shrink<0.8?0.0:shrink,
  //             duration: const Duration(milliseconds: 100),
  //             child: Text('MyOrdbok', style: TextStyle(fontSize: 18),),
  //             // child: barTitle(),
  //           ),
  //         ),
  //         Align(
  //           // alignment: Alignment.center,
  //           // alignment: Alignment.lerp(Alignment.bottomCenter,Alignment.center, stretch>0.8?1.0:stretch)!,
  //           alignment: Alignment.lerp(Alignment(0.0,0.8),Alignment.center, (focusNode.hasFocus || stretch>0.2)?1.0:stretch)!,
  //           // alignment: Alignment.lerp(Alignment(-0.5,0.5), Alignment(-0.5,0.5), 0.5)!,
  //           // alignment: Alignment(0.0,0.5),
  //           // child: Text('bottom $stretch'),
  //           // child: barSearch(overlaps)
  //           child: Container(
  //             width: double.infinity,
  //             height: 35.0,
  //             margin: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
  //             child: barSearch(overlaps),
  //           ),
  //         )

  //       ],
  //     )
  //   );
  //   // return Text('abc');
  // }

  // // Widget _barContext(bool innerBoxIsScrolled){
  // //   return SliverAppBar(
  // //     pinned: true,
  // //     floating: true,
  // //     // snap: false,
  // //     // centerTitle: true,
  // //     elevation: 0.7,
  // //     forceElevated: focusNode.hasFocus|innerBoxIsScrolled,
  // //     title: barTitle(),
  // //     expandedHeight: !focusNode.hasFocus?120:50,
  // //     // backgroundColor: innerBoxIsScrolled?Theme.of(context).primaryColor:Theme.of(context).scaffoldBackgroundColor,
  // //     backgroundColor: focusNode.hasFocus?Theme.of(context).primaryColor:Theme.of(context).scaffoldBackgroundColor,
  // //     shape: ContinuousRectangleBorder(
  // //       borderRadius: BorderRadius.vertical(
  // //         bottom: Radius.elliptical(3, 2)
  // //       ),
  // //     ),
  // //     automaticallyImplyLeading: false,
  // //     leading: Navigator.canPop(context)?IconButton(
  // //       icon: Icon(CupertinoIcons.back, color: Colors.black),
  // //       onPressed: () => Navigator.of(context).pop(),
  // //     ):null,
  // //     // actions: [
  // //     //   CupertinoButton(
  // //     //     child: Icon(
  // //     //       CupertinoIcons.checkmark_shield_fill
  // //     //     ),
  // //     //     onPressed: null
  // //     //   )
  // //     // ],
  // //     // flexibleSpace: LayoutBuilder(
  // //     //   builder: (BuildContext context, BoxConstraints constraints) => FlexibleSpaceBar()
  // //     // ),
  // //     bottom: PreferredSize(
  // //       preferredSize: Size.fromHeight(56.0),
  // //       child: Container(
  // //         // width: double.infinity,
  // //         height: 37.0,
  // //         margin: EdgeInsets.fromLTRB(16.0, 6.0, 5.0, 9.0),
  // //         // height: 35.0,
  // //         // margin: EdgeInsets.fromLTRB(16.0, 7.0, 5.0, 10.0),
  // //         child: barSearch(innerBoxIsScrolled),
  // //       ),
  // //     ),
  // //   );
  // // }

  // Widget barTitle() {
  //   // final focus = !context.watch<Core>().nodeFocus;
  //   return AnimatedContainer(
  //     duration: Duration(milliseconds: 200),
  //     width: focusNode.hasFocus?0:null,
  //     height: focusNode.hasFocus?0:null,

  //     child: Semantics(
  //       label: "Setting",
  //       child: Text(
  //         'MyOrdbok',
  //         semanticsLabel: 'core.collection.env.name',
  //         style: TextStyle(
  //           // fontFamily: "sans-serif",
  //           // color: Color.lerp(Colors.white, Colors.white24, stretch),
  //           // color: Colors.black,
  //           // fontWeight: FontWeight.w300,
  //           // fontWeight: FontWeight.lerp(FontWeight.w200, FontWeight.w300, stretch),
  //           // fontSize:35.0,
  //           // fontSize:(35*stretch).clamp(25.0, 35.0),
  //           // shadows: <Shadow>[
  //           //   Shadow(offset: Offset(0, 1),blurRadius:1,color: Colors.black87)
  //           // ]
  //         )
  //       )
  //     ),
  //   );
  //   // return AnimateExpansion(
  //   //   animate: !context.watch<Core>().nodeFocus,
  //   //   axisAlignment: 1.0,
  //   //   child: Semantics(
  //   //     label: "Setting",
  //   //     child: Text(
  //   //       'MyOrdbok',
  //   //       semanticsLabel: 'core.collection.env.name',
  //   //       style: TextStyle(
  //   //         // fontFamily: "sans-serif",
  //   //         // color: Color.lerp(Colors.white, Colors.white24, stretch),
  //   //         // color: Colors.black,
  //   //         // fontWeight: FontWeight.w300,
  //   //         // fontWeight: FontWeight.lerp(FontWeight.w200, FontWeight.w300, stretch),
  //   //         // fontSize:35.0,
  //   //         // fontSize:(35*stretch).clamp(25.0, 35.0),
  //   //         // shadows: <Shadow>[
  //   //         //   Shadow(offset: Offset(0, 1),blurRadius:1,color: Colors.black87)
  //   //         // ]
  //   //       )
  //   //     )
  //   //   )
  //   // );

  //   // return Semantics(
  //   //   label: "Setting",
  //   //   child: Text(
  //   //     'MyOrdbok',
  //   //     semanticsLabel: 'core.collection.env.name',
  //   //     style: TextStyle(
  //   //       fontFamily: "sans-serif",
  //   //       // color: Color.lerp(Colors.white, Colors.white24, stretch),
  //   //       // color: Colors.black,
  //   //       fontWeight: FontWeight.w300,
  //   //       // fontWeight: FontWeight.lerp(FontWeight.w200, FontWeight.w300, stretch),
  //   //       fontSize:25,
  //   //       // fontSize:(35*stretch).clamp(25.0, 35.0),
  //   //       // shadows: <Shadow>[
  //   //       //   Shadow(offset: Offset(0, 1),blurRadius:1,color: Colors.black87)
  //   //       // ]
  //   //     )
  //   //   )
  //   // );
  // }

  // Widget barSearch(bool innerBoxIsScrolled){
  //   // BuildContext context,double offset,bool overlaps, double shrink, double stretch
  //   return Row(
  //     // mainAxisAlignment: MainAxisAlignment.center,
  //     crossAxisAlignment: CrossAxisAlignment.end,
  //     children: <Widget>[
  //       Expanded(
  //         child: AnimatedContainer(
  //           duration: Duration(milliseconds: 400),
  //           // margin: EdgeInsets.only(left:12,right:focusNode.hasFocus?0:12, top: 5, bottom: 5),
  //           // margin: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
  //           // margin: EdgeInsets.only(left:0,right:focusNode.hasFocus?0:12,),
  //           // margin: EdgeInsets.only(left:0,right:focusNode.hasFocus?0:12,),
  //           child: Builder(builder: (BuildContext context) => barForm(innerBoxIsScrolled))
  //         ),
  //       ),
  //       AnimatedContainer(
  //         duration: Duration(milliseconds: 200),
  //         width: focusNode.hasFocus?70:0,
  //         child: focusNode.hasFocus?Semantics(
  //           enabled: true,
  //           label: "Cancel",
  //           child: new CupertinoButton(
  //             // onPressed: () => widget.search(context,core.collection.notify.searchQuery.value),
  //             onPressed: onCancel,
  //             padding: EdgeInsets.zero,
  //             minSize: 35.0,
  //             child:Text(
  //               'Cancel',
  //               semanticsLabel: "search",
  //               maxLines: 1
  //             )
  //           )
  //         ):null,
  //       )
  //     ]
  //   );
  // }

  // Widget barForm(bool innerBoxIsScrolled){
  //   // BuildContext context, double shrink, double stretch
  //   return TextFormField(
  //     controller: textController,
  //     focusNode: focusNode,
  //     textInputAction: TextInputAction.search,
  //     keyboardType: TextInputType.text,

  //     // onChanged: (String word) => widget.textController.text = word.replaceAll(RegExp(' +'), ' ').trim(),
  //     // onFieldSubmitted: (String word) => widget.search(context,word.replaceAll(RegExp(' +'), ' ').trim()),
  //     onChanged: (String str) => onSuggest(str),
  //     onFieldSubmitted: (String str) => onSearch(str),
  //     // autofocus: true,
  //     enableInteractiveSelection: true,
  //     enabled: true,
  //     enableSuggestions: true,
  //     maxLines: 1,
  //     style: TextStyle(
  //       fontFamily: 'sans-serif',
  //       // fontSize: (10+(15-10)*stretch),
  //       fontWeight: FontWeight.w300,
  //       // height: 1.1,
  //       // fontSize: 17,
  //       height: 1.1,
  //       fontSize: 19,
  //       // fontSize: 15 + (2*stretch),
  //       // fontSize: 17 + (2*shrink),
  //       // fontSize: 20 + (2*shrink),

  //       // color: Colors.black
  //       color: Theme.of(context).colorScheme.primaryVariant
  //     ),

  //     decoration: InputDecoration(
  //       // (focusNode.hasFocus && textController.text.isNotEmpty)?
  //       // context.select((Core core) => focusNode.hasFocus && core.suggestionQuery.isNotEmpty)
  //       // suffixIcon: SizedBox.shrink(
  //       //   child: Semantics(
  //       //     label: "Clear",
  //       //     child: new CupertinoButton (
  //       //       onPressed: () {
  //       //         textController.clear();
  //       //         context.read<Core>().suggestionQuery = '';
  //       //       },
  //       //       // minSize: 20,
  //       //       // padding: EdgeInsets.zero,
  //       //       padding: EdgeInsets.symmetric(horizontal: 0,vertical:0),
  //       //       child:Icon(
  //       //         CupertinoIcons.xmark_circle_fill,
  //       //         color:Colors.grey,
  //       //         size: 20,
  //       //         semanticLabel: "input"
  //       //       ),
  //       //     )
  //       //   )
  //       // ),
  //       suffixIcon: Selector<Core, bool>(
  //         selector: (BuildContext _, Core core) => core.nodeFocus && core.suggestionQuery.isNotEmpty,
  //         builder: (BuildContext _, bool word, Widget? child) {
  //           return word?SizedBox.shrink(
  //             child: Semantics(
  //               label: "Clear",
  //               child: new CupertinoButton (
  //                 onPressed: () {
  //                   textController.clear();
  //                   // textController.text ='';
  //                   // context.read<Core>().suggestionQuery = '';
  //                   // Provider.of<Core>(context,listen: true).suggestionQuery = '';
  //                   // word = '';
  //                 },
  //                 // minSize: 20,
  //                 // padding: EdgeInsets.zero,
  //                 padding: EdgeInsets.symmetric(horizontal: 0,vertical:0),
  //                 child:Icon(
  //                   CupertinoIcons.xmark_circle_fill,
  //                   color:Colors.grey,
  //                   size: 20,
  //                   semanticLabel: "input"
  //                 ),
  //               )
  //             )
  //           ):child!;
  //         },
  //         child: SizedBox(),
  //       ),
  //       prefixIcon: Icon(
  //         LaiSiangthoIcon.find,
  //         color:Theme.of(context).hintColor,
  //         size: 17
  //       ),
  //       hintText: " ... a word or two",
  //       hintStyle: TextStyle(color: Colors.grey),
  //       // contentPadding: EdgeInsets.symmetric(horizontal: 2,vertical: (7*shrink)),
  //       contentPadding: EdgeInsets.symmetric(horizontal: 0,vertical: 0),
  //       // contentPadding: EdgeInsets.symmetric(horizontal: 2,vertical: (10*shrink)),
  //       // fillColor: Theme.of(context).primaryColor.withOpacity(shrink),
  //       fillColor: focusNode.hasFocus?Theme.of(context).scaffoldBackgroundColor:Theme.of(context).backgroundColor,
  //     )
  //   );
  // }
}
