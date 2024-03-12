part of 'main.dart';

mixin _Header on _State {
  Widget _header(BuildContext context, ViewHeaderData vhd) {
    // double width = MediaQuery.of(context).size.width * 0.5;
    double width = state.fromContext.size.width * 0.5;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ViewButton(
          key: _kBookmarks,
          // constraints: const BoxConstraints(minWidth: 50.0),
          // color: Theme.of(context).backgroundColor,
          // padding: EdgeInsets.symmetric(
          //   vertical: (data.shrink * 12).clamp(6, 12).toDouble(),
          //   horizontal: 7,
          // ),
          message: preference.text.addTo(preference.text.bookmark('true')),

          onPressed: showBookmarks,
          // child: Icon(
          //   Icons.bookmark_add,
          //   size: (data.shrink * 26).clamp(20, 26),
          // ),
          // child: ViewMark(
          //   // padding: const EdgeInsets.only(left: 13),
          //   child: Icon(
          //     Icons.bookmark_add,
          //     size: (vhd.shrink * 26).clamp(20, 26),
          //   ),
          // ),
          child: Selector<Core, bool>(
            selector: (_, e) => e.scripturePrimary.bookmarked,
            builder: (BuildContext context, bool hasBookmark, Widget? child) {
              return ViewMark(
                icon: hasBookmark ? Icons.bookmark_added : Icons.bookmark_add,
                iconColor:
                    hasBookmark ? Theme.of(context).hintColor : Theme.of(context).dividerColor,
                iconSize: (vhd.shrink * 26).clamp(20, 26),
              );
            },
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ViewButton(
                key: _kBooks,
                showShadow: true,
                color: Theme.of(context).primaryColor.withOpacity(vhd.snapShrink),
                constraints: BoxConstraints(maxWidth: width, minWidth: 48),
                borderRadius: const BorderRadius.horizontal(left: Radius.elliptical(20, 50)),
                padding: EdgeInsets.fromLTRB(10, 1, vhd.snapShrink * 5, 1),
                message: preference.text.book('true'),
                onPressed: showBooks,
                // child: ViewMark(
                //   // label: 'Ruth',
                //   // label: 'Second Thessalonians',
                //   label: core.scripturePrimary.bookName,
                //   labelStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                //         fontSize: (data.shrink * 18).clamp(15, 18),
                //       ),
                // ),
                child: Selector<Core, String>(
                  selector: (_, e) => e.scripturePrimary.bookName,
                  builder: (BuildContext context, String bookName, Widget? child) {
                    return ViewMark(
                      label: bookName,
                      labelStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontSize: (vhd.shrink * 18).clamp(15, 18),
                          ),
                    );
                  },
                ),
              ),
              Divider(
                indent: 1 * vhd.snapShrink,
              ),
              // ViewButton.filled(
              //   showShadow: true,
              //   // color: Theme.of(context).backgroundColor.withOpacity(data.snapShrink),
              //   constraints: BoxConstraints(maxWidth: width, minWidth: 35),
              //   borderRadius: const BorderRadius.horizontal(right: Radius.elliptical(20, 50)),
              //   padding: EdgeInsets.fromLTRB(3, 3, data.snapShrink * 5, 3),
              //   onPressed: () {},
              //   child: ViewMark(
              //     label: '150',
              //     labelStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
              //           fontSize: (data.shrink * 18).clamp(15, 18),
              //         ),
              //   ),
              // ),
              ViewButton(
                key: _kChapters,
                showShadow: true,
                color: Theme.of(context).primaryColor.withOpacity(vhd.snapShrink),
                constraints: BoxConstraints(maxWidth: width, minWidth: 35),
                borderRadius: const BorderRadius.horizontal(right: Radius.elliptical(20, 50)),
                padding: EdgeInsets.fromLTRB(3, 1, vhd.snapShrink * 5, 1),
                message: preference.text.chapter('true'),
                onPressed: showChapters,
                child: Selector<Core, String>(
                  selector: (_, e) => e.scripturePrimary.chapterName,
                  builder: (BuildContext context, String chapterName, Widget? child) {
                    return ViewMark(
                      label: chapterName,
                      labelStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontSize: (vhd.shrink * 18).clamp(15, 18),
                          ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        ViewButton(
          key: _kOptions,
          // constraints: const BoxConstraints(minWidth: 50.0),
          // color: Theme.of(context).backgroundColor,
          // padding: EdgeInsets.symmetric(
          //   vertical: (data.shrink * 12).clamp(6, 12).toDouble(),
          //   horizontal: 7,
          // ),
          // alignment: Alignment.center,
          // padding: const EdgeInsets.only(right: 13),
          onPressed: showOptions,
          // badge: '12',
          // child: Icon(
          //   LideaIcon.textSize,
          //   size: (data.shrink * 26).clamp(20, 26),
          // ),
          child: ViewMark(
            // padding: const EdgeInsets.only(right: 13),
            child: Icon(
              LideaIcon.textSize,
              size: (vhd.shrink * 26).clamp(20, 26),
            ),
          ),
        )
      ],
    );
    /*
    return ViewHeaderLayoutStack(
      data: data,
      left: [
        // BackButtonWidget(
        //   navigator: navigator,
        // ),
        ViewButton(
          // constraints: const BoxConstraints(maxWidth: 56, minWidth: 40.0, maxHeight: 40),
          // minSize: 20,
          onPressed: () {},
          // child: ViewLabel(
          //   // constraints: const BoxConstraints(maxWidth: 56, minWidth: 40.0, maxHeight: 40),
          //   icon: Icons.bookmark_add,
          //   iconColor: Theme.of(context).primaryColorDark,
          //   iconSize: (data.shrink * 23).clamp(18, 23).toDouble(),
          // ),
          child: const Icon(
            Icons.bookmark_add,
          ),
        ),
      ],
      primary: ViewHeaderTitle(
        alignment: Alignment.lerp(
          const Alignment(0, 0),
          const Alignment(0, .5),
          data.snapShrink,
        ),
        label: 'Read asdfa sdfasdf asdf asdfasdfa sdf',
        data: data,
      ),
      right: [
        ViewButton(
          // constraints: const BoxConstraints(maxWidth: 56, minWidth: 40.0, maxHeight: 40),
          // minSize: 20,
          onPressed: () {},
          // child: ViewLabel(
          //   // constraints: const BoxConstraints(maxWidth: 56, minWidth: 40.0, maxHeight: 40),
          //   icon: Icons.bookmark_add,
          //   iconColor: Theme.of(context).primaryColorDark,
          //   iconSize: (data.shrink * 23).clamp(18, 23).toDouble(),
          // ),
          child: const Icon(
            Icons.bookmark_add,
          ),
        ),
      ],
    );
    */
  }
}
