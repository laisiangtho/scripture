import 'dart:async';

import 'package:flutter/material.dart';

import 'package:lidea/icon.dart';
import 'package:lidea/provider.dart';
import 'package:lidea/hive.dart';

import '/app.dart';

import '/view/sheet/bible/persistent.dart' as persistent;

part 'state.dart';
part 'header.dart';
part 'snackbar.dart';
part 'motile.dart';

// swipChapter dragChapter GestureChapter

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _View();
}

class _View extends _State with _Header {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Views(
        scrollBottom: ScrollBottomNavigation(
          listener: scrollController.bottom,
          // notifier: App.viewData.bottom,
          notifier: app.bottom,
          height: 120,
          pointer: 20,
        ),
        onNotification: (scrollNotification) {
          if (scrollNotification is UserScrollNotification) {
            return true;
          }

          return false;
        },
        // scrollBottomNavigation: ScrollBottomNavigation()
        child: Motile(
          child: CustomScrollView(
            controller: scrollController,
            slivers: _slivers,
          ),
        ),
        // child: CustomScrollView(
        //   controller: scrollController,
        //   slivers: _slivers,
        // ),
      ),
      // resizeToAvoidBottomInset: true,
      // extendBody: true,
      // bottomNavigationBar: const SheetStack(),
      // bottomNavigationBar: routeOld.show('sheet-parallel').child,
      bottomNavigationBar: ViewDelays.milliseconds(
        milliseconds: 1700,
        builder: (_, __) {
          return const persistent.Main();
        },
      ),
      // bottomSheet: ViewDelays.milliseconds(
      //   milliseconds: 1700,
      //   builder: (_, __) {
      //     return const parallel.Main();
      //   },
      // ),
      // bottomNavigationBar: ViewDelays.milliseconds(
      //   milliseconds: 1700,
      //   builder: (_, __) {
      //     return routeOld.show('sheet-bible-persistent').child;
      //   },
      // ),
      // bottomSheet: routeOld.show('sheet-parallel').child,
      // extendBody: true,
    );
  }

  List<Widget> get _slivers {
    return [
      ViewHeaderSliver(
        pinned: true,
        floating: false,
        padding: state.media.viewPadding,
        // padding: EdgeInsets.only(top: statusBarHeight),
        heights: const [kToolbarHeight - 20, 20],
        // overlapsBackgroundColor: theme.primaryColor,
        overlapsBorderColor: theme.dividerColor,
        builder: _header,
      ),
      // ViewFlats(
      //   child: ValueListenableBuilder<String>(
      //     valueListenable: app.message,
      //     builder: (_, message, child) {
      //       if (message.isEmpty) return child!;
      //       // return Padding(
      //       //   padding: const EdgeInsets.symmetric(vertical: 10),
      //       //   child: Center(
      //       //     child: Text(message),
      //       //   ),
      //       // );
      //       return ViewFeedbacks.message(label: message);
      //     },
      //     child: const SizedBox(),
      //   ),
      // ),
      ValueListenableBuilder<String>(
        valueListenable: app.message,
        builder: (_, message, child) {
          return ViewFlats(
            show: message.isNotEmpty,
            sliver: true,
            child: ViewFeedbacks.message(sliver: false, label: message),
          );
        },
      ),
      StreamBuilder(
        initialData: data.boxOfSettings.fontSize(),
        stream: data.boxOfSettings.watch(key: 'fontSize'),
        builder: (BuildContext _, e) {
          return Selector<Core, CacheBible>(
            selector: (_, e) => e.scripturePrimary.read,
            builder: (BuildContext _, CacheBible bible, Widget? ___) {
              return ViewSections(
                footerTitle: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                  child: Paragraphs(
                    text: '{{shortname}}\n{{copyright}}\n{{description}}\n({{identify}})',
                    textAlign: TextAlign.center,
                    style: style.labelSmall,
                    decoration: [
                      // TextSpan(
                      //   // text: 'App.data.cacheBible',
                      //   text: primaryScripture.info.langCode,
                      //   semanticsLabel: 'language',
                      //   style: TextStyle(
                      //     color: theme.highlightColor,
                      //   ),
                      // ),
                      TextSpan(
                        // text: 'App.data.cacheBible',
                        // text: primaryScripture.info.description,
                        text: bible.result.info.description,
                        // text: 'orange {{description}}',
                        semanticsLabel: 'description',
                      ),
                      TextSpan(
                        text: bible.result.info.shortname,
                        semanticsLabel: 'shortname',
                      ),
                      TextSpan(
                        text: bible.result.info.identify,
                        semanticsLabel: 'identify',
                      ),
                      TextSpan(
                        text: bible.result.info.copyright,
                        semanticsLabel: 'copyright',
                      ),
                    ],
                  ),
                ),
                duration: const Duration(milliseconds: 400),
                onAwait: const ViewFeedbacks.await(),
                child: ViewLists(
                  // physics: const NeverScrollableScrollPhysics(),
                  duration: const Duration(milliseconds: 400),
                  itemBuilder: (BuildContext _, int index) {
                    return _inheritedVerse(primaryVerse.elementAt(index));
                  },
                  itemSnap: const VerseItemSnap(),
                  itemCount: primaryVerse.length,
                ),
              );
            },
          );
        },
      ),
    ];
  }

  Widget _inheritedVerse(OfVerse verse) {
    return ListenableBuilder(
      key: verse.key,
      listenable: primaryScripture.marks,
      builder: (BuildContext context, Widget? child) {
        return VerseWidgetInherited(
          size: data.boxOfSettings.fontSize().asDouble,
          scripture: primaryScripture,
          verseId: verse.id,
          marks: true,
          child: VerseItemWidget(
            verse: verse,
            onPressed: primaryScripture.marks.setSelection,
          ),
        );
      },
    );
  }
}
