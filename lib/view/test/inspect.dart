import 'package:flutter/material.dart';

import '../../app.dart';

class TestInspect extends StatefulWidget {
  const TestInspect({super.key});

  static String route = 'test-inspect';
  static String label = 'Inspect';
  static IconData icon = Icons.ac_unit;

  @override
  State<TestInspect> createState() => _TestInspectState();
}

abstract class _State extends StateAbstract<TestInspect> {}

class _TestInspectState extends _State {
  @override
  Widget build(BuildContext context) {
    // return const Placeholder();
    return ViewFlats(
      child: SizedBox(
        height: 130.0,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            ViewCards(
              margin: const EdgeInsets.all(20),
              child: SizedBox(
                width: 250,
                // child: Text('abc...'),
                child: ListTile(
                  title: const Text('File (test)'),
                  // subtitle: const Text('...'),
                  onTap: () async {
                    //  App.core.u
                    // final docs = Docs.user;
                    // docs.dir.then((e) {
                    //   final test = e != null;
                    //   if (test) {
                    //     // docs.writeAsJSON('test.json', {"done": true});
                    //     docs.writeAsString('test.txt', 'Ok');
                    //   }
                    // });

                    core.scripturePrimary.marks.backup();
                    // if (docs != null) {
                    //   final dir = docs.path;
                    //   // join(await directory.then((e) => e.path), name);
                    //   // join(await directory.then((e) => e.path), name);
                    // }
                  },
                ),
              ),
            ),
            ViewCards(
              margin: const EdgeInsets.all(20),
              child: SizedBox(
                width: 250,
                // child: Text('abc...'),
                child: ListTile(
                  title: const Text('Card (test)'),
                  // subtitle: const Text('...'),
                  onTap: () {
                    App.route.pushNamed('home/test-card');
                  },
                ),
              ),
            ),
            ViewCards(
              elevation: 0,
              margin: const EdgeInsets.all(20),
              child: SizedBox(
                width: 250,
                // child: Text('abc...'),
                child: ListTile(
                  title: const Text('OfBook (test)'),
                  // subtitle: const Text('...'),
                  onTap: () {
                    App.core.scripturePrimary.init().then((e) {
                      // final src = e.book;

                      // src.first.chapterCount;

                      // final res = src.where((b) {
                      //   return b.chapter.where((c) {
                      //     return c.verse.where((v) {
                      //       return v.contains('ki');
                      //     }).isNotEmpty;
                      //   }).isNotEmpty;
                      // });
                      // final cur = src.where((b) {
                      //   return b.chapter.where((c) {
                      //     return b.id == 2 && c.id == 4;
                      //   }).isNotEmpty;
                      // });
                      // final cur = src.where((b) {
                      //   return b.id == 2;
                      // }).map((b) {
                      //   return b.chapter.where((c) => c.id == 4);
                      // });
                      // var cur = src.where((b) {
                      //   if (b.id == 2) {
                      //     return b.chapter.where((c) {
                      //       return c.id == 4;
                      //     }).isNotEmpty;
                      //   }
                      //   return false;
                      // });

                      // I need your help of searching this similar data using Dart language.
                      // [
                      //   {
                      //     bookid:1,
                      //     chapter: [1,2,3],
                      //   },
                      //   {
                      //     bookid:3,
                      //     chapter: [3,4,6],
                      //   },
                      //   {
                      //     bookid:6,
                      //     chapter: [5,6,7],
                      //   }
                      // ]

                      // Let say I am searching for bookid:3 then look for chapter:6, and
                      // want the result in the same format
                      // eg. result
                      // [
                      //   {
                      //     bookid:3,
                      //     chapter: [6],
                      //   },
                      // ]

                      // final cur = e.book.where((b) => b.info.id == 4).map((e) {
                      //   return e.getChapter(5);
                      // });

                      final res = e.getChapter(2, 1);

                      debugPrint('test: fold ${res.totalChapter} == 1');
                      debugPrint('test: fold ${res.totalVerse} == 22');
                    });
                  },
                ),
              ),
            ),
            ViewCards(
              margin: const EdgeInsets.all(20),
              child: SizedBox(
                width: 250,
                // child: Text('abc...'),
                child: ListTile(
                  title: const Text('Sliver (test)'),
                  // subtitle: const Text('...'),
                  onTap: () {
                    App.route.pushNamed('home/test-sliver');
                  },
                ),
              ),
            ),
            ViewCards(
              margin: const EdgeInsets.all(20),
              child: SizedBox(
                width: 250,
                // child: Text('abc...'),
                child: ListTile(
                  title: const Text('Search (test)'),
                  // subtitle: const Text('...'),
                  onTap: () {
                    App.route.pushNamed('home/test-search');
                  },
                ),
              ),
            ),
            ViewCards(
              margin: const EdgeInsets.all(20),
              child: SizedBox(
                width: 250,
                // child: Text('abc...'),
                child: ListTile(
                  title: const Text('Section (test)'),
                  subtitle: const Text('preferred language'),
                  onTap: () {
                    App.route.pushNamed('home/leaf-section');
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
