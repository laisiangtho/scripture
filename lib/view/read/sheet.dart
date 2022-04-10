part of 'main.dart';

class _SheetWidget extends ViewDraggableSheetWidget {
  final void Function() nextChapter;
  final void Function() previousChapter;
  final void Function()? verseSelectionCopy;
  final Future<void> Function(int, {bool isId}) scrollToIndex;

  const _SheetWidget({
    Key? key,
    required this.nextChapter,
    required this.previousChapter,
    this.verseSelectionCopy,
    required this.scrollToIndex,
  }) : super(key: key);

  @override
  State<_SheetWidget> createState() => _SheetWidgetState();
}

class _SheetWidgetState extends ViewDraggableSheetState<_SheetWidget> {
  late final Core core = context.read<Core>();
  late final Preference preference = context.read<Preference>();

  void showParallel() {
    // _draggableEngine(checkChildSize ? 1.0 : 0.0);
    scrollAnimateToggle();
  }

  @override
  List<Widget> sliverWidgets() {
    return <Widget>[
      ViewHeaderSliverSnap(
        pinned: true,
        floating: false,
        // padding: MediaQuery.of(context).viewPadding,
        heights: const [kToolbarHeight],
        // backgroundColor: theme.primaryColor,
        // backgroundColor: theme.primaryColor,
        // overlapsBorderColor: theme.shadowColor,
        overlapsForce: false,
        builder: buttonList,
      ),
      SliverFillRemaining(
        fillOverscroll: true,
        child: SheetParallel(
          controller: scrollController,
          scrollToIndex: widget.scrollToIndex,
        ),
      ),
    ];
  }

  Widget buttonList(BuildContext _, ViewHeaderData org) {
    return Row(
      key: const ValueKey<String>('btn-action'),
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        WidgetButton(
          child: const WidgetMark(icon: LideaIcon.chapterPrevious, iconSize: 25),
          message: preference.text.previousTo(preference.text.chapter(false)),
          onPressed: widget.previousChapter,
        ),
        WidgetButton(
          child: const WidgetMark(icon: LideaIcon.chapterNext, iconSize: 25),
          message: preference.text.nextTo(preference.text.chapter(false)),
          onPressed: widget.nextChapter,
        ),
        WidgetButton(
          child: const WidgetMark(icon: LideaIcon.language, iconSize: 22),
          // message: "Compare selected verse Parallel",
          message: preference.text.compareTo(preference.text.parallel),
          onPressed: showParallel,
        ),
        ValueListenableBuilder<List<int>>(
          valueListenable: core.scripturePrimary.verseSelection,
          builder: (context, value, _) {
            return WidgetButton(
              child: WidgetMark(
                icon: LideaIcon.copy,
                iconSize: 22,
                badge: value.isNotEmpty ? value.length.toString() : '',
              ),
              enable: value.isNotEmpty,
              message: preference.text.share,
              onPressed: widget.verseSelectionCopy,
            );
          },
        ),
      ],
    );
  }
}
