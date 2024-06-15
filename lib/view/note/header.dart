part of 'main.dart';

mixin _Header on _State {
  // Widget _header(BuildContext context, ViewHeaderData data) {
  //   return ViewHeaderLayoutStack(
  //     data: data,
  //     left: [
  //       OptionButtons(
  //         navigator: state.navigator,
  //       ),
  //     ],
  //     primary: ViewHeaderTitle(
  //       alignment: Alignment.lerp(
  //         const Alignment(0, 0),
  //         const Alignment(0, .5),
  //         data.snapShrink,
  //       ),
  //       label: App.preference.text.note('false'),
  //       data: data,
  //     ),
  //     right: [
  //       ValueListenableBuilder(
  //         key: const ValueKey('fe'),
  //         valueListenable: App.core.data.boxOfBookmarks.listen(),
  //         // valueListenable: App.core.data.boxOfBooks.listen(),
  //         builder: (BuildContext context, Box<BookmarksType> box, Widget? child) {
  //           return ViewButton(
  //             enable: box.isNotEmpty,
  //             onPressed: onDeleteAllConfirmWithDialog,
  //             child: const ViewMark(
  //               icon: Icons.clear_all_rounded,
  //             ),
  //           );
  //         },
  //       ),
  //     ],
  //   );
  // }

  Widget _headerNormal() {
    // return Padding(
    //   padding: const EdgeInsets.symmetric(vertical: 8),
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceAround,
    //     // crossAxisAlignment: CrossAxisAlignment.center,
    //     children: [
    //       // SizeTransition(
    //       //   sizeFactor: _backController,
    //       //   axis: Axis.horizontal,
    //       //   child: OptionButtons(
    //       //     navigator: state.navigator,
    //       //   ),
    //       // ),
    //       OptionButtons(
    //         navigator: state.navigator,
    //       ),
    //       const Expanded(
    //         flex: 1,
    //         child: Align(
    //           alignment: Alignment.center,
    //           child: Hero(
    //             tag: 'search-form',
    //             child: Text('Title'),
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
    return ViewHeaderLayouts.fixed(
      height: kToolbarHeight,
      left: [
        OptionButtons(
          navigator: state.navigator,
        ),
      ],
      primary: ViewHeaderTitle.fixed(
        label: App.preference.text.note('false'),
      ),
      right: [
        ValueListenableBuilder(
          key: const ValueKey('fe'),
          valueListenable: App.core.data.boxOfBookmarks.listen(),
          // valueListenable: App.core.data.boxOfBooks.listen(),
          builder: (BuildContext context, Box<BookmarksType> box, Widget? child) {
            return ViewButton(
              enable: box.isNotEmpty,
              onPressed: onDeleteAllConfirmWithDialog,
              child: const ViewMark(
                icon: Icons.clear_all_rounded,
              ),
            );
          },
        ),
      ],
    );
  }
}
