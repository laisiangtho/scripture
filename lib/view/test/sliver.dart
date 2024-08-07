import 'package:flutter/material.dart';

import '/app.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  static String route = 'test-sliver';
  static String label = 'Sliver';
  static IconData icon = Icons.ac_unit;

  @override
  State<Main> createState() => _TestSliverState();
}

class _TestSliverState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Sliver'),
      ),
      body: CustomScrollView(
        slivers: [
          // const SliverAppBar(
          //   automaticallyImplyLeading: false,
          //   title: Text('Home'),
          //   pinned: true,
          // ),
          const ViewFeedbacks.message(
            label: 'CustomScrollView with ViewFeedbacks.message',
          ),
          const SliverToBoxAdapter(
            child: Text('SliverToBoxAdapter with ViewFeedbacks.message'),
          ),
          ViewSections(
            sliver: true,
            footerTitle: const Padding(
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
              child: ViewFeedbacks.message(
                label: 'ViewSections -> footerTitle with ViewFeedbacks.message',
              ),
            ),
            duration: const Duration(milliseconds: 400),
            onAwait: const ViewFeedbacks.await(),
            child: ViewLists(
              // physics: const NeverScrollableScrollPhysics(),
              duration: const Duration(milliseconds: 400),
              itemBuilder: (BuildContext _, int index) {
                return const ViewFeedbacks.message(
                  label: 'ViewSections -> ViewLists with ViewFeedbacks.message',
                );
              },
              itemSnap: const ViewFeedbacks.message(
                label: 'ViewSections -> ViewLists -> itemSnap with ViewFeedbacks.message',
              ),
              itemCount: 2,
            ),
          ),
          ViewLists(
            itemBuilder: (BuildContext _, int index) {
              return ViewFeedbacks.message(
                label: 'ViewLists -> itemBuilder ($index) with ViewFeedbacks.message',
              );
            },
            // onEmpty: ViewFeedbacks.message(
            //   label: App.preference.text.searchNoMatch,
            // ),
            // duration: const Duration(milliseconds: 700),
            // itemSnap: const Text('...'),
            itemCount: 4,
          ),
          SliverMainAxisGroup(
            slivers: <Widget>[
              const ViewFeedbacks.message(
                label: 'SliverMainAxisGroup with ViewFeedbacks.message',
              ),
              SliverAppBar(
                title: const Text('First'),
                automaticallyImplyLeading: false,
                titleTextStyle: Theme.of(context).textTheme.labelMedium,
                pinned: true,
              ),
              // const ViewFeedbacks.message(
              //   label: 'ViewFeedbacks.message under SliverMainAxisGroup',
              // ),
              ViewLists(
                // key: UniqueKey(),
                itemCount: 2,
                itemBuilder: (context, index) {
                  // return Text('ViewLists $index');
                  return ViewFeedbacks.message(
                    label: 'ViewLists $index with ViewFeedbacks.message',
                  );
                },
              ),
              SliverList.builder(
                itemBuilder: (BuildContext _, int index) {
                  // return ListTile(
                  //   title: Text('... $index'),
                  // );
                  return ViewFeedbacks.message(
                    label: 'SliverList.builder $index with ViewFeedbacks.message',
                  );
                },
                itemCount: 2,
              ),
              SliverAppBar(
                title: const ViewFeedbacks.message(
                  label: 'SliverAppBar with ViewFeedbacks.message',
                ),
                titleTextStyle: Theme.of(context).textTheme.labelMedium,
                pinned: true,
              ),
              SliverList.builder(
                itemBuilder: (BuildContext _, int index) {
                  return ListTile(
                    title: Text('... $index'),
                  );
                },
                itemCount: 20,
              ),
            ],
          ),
          SliverMainAxisGroup(
            slivers: <Widget>[
              SliverAppBar(
                title: const Text('Title'),
                automaticallyImplyLeading: false,
                titleTextStyle: Theme.of(context).textTheme.labelMedium,
                pinned: true,
              ),
              SliverMainAxisGroup(
                slivers: <Widget>[
                  SliverAppBar(
                    title: const Text('Sub'),
                    automaticallyImplyLeading: false,
                    titleTextStyle: Theme.of(context).textTheme.labelMedium,
                    // pinned: true,
                  ),
                  ViewLists(
                    // key: UniqueKey(),
                    itemCount: 100,
                    itemBuilder: (context, index) {
                      // return Text('ViewLists $index');
                      return const ViewFeedbacks.message(
                        label: 'sub child',
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
