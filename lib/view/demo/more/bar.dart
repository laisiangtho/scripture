part of 'main.dart';

mixin _Bar on _State {

  Widget sliverPersistentHeader() {
    return new SliverPersistentHeader(
      floating:true,
      pinned: true,
      delegate: new ScrollHeaderDelegate(_barMain,minHeight: 30)
      // delegate: new ScrollPageBarDelegate(bar)
    );
  }

  Widget _barDecoration({double stretch, Widget child}){
    return Container(
      decoration: BoxDecoration(
        // color: this.backgroundColor??Theme.of(context).primaryColor,
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: new BorderRadius.vertical(
          bottom: Radius.elliptical(3, 2)
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 0.0,
            // color: Colors.black38,
            color: Theme.of(context).backgroundColor.withOpacity(stretch >= 0.5?stretch:0.0),
            // color: Theme.of(context).backgroundColor.withOpacity(stretch),
            spreadRadius: 0.7,
            offset: Offset(0.5, .1),
          )
        ]
      ),
      child: child
    );
  }

  Widget _barMain(BuildContext context,double offset,bool overlaps, double stretch,double shrink){
    // double width = MediaQuery.of(context).size.width/2;
    // print('overlaps $overlaps stretch $stretch shrink $shrink');
    return _barDecoration(
      stretch: overlaps?1.0:shrink,
      child: Center(child: Text('More: $shrink'))
    );
  }

}
