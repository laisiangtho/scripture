import 'package:flutter/material.dart';

import 'package:lidea/icon.dart';
import 'package:lidea/provider.dart';
// import 'package:lidea/view/user/main.dart';

import '../../app.dart';
// import '/widget/profile_icon.dart';
// import '/widget/button.dart';
import '/widget/verse.dart';

part 'state.dart';
part 'header.dart';

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  static String route = 'read';
  static String label = 'Read';
  static IconData icon = LideaIcon.bookOpen;

  @override
  State<Main> createState() => _View();
}

class _View extends _State with _Header {
  @override
  Widget build(BuildContext context) {
    debugPrint('read->build');

    return Scaffold(
      key: _scaffoldKey,
      body: Views(
        scrollBottom: ScrollBottomNavigation(
          listener: _controller.bottom,
          notifier: App.viewData.bottom,
          height: 120,
          pointer: 20,
        ),
        // scrollBottomNavigation: ScrollBottomNavigation()
        child: CustomScrollView(
          controller: _controller,
          slivers: _slivers,
        ),
      ),
      resizeToAvoidBottomInset: true,
      // extendBody: true,
      // bottomNavigationBar: const SheetStack(),
      bottomNavigationBar: App.route.show('sheet-parallel').child,
      // bottomSheet: App.route.show('sheet-parallel').child,
      // extendBody: true,
    );
  }

  List<Widget> get _slivers {
    return [
      ViewHeaderSliver(
        pinned: true,
        floating: false,
        padding: state.fromContext.viewPadding,
        heights: const [kToolbarHeight - 20, 20],
        // overlapsBackgroundColor: state.theme.primaryColor,
        overlapsBorderColor: state.theme.dividerColor,
        builder: _header,
      ),
      ViewFlatBuilder(
        child: ValueListenableBuilder<String>(
          valueListenable: App.core.message,
          builder: (_, message, child) {
            if (message.isEmpty) return child!;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Text(message),
              ),
            );
          },
          child: const SizedBox(),
        ),
      ),
      StreamBuilder(
        initialData: data.boxOfSettings.fontSize(),
        stream: data.boxOfSettings.watch(key: 'fontSize'),
        builder: (BuildContext _, e) {
          return ViewSection(
            child: Selector<Core, BIBLE>(
              selector: (_, e) => e.scripturePrimary.read,
              builder: (BuildContext _, BIBLE __, Widget? ___) {
                return ViewListBuilder(
                  primary: false,
                  physics: const NeverScrollableScrollPhysics(),
                  duration: const Duration(milliseconds: 300),
                  itemBuilder: (BuildContext _, int index) {
                    return _inheritedVerse(primaryVerse[index]);
                  },
                  // itemSnap: (BuildContext _, int index) {
                  //   return const VerseWidgetHolder();
                  // },
                  itemCount: primaryVerse.length,
                );
              },
            ),
          );
        },
      ),
    ];
  }

  Widget _inheritedVerse(VERSE verse) {
    return ValueListenableBuilder<List<int>>(
      key: verse.key,
      valueListenable: primaryScripture.verseSelection,
      builder: (context, value, _) {
        return VerseWidgetInherited(
          size: data.boxOfSettings.fontSize().asDouble,
          lang: primaryScripture.info.langCode,
          selected: value.indexWhere((id) => id == verse.id) >= 0,
          child: WidgetVerse(
            verse: verse,
            onPressed: (int id) {
              int index = value.indexWhere((i) => i == id);
              if (index >= 0) {
                // value.removeAt(index);
                primaryScripture.verseSelection.value = List.from(value)..removeAt(index);
              } else {
                // value.add(id);
                primaryScripture.verseSelection.value = List.from(value)..add(id);
              }
              // primaryScripture.count.value = List.from(value)..add(...);
              // primaryScripture.count = value;
            },
          ),
        );
      },
    );
  }
}

// class PullToRefresh extends PullToActivate {
//   const PullToRefresh({Key? key}) : super(key: key);

//   @override
//   State<PullToActivate> createState() => _PullToRefreshState();
// }

// class _PullToRefreshState extends PullOfState {
//   // late final Core core = context.read<Core>();
//   @override
//   Future<void> refreshUpdate() async {
//     await Future.delayed(const Duration(milliseconds: 50));
//     // await core.updateBookMeta();
//     // await Future.delayed(const Duration(milliseconds: 100));
//     // await core.collection.updateToken();
//     // await Future.delayed(const Duration(milliseconds: 400));
//   }
// }
