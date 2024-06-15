import 'package:flutter/material.dart';

// import 'package:lidea/icon.dart';
// import 'package:lidea/provider.dart';
// import 'package:lidea/hive.dart';

import '../../app.dart';
// import '/widget/button.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  static String route = 'test-group';
  static String label = 'Group';
  static IconData icon = Icons.ac_unit;

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  // late final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    // return const Placeholder();
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  expandedHeight: 200.0,
                  // floating: false,
                  pinned: true,
                  snap: false,
                  floating: true,
                  flexibleSpace:
                      LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                    var top = constraints.biggest.height;
                    return FlexibleSpaceBar(
                      title: AnimatedOpacity(
                        duration: const Duration(milliseconds: 10),
                        opacity: top == 56.0 ? 1.0 : 0.6,
                        child: Text(
                          "Collapsing Toolbar $innerBoxIsScrolled",
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      // background: const Placeholder(),
                    );
                  }),
                ),
              ),
              const SliverToBoxAdapter(
                child: Text('tmp'),
              ),
            ];
          },
          // body: const Placeholder(),
          body: Builder(builder: (context) {
            return CustomScrollView(
              key: const PageStorageKey<String>("abcs"),
              // controller: _controller,
              slivers: [
                SliverOverlapInjector(
                  // This is the flip side of the SliverOverlapAbsorber
                  // above.
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                ),
                // const SliverAppBar(
                //   pinned: true,
                //   title: Text('Group'),
                //   elevation: 7,
                // ),
                const SliverAppBar.medium(
                  title: Text('Group'),
                ),
                // const SliverAppBar.large(
                //   title: Text('Group'),
                // ),
                SliverMainAxisGroup(
                  slivers: <Widget>[
                    SliverAppBar(
                      title: const Text('New Testament'),
                      titleTextStyle: Theme.of(context).textTheme.labelMedium,
                      pinned: true,
                      automaticallyImplyLeading: false,
                      toolbarHeight: 30.0,
                    ),
                    ViewLists(
                      // NOTE: referred to ViewScrollBehavior
                      // physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                      duration: const Duration(milliseconds: 50),
                      itemBuilder: (BuildContext _, int index) {
                        // return Text('index  $index');
                        return Card(
                          child: ListTile(
                            minVerticalPadding: 16,
                            enabled: false,
                            title: Text(
                              'index  $index',
                              style: const TextStyle(color: Colors.black),
                            ),
                            titleTextStyle: Theme.of(context).textTheme.labelMedium,
                          ),
                        );
                      },

                      itemCount: 30,
                    ),
                  ],
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
