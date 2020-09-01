# emtpy

```dart
part of 'main.dart';

class View extends _State {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: ScrollPage(
        controller: controller.master,
        child: _body(),
      )
    );
  }

  Widget _body() {
    return CustomScrollView(
      controller: controller.master,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: <Widget>[
        new SliverPersistentHeader(pinned: true,floating:true,delegate: new ScrollPageBarDelegate(bar)),

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
            ]
          )
        )
      ]
    );
  }

  Widget bar(BuildContext context,double offset,bool overlaps, double shrink, double stretch){
    return Container(
      child: Center(child: Text('More: $shrink'))
    );
  }
}