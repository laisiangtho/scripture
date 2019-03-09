import 'package:flutter/material.dart';

class Tabs extends StatefulWidget {
  // Tabs({Key key, @required this.title}) : super(key: key);
  // final String title;

  @override
  TabsView createState() => new TabsView();
}

abstract class TabsState extends State<Tabs> {


  @override
  void initState() {
    super.initState();
  }
}
class TabsView extends TabsState {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(40.0),
            child: AppBar(
              automaticallyImplyLeading: false,
              title: Text('data'),
              centerTitle: true,
              // bottom: TabBar(
              //   tabs: [
              //     Tab(icon: Icon(Icons.directions_car)),
              //     Tab(icon: Icon(Icons.directions_transit)),
              //     Tab(icon: Icon(Icons.directions_bike)),
              //   ],
              // ),
              // title: Text('Tabs Demo'),
            ),
          ),
          body: TabBarView(
            children: [
              Icon(Icons.directions_car),
              Icon(Icons.directions_transit),
              Icon(Icons.directions_bike),
            ],
          ),
          bottomNavigationBar: TabBar(
            labelColor: Colors.yellow,
            unselectedLabelColor: Colors.blue,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorPadding: EdgeInsets.all(5.0),
            indicatorColor: Colors.red,
            tabs: [
              // Icon(Icons.directions_car),
              // Icon(Icons.directions_transit),
              // Icon(Icons.directions_bike),
              Tab(icon: Icon(Icons.directions_car)),
              Tab(icon: Icon(Icons.directions_transit)),
              Tab(icon: Icon(Icons.directions_bike)),
            ],
          ),
        ),
      );
  }
}