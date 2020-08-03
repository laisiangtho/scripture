part of 'main.dart';

class View extends _State {

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    return Scaffold(
      key: scaffoldKey,
      // body: ScrollPage(
      //   controller: controller,
      //   child: _body(),
      // ),
      body: new Stack(
        children: <Widget>[
          new ScrollPage(
            controller: controller,
            child: _body(),
          ),
          // DraggableScrollableActuator(
          //   child: DraggableScrollableSheet(
          //     key: UniqueKey(),
          //     expand: true,
          //     initialChildSize: 0.2,
          //     minChildSize: 0.1,
          //     maxChildSize: 0.5,
          //     // initialChildSize: 0.09,
          //     // minChildSize: 0.02,
          //     // maxChildSize: 1.0,
          //     builder: (BuildContext context, ScrollController scrollController) {
          //       return DragableSheetTest(parentContext:context,scrollController: scrollController,);
          //     },
          //   ),
          // )
        ],
      ),
      bottomNavigationBar: DraggableScrollableActuator(
        child: DraggableScrollableSheet(
          key: UniqueKey(),
          expand: true,
          initialChildSize: 0.2,
          minChildSize: 0.08,
          maxChildSize: 0.9,
          // initialChildSize: 0.09,
          // minChildSize: 0.02,
          // maxChildSize: 1.0,
          builder: (BuildContext context, ScrollController scrollController) {
            return DraggableScrollableSheetTest(scrollController:scrollController);
          },
        ),
      ),
      extendBody: true,
    );
  }

  Widget _body() {
    return CustomScrollView(
      controller: controller,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: <Widget>[
        new SliverPersistentHeader(pinned: true,floating:true,delegate: new ScrollPageBarDelegate(bar)),
        // new SliverToBoxAdapter(
        //   child: Center(
        //     child: Text("? : ${core.identify}"),
        //   )
        // ),
        new SliverList(
          delegate: new SliverChildListDelegate(
            <Widget>[
              RaisedButton(
                child: Text("more to bible"),
                onPressed: () {
                  controller.master.bottom.pageChange(1);
                },
              ),
              RaisedButton(
                child: Text("Counter $testCounter"),
                onPressed: (){
                  setState(() {
                    testCounter++;
                  });
                }
              ),
              RaisedButton(
                child: Text("modal bottom sheet"),
                onPressed: showBottomSheetModal
              ),
              RaisedButton(
                child: Text("SnackBar"),
                onPressed: () {
                  // scaffoldKey.currentState.showSnackBar(new SnackBar(
                  //     content: Container(
                  //       color: Colors.red,
                  //       height:50,
                  //       child: Text('Hi there')
                  //     )
                  // ));
                  Scaffold.of(context).showSnackBar(new SnackBar(
                    content: new Text('value')
                  ));
                },
              ),
              RaisedButton(
                child: Text("bottom sheet, hide nav, Shape: key"),
                onPressed: showBottomSheetScaffoldKey,
              ),
              RaisedButton(
                child: Text("showBottomSheetScaffoldContext"),
                onPressed: showBottomSheetScaffoldContext,
              ),
              RaisedButton(
                child: Text("draggableScrollableSheet in bottomsheet"),
                onPressed: draggableScrollableSheet,
              ),
              IconButton(
                icon: AnimatedIcon(
                  icon: AnimatedIcons.list_view,
                  progress: animationController,
                  semanticLabel: 'Show menu',
                ),
                onPressed: (){
                  if (animationController.isCompleted){
                    animationController.reverse();
                  } else {
                    animationController.forward();
                  }
                },
              ),

              CupertinoSwitch(
                value: true,
                onChanged:(bool i) => false,
              ),
              TestSwitch()
            ],
          ),
        ),
        new SliverToBoxAdapter(
          child: Center(
            child: RaisedButton(
              child: Text("Popup"),
              onPressed: () {
                // Navigator.push(
                //   context,
                //   // PageRouteBuilder(
                //   //   pageBuilder: (c, a1, a2) => Container(color: Colors.white,child: Center(child: Text("Hello Popup"))),
                //   //   transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                //   //   transitionDuration: Duration(milliseconds: 200),
                //   // ),
                //   MaterialPageRoute(builder: (context) => Container(color: Colors.white,child: Center(child: Text("Unknown"))))
                // );
                // Navigator.of(context, rootNavigator: false).push(MaterialPageRoute(builder: (context) => Container(color: Colors.white,child: Center(child: Text("Unknown"))), maintainState: false));
                // Navigator.of(context).push(MaterialPageRoute(builder: (context) => Container(color: Colors.white,child: Center(child: Text("Unknown"))), maintainState: false));
                // Navigator.pushNamed(context, '2');
                // Navigator.of(context).pushNamedAndRemoveUntil('3', (Route<dynamic> route) => false);
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => TestRoute()),
                  // );
                // Navigator.of(context, rootNavigator: true).pushReplacement(MaterialPageRoute(builder: (context) => new TestRoute()));
                // Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => new TestRoute(), maintainState: true,fullscreenDialog: true));
                Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => new TestRoute(), maintainState: true));
              },
            ),
          )
        ),
        new SliverPadding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
          // padding: EdgeInsets.only(bottom: controller.bottom.height),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _listItem(context, index),
              childCount: 20,
              // addAutomaticKeepAlives: true
            ),
          ),
        ),
        new SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => Container(
              child: Text('test $index'),
            ),
            childCount: 20,
            // addAutomaticKeepAlives: true
          ),
        )
      ]
    );
  }

  Widget bar(BuildContext context,double offset,bool overlaps, double shrink, double stretch){
    return Container(
      child: Center(child: Text('More: $shrink'))
    );
  }

  Widget _listItem(BuildContext context, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 23),
      child: Center(child: Text("CustomScrollView $index")),
    );
  }

  void showBottomSheetScaffoldKey() {
    // controller.master.bottom.toggle(true);
    // scaffoldKey.currentState.showBottomSheet(
    //   // (BuildContext context)=>TestBottomSheetLayout(),
    //   (BuildContext context)=>WidgetSheet(
    //     child: Column(
    //       mainAxisSize: MainAxisSize.min,
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       mainAxisAlignment: MainAxisAlignment.start,
    //       children: <Widget>[
    //         Text('abc')
    //       ]
    //     )
    //   )
    // )..closed.whenComplete(() {
    //   // controller.master.bottom.toggle(false);
    // });
    // controller.master.bottom.toggle(true);
    // scaffoldKey.currentState.showBottomSheet<void>(
    //   (BuildContext context){
    //     return TestBottomSheetLayout();
    //   }
    // )..closed.whenComplete(() {
    //   controller.master.bottom.toggle(false);
    // });

  }

  void showBottomSheetScaffoldContext (){

  }

  void showBottomSheetModal() {
    // showModalBottomSheet(
    //   // isScrollControlled: true,
    //   context: context, builder: (s) => WidgetSheet(
    //     child: Text("modal sheet")
    //   )
    // )..whenComplete(() {
    // });
  }

  bool draggableScrollableSheetVisible = false;
  void draggableScrollableSheet() {
    if (draggableScrollableSheetVisible) {
      DraggableScrollableActuator.reset(context);
      // DraggableScrollableActuator.
      return;
    }
    // scaffoldKey.currentState.
    scaffoldKey.currentState.showBottomSheet(
      (BuildContext context) {
        return DraggableScrollableActuator(
          child: DraggableScrollableSheet(
            key: UniqueKey(),
            expand: false,
            initialChildSize: 0.2,
            minChildSize: 0.02,
            maxChildSize: 0.5,
            // initialChildSize: 0.09,
            // minChildSize: 0.02,
            // maxChildSize: 1.0,
            builder: (BuildContext context, ScrollController scrollController) {
              return DragableSheetTest(parentContext:context,scrollController: scrollController,);
            },
          ),
        );
      },
      // backgroundColor: Colors.red,
      elevation: 0
    ).closed.whenComplete((){
      DraggableScrollableActuator.reset(context);
    });
  }
}

class TestRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}

class TestSwitch extends StatefulWidget {
  @override
  _TestSwitchState createState() => _TestSwitchState();
}


class _TestSwitchState extends State<TestSwitch> {

  int _count = 0;

  @override
  Widget build(BuildContext context) {

    return Column(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(child: child, scale: animation);
          },
          child: Text(
            _count.toString(),
            key: ValueKey<int>(_count),
            style: Theme.of(context).textTheme.caption,
          )
        ),
        RaisedButton(
          child: Text('TestSwitch'),
          onPressed: () {
            setState(() {
              _count++;
            });
          },
        ),
      ],
    );
  }
}

class DragableSheetTest extends StatelessWidget {
  final ScrollController scrollController;
  final BuildContext parentContext;
  DragableSheetTest({this.parentContext,this.scrollController});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: scaffoldKey,
      backgroundColor: Colors.grey,
      // appBar: AppBar(
      //   title: Text('abc'),
      //   actions: <Widget>[
      //     RaisedButton(
      //       child: Text('close'),
      //       onPressed: () {
      //         Navigator.of(context).pop();
      //       },
      //     ),
      //   ],
      // ),
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(child: list())
          ],
        ),
      )
    );
    // return Column(
    //   mainAxisSize: MainAxisSize.min,
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   crossAxisAlignment: CrossAxisAlignment.center,
    //   children: <Widget>[
    //     RaisedButton(
    //       child: Text('close'),
    //       onPressed: () {
    //         DraggableScrollableActuator.reset(parentContext);
    //         Navigator.of(parentContext).pop();
    //       },
    //     ),
    //     Expanded(child: list())
    //   ],
    // );
  }

  Widget list(){
    return Container(
      // color: Colors.blue[100],
      child: ListView.builder(
        controller: scrollController,
        itemCount: 25,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(title: Text('Item $index'));
        },
      ),
    );
  }
}

class DraggableScrollableSheetTest extends StatelessWidget {

  final ScrollController scrollController;
  DraggableScrollableSheetTest({this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        controller: scrollController,
        slivers: <Widget>[
          new SliverPersistentHeader(pinned: true,floating:true,delegate: new ScrollPageBarDelegate(_bar)),
          // new SliverToBoxAdapter(
          //   child: Center(
          //     child: Text("? : ${core.identify}"),
          //   )
          // ),
          // new SliverList(
          //   delegate: new SliverChildListDelegate(
          //     <Widget>[
          //     ]
          //   )
          // )
          new SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Container(
                padding: EdgeInsets.all(20),
                child: Text('test $index'),
              ),
              childCount: 20,
              // addAutomaticKeepAlives: true
            ),
          )
        ]
      ),
    );
  }

  Widget _bar(BuildContext context,double shrinkOffset,bool overlapsContent,double shrink,double stretch){
    return Container(
      child: Center(
        child: FlatButton(
          child: Text('close'),
          onPressed: (){
            DraggableScrollableActuator.reset(context);
          },
        )
      )
    );
  }
}