part of 'main.dart';

abstract class _State extends StateAbstract<Main> {
  late final ScrollController _controller = ScrollController();
  // late final Future<void> _viewSnap = Future.delayed(const Duration(milliseconds: 1000));
  // late AppScrollBottomBarController _bottomBarController;

  // RouteNotifier get routes => Of.route;

  // late final args = argumentsAs<ViewNavigationArguments>();

  // late final poll = context.watch<Core>().poll;
  // late final poll = context.read<Core>().poll;
  late final poll = core.poll;

  // @override
  // void initState() {
  //   super.initState();
  // }

  Future<void> whenCompleteSignIn() async {
    // if (authenticate.message.isNotEmpty) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text(authenticate.message),
    //     ),
    //   );
    // }
    // if (authenticate.hasUser) {
    //   await poll.updateAll();
    // }
  }

  void _launchAppCode() {
    Launcher.universalLink('https://github.com/laisiangtho/scripture');
  }

  void _launchPrivacy() {
    Launcher.universalLink('https://github.com/laisiangtho/scripture/blob/master/PRIVACY.md');
  }

  void _launchAppIssues() {
    Launcher.universalLink('https://github.com/laisiangtho/scripture/issues/new');
  }

  List<TextSpan> hightLightTesting(String text, String? matchWord, TextStyle style) {
    // final style = TextStyle(color: Colors.red, fontSize: 22);
    // children: hightLight(verse['text'], store.searchQuery, style),
    List<TextSpan> spans = [];
    if (matchWord == null || matchWord.length < 2) {
      spans.add(TextSpan(text: text, semanticsLabel: text));
    } else {
      int spanBoundary = 0;
      do {
        // look for the next match
        final startIndex = text.toLowerCase().indexOf(matchWord.toLowerCase(), spanBoundary);
        // final startIndex = text.toLowerCase().indexOf(matchWord, spanBoundary);
        // if no more matches then add the rest of the string without style
        if (startIndex == -1) {
          spans.add(TextSpan(text: text.substring(spanBoundary)));
          return spans;
        }
        // add any unstyled text before the next match
        if (startIndex > spanBoundary) {
          spans.add(TextSpan(text: text.substring(spanBoundary, startIndex)));
        }
        // style the matched text
        final endIndex = startIndex + matchWord.length;
        final spanText = text.substring(startIndex, endIndex);
        spans.add(TextSpan(text: spanText, style: style));
        // mark the boundary to start the next search from
        spanBoundary = endIndex;
        // continue until there are no more matches
      } while (spanBoundary < text.length);
    }
    return spans;
  }
}
