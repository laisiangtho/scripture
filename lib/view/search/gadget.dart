part of 'main.dart';

class SearchCache {
  String keyword;
  String iso;
  Widget? child;
  SearchCache({
    this.keyword = "",
    this.iso = "",
    this.child,
  });

  bool isEmpty(CacheBible o) {
    return keyword != o.query || iso != o.result.info.langCode;
  }
}

// prefixIcon SearchPrefixIcon
class SearchPrefixIcon extends StatelessWidget {
  const SearchPrefixIcon({super.key});

  @override
  Widget build(BuildContext context) {
    // return const Placeholder();
    // prefixIcon:
    return Selector<Core, BooksType>(
      selector: (_, e) => e.scripturePrimary.info,
      builder: (BuildContext _, BooksType info, Widget? child) {
        return ViewMark(
          margin: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(4),
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 0.1,
                color: Theme.of(context).shadowColor,
                // spreadRadius: 0.1,
                offset: const Offset(0, 0),
              )
            ],
          ),
          labelStyle: Theme.of(context).textTheme.labelSmall,
          labelPadding: const EdgeInsets.symmetric(horizontal: 3, vertical: 0),
          label: info.langCode.toUpperCase(),
        );
      },
    );
  }
}

class SearchSuffixIcon extends StatelessWidget {
  final void Function()? onPressed;
  // final Animation<double> clearController;
  final AnimationController clearController;
  final AnimationController cancelController;
  const SearchSuffixIcon({
    super.key,
    required this.clearController,
    required this.cancelController,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: clearController,
      child: FadeTransition(
        opacity: cancelController,
        child: ViewButton(
          onPressed: onPressed,
          padding: const EdgeInsets.all(0),
          // message: App.preference.text.clear,
          message: App.preference.text.clear,
          child: Icon(
            Icons.clear_rounded,
            color: Theme.of(context).iconTheme.color!.withOpacity(0.4),
            semanticLabel: "input",
          ),
        ),
      ),
    );
  }
}
