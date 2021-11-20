part of 'main.dart';

mixin _Bar on _State {
  Widget bar() {
    return ViewHeaderSliverSnap(
      pinned: true,
      floating: false,
      reservedPadding: MediaQuery.of(context).padding.top,
      heights: const [kBottomNavigationBarHeight],
      // overlapsBackgroundColor: Theme.of(context).primaryColor,
      overlapsBorderColor: Theme.of(context).shadowColor,
      // overlapsForce: true,
      builder: (BuildContext context, ViewHeaderData org, ViewHeaderData snap) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // const Align(
            //   child: Hero(
            //     tag: 'appbar-left',
            //     child: SizedBox(),
            //   ),
            // ),
            // const Align(
            //   child: Hero(
            //     tag: 'appbar-title',
            //     child: SizedBox(),
            //   ),
            // ),
            Expanded(
              child: Hero(
                tag: 'searchbar-field',
                // createRectTween: (begin, end) {
                //   return MaterialRectArcTween(begin: begin, end: end);
                // },
                // placeholderBuilder: (
                //   BuildContext context,
                //   Size heroSize,
                //   Widget child,
                // ) {
                //   return Container(
                //     width: heroSize.width,
                //     height: heroSize.height,
                //     color: Colors.amberAccent,
                //   );
                // },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                  child: GestureDetector(
                    child: Selector<Core, String>(
                      selector: (BuildContext _, Core e) => e.collection.searchQuery,
                      builder: (BuildContext _, String initialValue, Widget? child) {
                        return TextFormField(
                          readOnly: true,
                          enabled: false,
                          maxLines: 1,
                          initialValue: initialValue,
                          decoration: InputDecoration(
                            hintText: translate.aWordOrTwo,
                            // prefixIcon: const Icon(LideaIcon.find, size: 17),
                            prefixIcon: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
                              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                              decoration: BoxDecoration(
                                color: Theme.of(context).scaffoldBackgroundColor,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(2),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 0.2,
                                    color: Theme.of(context).shadowColor,
                                    // spreadRadius: 0.1,
                                    offset: const Offset(0, 0),
                                  )
                                ],
                              ),
                              child: Selector<Core, String>(
                                selector: (BuildContext _, Core e) {
                                  return e.scripturePrimary.bible.info.langCode;
                                },
                                builder: (BuildContext _, String langCode, Widget? child) {
                                  return Text(
                                    langCode.toUpperCase(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).hintColor,
                                    ),
                                  );
                                },
                              ),
                            ),
                            fillColor:
                                Theme.of(context).inputDecorationTheme.fillColor!.withOpacity(0.4),
                          ),
                        );
                      },
                    ),
                    onTap: () {
                      navigator.currentState!
                          .pushNamed('/search/suggest', arguments: _arguments)
                          .then((word) {
                        onSearch(word != null);
                      });
                    },
                  ),
                  // child: TextFormField(
                  //   readOnly: true,
                  //   // enabled: false,
                  //   initialValue: core.collection.suggestQuery,
                  //   maxLines: 1,
                  //   decoration: InputDecoration(
                  //     hintText: translate.aWordOrTwo,
                  //     prefixIcon: const Icon(LideaIcon.find, size: 17),
                  //     // fillColor: Theme.of(context)
                  //     //     .inputDecorationTheme
                  //     //     .fillColor!
                  //     //     .withOpacity(0.4),
                  //   ),
                  //   onTap: () {
                  //     // core.navigate(to: '/search');
                  //     navigator.currentState!.pushNamed('/suggest').then((word) {
                  //       onSearch(word as bool);
                  //     });
                  //   },
                  // ),
                ),
              ),
            ),

            Align(
              alignment: Alignment.centerRight,
              child: Hero(
                tag: 'searchbar-right',
                child: canPop
                    ? CupertinoButton(
                        padding: const EdgeInsets.fromLTRB(0, 10, 7, 10),
                        onPressed: () {
                          _parent.navigator!.currentState!.maybePop();
                          // navigator.currentState!.pop();
                          // navigator.currentState!.popUntil(ModalRoute.withName('/'));
                          // Navigator.maybePop(context);
                        },
                        child: const WidgetLabel(icon: CupertinoIcons.home),
                      )
                    : const SizedBox(
                        height: kBottomNavigationBarHeight,
                      ),
              ),
            ),
          ],
        );
      },
    );
  }
}
