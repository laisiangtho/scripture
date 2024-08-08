import 'package:lidea/route/main.dart';
export 'package:lidea/route/main.dart' show RouteParser;

/// NOTE: Launcher
import 'screen_launcher.dart';

/// NOTE: Menu
import 'home/main.dart' as home;
import 'read/main.dart' as read;
import 'note/main.dart' as note;
import 'search/main.dart' as search;

// NOTE: Stage
import 'user/main.dart' as user;
import 'bible/main.dart' as bible;
import 'poll/main.dart' as poll;
import 'recent_search/main.dart' as recent_search;

// NOTE: Test
// import 'test/tmp.dart' as test_tmp;

// NOTE: Sheet
import 'sheet/modal/main.dart' as sheets_modal;
import 'sheet/bible/info.dart' as sheet_bible_info;
import 'sheet/bible/lang.dart' as sheet_bible_lang;
import 'sheet/bible/section.dart' as sheet_bible_section;
import 'sheet/bible/navigation.dart' as sheet_bible_navigation;
import 'sheet/bible/persistent.dart' as sheet_bible_persistent;
// import 'sheet/bible/chapter.dart' as sheet_bible_chapter;
import 'sheet/poll/main.dart' as sheet_poll;

// NOTE: Recto
import 'recto/book.dart' as recto_book;
import 'recto/title.dart' as recto_title;
import 'recto/editor.dart' as recto_editor;
import 'recto/section.dart' as recto_section;
import 'recto/section_chapter.dart' as recto_section_chapter;
import 'recto/parallel.dart' as recto_parallel;
import 'recto/merge.dart' as recto_merge;

// NOTE: Pop
import 'pop/options/main.dart' as pop_options;
// import 'pop/bookmarks/main.dart' as pop_bookmarks;
// import 'pop/books/main.dart' as pop_books;
// import 'pop/chapters/main.dart' as pop_chapters;

/// MainRouteDelegates
class RouteDelegates extends RouteMixinDelegate<RouteNotifier> {
  @override
  List<RouteType> get routes {
    return [
      RouteType(
        primaryNavigation: true,
        page: ScreenLauncher(delegate: this),
      ),
    ];
  }

  @override
  final RouteNotifier notifier = RouteNotifier(
    route: [
      RouteType(
        name: home.Main.route,
        primaryNavigation: true,
        icon: home.Main.icon,
        label: home.Main.label,
        nest: [
          RouteType(
            page: const home.Main(),
            nest: [
              RouteType(
                name: user.Main.route,
                icon: user.Main.icon,
                label: user.Main.label,
                page: const user.Main(),
                nest: [
                  RouteType(
                    name: poll.Main.route,
                    icon: poll.Main.icon,
                    label: poll.Main.label,
                    page: const poll.Main(),
                  ),
                ],
              ),
              RouteType(
                name: search.Main.route,
                icon: search.Main.icon,
                label: search.Main.label,
                page: const search.Main(),
              ),
              RouteType(
                name: bible.Main.route,
                icon: bible.Main.icon,
                label: bible.Main.label,
                page: const bible.Main(),
              ),
              RouteType(
                name: recent_search.Main.route,
                icon: recent_search.Main.icon,
                label: recent_search.Main.label,
                page: const recent_search.Main(),
              ),
              // RouteType(
              //   name: test_tmp.Main.route,
              //   icon: test_tmp.Main.icon,
              //   label: test_tmp.Main.label,
              //   page: const test_tmp.Main(),
              // ),
              RouteType(
                name: recto_section.Main.route,
                icon: recto_section.Main.icon,
                label: recto_section.Main.label,
                page: const recto_section.Main(),
                nest: [
                  RouteType(
                    name: recto_section_chapter.Main.route,
                    icon: recto_section_chapter.Main.icon,
                    label: recto_section_chapter.Main.label,
                    page: const recto_section_chapter.Main(),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
      RouteType(
        name: read.Main.route,
        primaryNavigation: true,
        icon: read.Main.icon,
        label: read.Main.label,
        nest: [
          RouteType(
            page: const read.Main(),
            nest: [
              RouteType(
                name: bible.Main.route,
                icon: bible.Main.icon,
                label: bible.Main.label,
                page: const bible.Main(),
              ),
            ],
          ),
        ],
      ),
      RouteType(
        name: note.Main.route,
        primaryNavigation: true,
        icon: note.Main.icon,
        label: note.Main.label,
        nest: [
          RouteType(
            page: const note.Main(),
          ),
        ],
      ),
      RouteType(
        name: search.Main.route,
        primaryNavigation: true,
        icon: search.Main.icon,
        label: search.Main.label,
        nest: [
          RouteType(
            page: const search.Main(),
          ),
        ],
      ),

      RouteType(
        name: sheets_modal.Main.route,
        icon: sheets_modal.Main.icon,
        label: sheets_modal.Main.label,
        page: const sheets_modal.Main(),
      ),

      RouteType(
        name: sheet_bible_info.Main.route,
        icon: sheet_bible_info.Main.icon,
        label: sheet_bible_info.Main.label,
        page: const sheet_bible_info.Main(),
      ),
      RouteType(
        name: sheet_bible_lang.Main.route,
        icon: sheet_bible_lang.Main.icon,
        label: sheet_bible_lang.Main.label,
        page: const sheet_bible_lang.Main(),
      ),
      RouteType(
        name: sheet_bible_section.Main.route,
        icon: sheet_bible_section.Main.icon,
        label: sheet_bible_section.Main.label,
        page: const sheet_bible_section.Main(),
      ),
      RouteType(
        name: sheet_bible_navigation.Main.route,
        icon: sheet_bible_navigation.Main.icon,
        label: sheet_bible_navigation.Main.label,
        page: const sheet_bible_navigation.Main(),
      ),
      RouteType(
        name: sheet_bible_persistent.Main.route,
        icon: sheet_bible_persistent.Main.icon,
        label: sheet_bible_persistent.Main.label,
        page: const sheet_bible_persistent.Main(),
      ),
      RouteType(
        name: sheet_poll.Main.route,
        icon: sheet_poll.Main.icon,
        label: sheet_poll.Main.label,
        page: const sheet_poll.Main(),
      ),
      RouteType(
        name: pop_options.Main.route,
        icon: pop_options.Main.icon,
        label: pop_options.Main.label,
        page: const pop_options.Main(),
      ),
      // RouteType(
      //   name: pop_bookmarks.Main.route,
      //   icon: pop_bookmarks.Main.icon,
      //   label: pop_bookmarks.Main.label,
      //   page: const pop_bookmarks.Main(),
      // ),
      // RouteType(
      //   name: pop_books.Main.route,
      //   icon: pop_books.Main.icon,
      //   label: pop_books.Main.label,
      //   page: const pop_books.Main(),
      // ),
      // RouteType(
      //   name: pop_chapters.Main.route,
      //   icon: pop_chapters.Main.icon,
      //   label: pop_chapters.Main.label,
      //   page: const pop_chapters.Main(),
      // ),
    ],
  );
}

class NestedDelegates extends RouteMixinDelegate<RouteNotifier> {
  NestedDelegates({
    required super.bridge,
    super.routeType = 1,
    super.route,
    super.name,
  });
}

class NestedView extends NestedRoutes {
  const NestedView({super.key, required super.delegate});
}

/// RouteChangeNotifier
class RouteNotifier extends RouteChangeNotifier {
  RouteNotifier({super.route});
}

class ReadDelegates extends RouteMixinDelegate<RouteNotifier> {
  ReadDelegates({
    required super.bridge,
    super.routeType = 1,
    super.route,
    super.name,
    super.arguments,
  });
  @override
  List<RouteType> get routes {
    return [
      RouteType(
        name: recto_book.Main.route,
        icon: recto_book.Main.icon,
        label: recto_book.Main.label,
        page: const recto_book.Main(),
        home: true,
      ),
      RouteType(
        name: recto_title.Main.route,
        icon: recto_title.Main.icon,
        label: recto_title.Main.label,
        page: const recto_title.Main(),
      ),
      RouteType(
        name: recto_editor.Main.route,
        icon: recto_editor.Main.icon,
        label: recto_editor.Main.label,
        page: const recto_editor.Main(),
      ),
      RouteType(
        name: recto_merge.Main.route,
        icon: recto_merge.Main.icon,
        label: recto_merge.Main.label,
        page: const recto_merge.Main(),
      ),
    ];
  }
}

class PersistentDelegates extends RouteMixinDelegate<RouteNotifier> {
  PersistentDelegates({
    required super.bridge,
    super.routeType = 1,
    super.route,
    super.name,
    super.arguments,
  });
  @override
  List<RouteType> get routes {
    return [
      RouteType(
        name: recto_parallel.Main.route,
        icon: recto_parallel.Main.icon,
        label: recto_parallel.Main.label,
        page: const recto_parallel.Main(),
        home: true,
      ),
      RouteType(
        name: recto_title.Main.route,
        icon: recto_title.Main.icon,
        label: recto_title.Main.label,
        page: const recto_title.Main(),
      ),
    ];
  }
}



/*
class Routes extends InheritedNotifier<AppRouteMainDelegate> {
  const Routes({
    Key? key,
    required AppRouteMainDelegate notifier,
    required Widget child,
  }) : super(key: key, notifier: notifier, child: child);

  static Routes get(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Routes>()!;
  }

  static AppRouteMainDelegate of(BuildContext context) {
    return Routes.get(context).notifier!;
  }

  static AppRouteChangeNotifier state(BuildContext context) {
    return Routes.of(context).state;
  }
  // static AppRouteChangeNotifier delegate(BuildContext context) {
  //   return Routes.of(context).state;
  // }
}
*/

/// get is good and preferred then making variable
/// ```dart
/// // good and preferred
/// RouteNotifier get routes => RouteManager.of(context)
/// // this get setState whenever changes are made
/// late final routes = RouteManager.of(context)
/// RouteManager(
///   notifier: App.routeDelegate,
///   child:?
/// )
/// ```
// class RouteManager extends NavigatorRouteManager<Routes> {
//   const RouteManager({super.key, required super.notifier, required super.child});

//   static RouteManager inheritedWidget(BuildContext context) {
//     return context.dependOnInheritedWidgetOfExactType<RouteManager>()!;
//   }

//   static Routes delegate(BuildContext context) {
//     return RouteManager.inheritedWidget(context).notifier!;
//   }

//   // static GlobalKey<NavigatorState> state(BuildContext context) {
//   //   return RouteManager.delegate(context).navigatorKey;
//   // }

//   static RouteNotifier of(BuildContext context) {
//     return RouteManager.delegate(context).state;
//   }
// }
