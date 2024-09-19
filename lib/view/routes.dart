import 'package:flutter/material.dart';
// import 'package:lidea/routes.dart';

import '/app.dart';

/// NOTE: Launcher
import 'screen_launcher.dart' as launcher;

/// NOTE: Bottom navigation
import 'bottom_navigation.dart';

/// NOTE: Menu
import 'home/main.dart' as home;
import 'read/main.dart' as read;
import 'note/main.dart' as note;
import 'search/main.dart' as search;

/// NOTE: Stage
import 'user/main.dart' as user;
import 'bible/main.dart' as bible;
import 'poll/main.dart' as poll;
import 'recent_search/main.dart' as recent_search;

/// NOTE: Test
// import 'test/tmp.dart' as test_tmp;

/// NOTE: Sheet
// import 'sheet/modal/main.dart' as sheets_modal;
import 'sheet/bible/info.dart' as sheet_bible_info;
import 'sheet/bible/lang.dart' as sheet_bible_lang;
// import 'sheet/bible/section.dart' as sheet_bible_section;
// import 'sheet/bible/navigation.dart' as sheet_bible_navigation;
// import 'sheet/bible/persistent.dart' as sheet_bible_persistent;
// // import 'sheet/bible/chapter.dart' as sheet_bible_chapter;
// import 'sheet/poll/main.dart' as sheet_poll;

/// NOTE: Recto
import 'recto/book.dart' as recto_book;
import 'recto/title.dart' as recto_title;
import 'recto/editor.dart' as recto_editor;
import 'recto/section.dart' as recto_section;
// import 'recto/section_chapter.dart' as recto_section_chapter;
import 'recto/parallel.dart' as recto_parallel;
import 'recto/merge.dart' as recto_merge;

// NOTE: Pop
import 'pop/options/main.dart' as pop_options;
// import 'pop/bookmarks/main.dart' as pop_bookmarks;
// import 'pop/books/main.dart' as pop_books;
// import 'pop/chapters/main.dart' as pop_chapters;

class RouteConfig extends RouteNavigations {
  late final GlobalKey<NavigatorState> _keyHome = GlobalKey<NavigatorState>();
  late final GlobalKey<NavigatorState> _keyRead = GlobalKey<NavigatorState>();
  late final GlobalKey<NavigatorState> _keyNote = GlobalKey<NavigatorState>();
  late final GlobalKey<NavigatorState> _keySearch = GlobalKey<NavigatorState>();
  late final GlobalKey<NavigatorState> parallelKey = GlobalKey<NavigatorState>();

  @override
  final initialLocation = '/launcher';

  @override
  late final pageRoutes = [
    GoRoute(
      parentNavigatorKey: initialKey,
      path: initialLocation,
      pageBuilder: (context, state) {
        return pages(
          child: const launcher.Main(),
          state: state,
        );
      },
    ),
    StatefulShellRoute.indexedStack(
      parentNavigatorKey: initialKey,
      branches: [
        StatefulShellBranch(
          navigatorKey: _keyHome,
          routes: [
            GoRoute(
              path: '/',
              name: 'home',
              pageBuilder: (context, GoRouterState state) {
                return pages(child: const home.Main(), state: state);
              },
              routes: [
                // GoRoute(
                //   path: 'user',
                //   pageBuilder: (context, state) {
                //     return pages(child: const user.Main(), state: state);
                //   },
                // ),
                // GoRoute(
                //   path: 'search',
                //   pageBuilder: (context, state) {
                //     return pages(child: const search.Main(), state: state);
                //   },
                // ),
                GoRoute(
                  path: 'bible',
                  pageBuilder: (context, state) {
                    return pages(child: const bible.Main(), state: state);
                  },
                ),
                GoRoute(
                  path: 'recent-search',
                  pageBuilder: (context, state) {
                    return pages(child: const recent_search.Main(), state: state);
                  },
                ),
                GoRoute(
                  path: 'poll',
                  pageBuilder: (context, state) {
                    return pages(child: const poll.Main(), state: state);
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _keyRead,
          routes: [
            GoRoute(
              path: '/read',
              name: 'read',
              pageBuilder: (context, state) {
                return pages(child: const read.Main(), state: state);
              },
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _keyNote,
          routes: [
            GoRoute(
              path: '/note',
              name: 'note',
              pageBuilder: (context, state) {
                return pages(child: const note.Main(), state: state);
              },
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _keySearch,
          routes: [
            GoRoute(
              path: '/search',
              name: 'search',
              pageBuilder: (context, state) {
                return pages(child: const search.Main(), state: state);
              },
            ),
          ],
        ),
      ],
      pageBuilder: (BuildContext context, GoRouterState state, StatefulNavigationShell shell) {
        return pages(
          child: _CustomShell(
            shell: shell,
          ),
          state: state,
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: initialKey,
      name: 'user',
      path: '/user',
      pageBuilder: (context, state) {
        return pages(child: const user.Main(), state: state);
      },
    ),
    GoRoute(
      parentNavigatorKey: initialKey,
      name: 'pop-options',
      path: '/pop-options',
      pageBuilder: (context, state) {
        return RoutePagePopups(
          key: state.pageKey,
          opaque: false,
          barrierDismissible: true,
          transitionsBuilder: (BuildContext _, Animation<double> start, __, Widget child) {
            return FadeTransition(
              opacity: start,
              child: child,
            );
          },
          builder: (_, __, ___) {
            return const pop_options.Main();
          },
        );
      },
    ),
    GoRoute(
      path: '/sheet-bible-info',
      pageBuilder: (context, state) => RoutePageSheets(
        key: state.pageKey,
        scrollControlDisabledMaxHeightRatio: 1,
        // barrierLabel: 'barrierLabel',
        // barrierOnTapHint: 'barrierOnTapHint',
        // isScrollControlled: true,
        useSafeArea: true,
        builder: (context) => const sheet_bible_info.Main(),
      ),
    ),
    GoRoute(
      path: '/sheet-bible-lang',
      pageBuilder: (context, state) => RoutePageSheets(
        key: state.pageKey,
        scrollControlDisabledMaxHeightRatio: 1,
        // isScrollControlled: true,
        useSafeArea: true,
        builder: (context) => const sheet_bible_lang.Main(),
      ),
    ),
  ];

  @override
  late final sheetRoutes = [
    GoRoute(
      path: '/recto-editor',
      builder: (context, state) => const recto_editor.Main(),
    ),
    GoRoute(
      path: '/recto-book',
      builder: (context, state) => const recto_book.Main(),
    ),
    GoRoute(
      path: '/recto-title',
      builder: (context, state) => const recto_title.Main(),
    ),
    GoRoute(
      path: '/recto-section',
      builder: (context, state) => const recto_section.Main(),
    ),
    GoRoute(
      path: '/recto-merge',
      builder: (context, state) => const recto_merge.Main(),
    ),
    GoRoute(
      path: '/sheet-bible-info',
      builder: (context, state) => const sheet_bible_info.Main(),
    ),
    GoRoute(
      path: '/sheet-bible-lang',
      builder: (context, state) => const sheet_bible_lang.Main(),
    ),
  ];

  late final _parallelRoutes = [
    GoRoute(
      path: '/',
      builder: (context, state) => const recto_parallel.Main(),
    ),
  ];

  /// [name] `'/', '/sub'`
  Router<RouteMatchList> parallelConfig({String? name = '/', Object? extra}) {
    return Router.withConfig(
      config: GoRouter(
        initialLocation: name,
        navigatorKey: parallelKey,
        initialExtra: extra,
        routes: _parallelRoutes,
      ),
    );
  }
}

class _CustomShell extends RouteShellNavigationBottom {
  /// BottomNavigation, Sheet etc
  const _CustomShell({required super.shell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: shell,
      bottomNavigationBar: BottomNavigation(shell: shell),
    );
  }
}
