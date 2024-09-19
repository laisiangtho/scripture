part of 'main.dart';

class InspectProcess extends StatefulWidget {
  const InspectProcess({super.key});

  @override
  State<InspectProcess> createState() => _InspectProcessState();
}

abstract class _InspectProcessAbstract extends CommonStates<InspectProcess> {}

class _InspectProcessState extends _InspectProcessAbstract {
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
                child: ListTile(
                  title: const Text('updateToken (test)'),
                  // subtitle: const Text('...'),
                  onTap: () {
                    // updateToken
                    App.core.data.updateToken().then((e) {
                      debugPrint('updateToken done');
                    }).catchError((e) {
                      debugPrint('updateToken $e');
                    });
                  },
                ),
              ),
            ),
            ViewCards(
              margin: const EdgeInsets.all(20),
              child: SizedBox(
                width: 250,
                child: ListTile(
                  title: const Text('File (test)'),
                  // subtitle: const Text('...'),
                  onTap: () async {
                    // final docs = Docs.user;
                    // docs.dir.then((e) {
                    //   final test = e != null;
                    //   debugPrint('file test: $test');
                    //   if (test) {
                    //     debugPrint('file test: ${e.path}/test.txt');
                    //     // docs.writeAsJSON('test.json', {"done": true});
                    //     docs.writeAsString('test.txt', 'Ok');
                    //   }
                    // });

                    app.scripturePrimary.marks.backup();
                    // if (docs != null) {
                    //   final dir = docs.path;
                    //   // join(await directory.then((e) => e.path), name);
                    //   debugPrint('file: $dir');
                    //   debugPrint('file: ${docs.absolute.uri}');
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
                child: ListTile(
                  title: const Text('Card (test)'),
                  // subtitle: const Text('...'),
                  onTap: () {
                    app.route.page.push('/test-card');
                  },
                ),
              ),
            ),
            ViewCards(
              elevation: 0,
              margin: const EdgeInsets.all(20),
              child: SizedBox(
                width: 250,
                child: ListTile(
                  title: const Text('OfBook (test)'),
                  // subtitle: const Text('...'),
                  onTap: () {
                    App.core.scripturePrimary.init().then((e) {
                      // final src = e.book;

                      // src.first.chapterCount;

                      // debugPrint('bookTesting ${src.length}');
                      // debugPrint('bookTesting name:${src.first.info.name}');
                      // debugPrint('bookTesting chapterCount:${src.first.chapterCount}');
                      // final res = src.where((b) {
                      //   return b.chapter.where((c) {
                      //     return c.verse.where((v) {
                      //       return v.contains('ki');
                      //     }).isNotEmpty;
                      //   }).isNotEmpty;
                      // });
                      // debugPrint('bookTesting search:${res.length}');
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

                      // debugPrint('bookTesting current count:${cur.length}');

                      // for (var b in cur) {
                      //   debugPrint('bookTesting current book:${b.info.name}');
                      //   for (var c in b.chapter) {
                      //     debugPrint('bookTesting current chapter:${c.name}');
                      //     for (var v in c.verse) {
                      //       debugPrint('bookTesting current verse:${v.name}');
                      //     }
                      //   }
                      // }

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
                child: ListTile(
                  title: const Text('Sliver (test)'),
                  // subtitle: const Text('...'),
                  onTap: () {
                    app.route.page.push('/test-sliver');
                  },
                ),
              ),
            ),
            ViewCards(
              margin: const EdgeInsets.all(20),
              child: SizedBox(
                width: 250,
                child: ListTile(
                  title: const Text('Search (test)'),
                  // subtitle: const Text('...'),
                  onTap: () {
                    app.route.page.push('/test-search');
                  },
                ),
              ),
            ),
            ViewCards(
              margin: const EdgeInsets.all(20),
              child: SizedBox(
                width: 250,
                child: ListTile(
                  title: const Text('Section (test)'),
                  subtitle: const Text('preferred language'),
                  onTap: () {
                    app.route.page.push('/recto-section');
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
