import 'package:flutter/material.dart';

// import 'package:lidea/icon.dart';
import 'package:lidea/sliver_tools.dart';
// import 'package:lidea/provider.dart';
// import 'package:lidea/hive.dart';

import '../../app.dart';
// import '/widget/button.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  static String route = 'test-sticky';
  static String label = 'Sticky';
  static IconData icon = Icons.ac_unit;

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  // late final ScrollController _controller = ScrollController();

  Widget _header(BuildContext context, ViewHeaderData vhd) {
    return ViewHeaderLayouts(
      data: vhd,
      // left: [
      //   BackButtonWidget(
      //     navigator: state.navigator,
      //   ),
      //   // BackButton(),
      // ],
      primary: ViewHeaderTitle(
        alignment: Alignment.lerp(
          const Alignment(0, 0),
          const Alignment(0, .5),
          vhd.snapShrink,
        ),
        label: 'Abc',
        data: vhd,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // return const Placeholder();
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          key: const PageStorageKey<String>("abcs"),
          // controller: _controller,
          slivers: [
            // const SliverAppBar(
            //   pinned: true,
            //   title: Text('Group'),
            //   elevation: 7,
            // ),
            ViewHeaderSliver(
              pinned: true,

              // padding: const EdgeInsets.only(top: 30),
              // heights: const [kToolbarHeight, 100],
              heights: const [kToolbarHeight, 30],
              // overlapsBackgroundColor: state.theme.primaryColor,
              overlapsBorderColor: Colors.black,
              builder: _header,
            ),
            MultiSliver(
              pushPinnedChildren: true, // defaults to false
              children: <Widget>[
                const SliverAppBar(
                  pinned: true,
                  title: Text('First'),
                  // elevation: 7,
                ),
                SliverList.builder(
                  itemBuilder: (BuildContext _, int index) {
                    return ListTile(
                      title: Text('... $index'),
                    );
                  },
                  itemCount: 20,
                ),
                MultiSliver(
                  pushPinnedChildren: true, // defaults to false
                  children: <Widget>[
                    const SliverAppBar(
                      pinned: true,
                      title: Text('sub one'),
                      // elevation: 7,
                    ),
                    SliverList.builder(
                      itemBuilder: (BuildContext _, int index) {
                        return ListTile(
                          title: Text('... $index'),
                        );
                      },
                      itemCount: 6,
                    ),
                  ],
                ),
                MultiSliver(
                  pushPinnedChildren: true, // defaults to false
                  children: <Widget>[
                    const SliverAppBar(
                      pinned: true,
                      title: Text('sub two'),
                      // elevation: 7,
                    ),
                    SliverList.builder(
                      itemBuilder: (BuildContext _, int index) {
                        return ListTile(
                          title: Text('... $index'),
                        );
                      },
                      itemCount: 10,
                    ),
                  ],
                ),
              ],
            ),
            MultiSliver(
              pushPinnedChildren: true, // defaults to false
              children: <Widget>[
                const SliverAppBar(
                  pinned: true,
                  title: Text('Second'),
                  elevation: 7,
                ),
                SliverList.builder(
                  itemBuilder: (BuildContext _, int index) {
                    return ListTile(
                      title: Text('... $index'),
                    );
                  },
                  itemCount: 30,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
