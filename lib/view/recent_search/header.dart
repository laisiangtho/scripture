part of 'main.dart';

mixin _Header on _State {
  Widget _header(BuildContext context, ViewHeaderData data) {
    return ViewHeaderLayouts(
      data: data,
      left: [
        OptionButtons.back(
          navigator: state.navigator,
          label: App.preference.text.back,
        ),
      ],
      primary: ViewHeaderTitle(
        alignment: Alignment.lerp(
          const Alignment(0, 0),
          const Alignment(0, .5),
          data.snapShrink,
        ),
        // label: App.preference.text.search(boxOfRecentSearch.plural.toString()),
        label: App.preference.text.keyword(boxOfRecentSearch.plural.toString()),
        data: data,
      ),
      right: [
        // ValueListenableBuilder(
        //   key: const ValueKey('fe'),
        //   valueListenable: App.core.data.boxOfRecentSearch.listen(),
        //   // valueListenable: App.core.data.boxOfBooks.listen(),
        //   builder: (BuildContext context, Box<RecentSearchType> box, Widget? child) {
        //     return ViewButton(
        //       enable: box.isNotEmpty,
        //       onPressed: onDeleteAllConfirmWithDialog,
        //       child: const ViewMark(
        //         icon: Icons.clear_all_rounded,
        //       ),
        //     );
        //   },
        // ),
        // ViewButton(
        //   enable: boxOfRecentSearch.isNotEmpty,
        //   onPressed: onDeleteAllConfirmWithDialog,
        //   child: const ViewMark(
        //     icon: Icons.clear_all_rounded,
        //   ),
        // ),
        OptionButtons.icon(
          // enable: boxOfRecentSearch.isNotEmpty,
          // show: boxOfRecentSearch.isNotEmpty,
          show: false,
          onPressed: onDeleteAllConfirmWithDialog,
          icon: Icons.clear_all_rounded,
        ),
      ],
    );
  }
}
