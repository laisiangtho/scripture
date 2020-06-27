import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/rendering.dart';
// import 'scrollExtension.dart';

// _SliverAppBarDelegate ScrollPageBarDelegate
class ScrollPageBarDelegate extends SliverPersistentHeaderDelegate {
  ScrollPageBarDelegate(
    this.builder,
    {
      this.minHeight, this.maxHeight
    }
  );
  final double minHeight;
  final double maxHeight;
  final Function builder;

  double stretch = 0.0;
  double shrink = 1.0;

  @override
  bool shouldRebuild(ScrollPageBarDelegate oldDelegate) => true;

  @override
  double get maxExtent => maxHeight??kToolbarHeight;
  // kToolbarHeight

  @override
  double get minExtent => minHeight??kToolbarHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    // return LayoutBuilder(builder: (context, constraints) =>_container(context,shrinkOffset,overlapsContent));
    return LayoutBuilder(builder: (context, constraints){
      final percentage = (constraints.maxHeight - minExtent)/(maxExtent - minExtent);
      return _container(context,shrinkOffset,overlapsContent, percentage);
    });
  }


  // Widget _container(BuildContext context, double shrinkOffset, bool overlapsContent, double percentage) {
  //   return Container(
  //     color: Colors.white,
  //     padding: EdgeInsets.only(bottom: 0.5),
  //     child: Container(
  //       padding: EdgeInsets.only(top: 25),
  //       decoration: BoxDecoration(
  //         // color: Colors.grey,
  //         borderRadius: new BorderRadius.vertical(bottom: Radius.elliptical(5, 2))
  //       ),
  //       // child: new SizedBox.expand(
  //       //   child: builder(context,shrinkOffset,overlapsContent,percentage)
  //       // )
  //       child: builder(context,shrinkOffset,overlapsContent,percentage)
  //     )
  //   );
  // }

  Widget _container(BuildContext context, double shrinkOffset, bool overlapsContent, double percentage) {
    return Container(
      decoration: new BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: new BorderRadius.vertical(bottom: Radius.elliptical(3, 2))
      ),
      padding: EdgeInsets.only(bottom: 0.5),
      child: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: new BorderRadius.vertical(bottom: Radius.elliptical(5, 2))
        ),
        child: new SizedBox.expand(
          child: builder(context,shrinkOffset,overlapsContent,percentage)
        )
      )
    );
  }

  // Widget _container(BuildContext context, BoxConstraints constraints) {
  //   return Container(
  //     color: Colors.white,
  //     padding: EdgeInsets.only(bottom: 0.5),
  //     child: Container(
  //       padding: EdgeInsets.only(top: 25),
  //       decoration: BoxDecoration(
  //         // color: Colors.grey,
  //         borderRadius: new BorderRadius.vertical(bottom: Radius.elliptical(5, 2))
  //       ),
  //       // child: new SizedBox.expand(
  //       //   child: builder(context,0,0)
  //       // )
  //       child: Text('bar'),
  //     )
  //   );
  // }
}

class ScrollPageBarDelegateTesting extends SliverPersistentHeaderDelegate {
  int index = 0;
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return LayoutBuilder(
        builder: (context, constraints) {
          final Color color = Colors.primaries[index];
          final double percentage = (constraints.maxHeight - minExtent)/(maxExtent - minExtent);

          if (++index > Colors.primaries.length-1)
            index = 0;

          return Container(
            decoration: BoxDecoration(
                boxShadow: [BoxShadow(blurRadius: 4.0, color: Colors.black45)],
                gradient: LinearGradient(
                    colors: [Colors.blue, color]
                )
            ),
            height: constraints.maxHeight,
            child: SafeArea(
                child: Center(
                  child: CircularProgressIndicator(
                    value: percentage,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
            ),
          );
        }
    );
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate _) => true;

  @override
  double get maxExtent => 250.0;

  @override
  double get minExtent => 80.0;
}
