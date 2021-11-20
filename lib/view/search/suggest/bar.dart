part of 'main.dart';

mixin _Bar on _State {
  Widget bar() {
    return ViewHeaderSliverSnap(
      pinned: true,
      floating: false,
      reservedPadding: MediaQuery.of(context).padding.top,
      heights: const [kBottomNavigationBarHeight],
      overlapsBackgroundColor: Theme.of(context).primaryColor,
      overlapsBorderColor: Theme.of(context).shadowColor,
      // overlapsForce:focusNode.hasFocus,
      // overlapsForce:core.nodeFocus,
      overlapsForce: true,
      // borderRadius: Radius.elliptical(20, 5),
      builder: (BuildContext context, ViewHeaderData org, ViewHeaderData snap) {
        return Row(
          children: <Widget>[
            Expanded(
              child: Hero(
                tag: 'searchbar-field',
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.5),
                  child: _barForm(),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Hero(
                tag: 'searchbar-right',
                child: CupertinoButton(
                  padding: const EdgeInsets.fromLTRB(0, 10, 7, 10),
                  onPressed: onCancel,
                  child: WidgetLabel(
                    label: translate.cancel,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _barForm() {
    return TextFormField(
      key: formKey,
      controller: textController,
      focusNode: focusNode,
      textInputAction: TextInputAction.search,
      keyboardType: TextInputType.text,
      onChanged: onSuggest,
      onFieldSubmitted: onSearch,
      // autofocus: true,
      // enabled: true,
      // enableInteractiveSelection: true,
      // enableSuggestions: true,
      maxLines: 1,
      decoration: InputDecoration(
        // prefixIcon: const Icon(LideaIcon.find, size: 17),
        prefixIcon: Container(
          // padding: const EdgeInsets.fromLTRB(10, 10.1, 0, 0),
          // child: Text(
          //   core.scripturePrimary.bible.info.langCode.toUpperCase(),
          //   style: TextStyle(
          //     fontSize: 14,
          //     fontWeight: FontWeight.bold,
          //     color: Theme.of(context).hintColor,
          //   ),
          // ),
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

        suffixIcon: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            FadeTransition(
              opacity: clearAnimation,
              // axis: Axis.horizontal,
              // axisAlignment: 1,
              child: Semantics(
                enabled: true,
                label: translate.clear,
                child: CupertinoButton(
                  onPressed: onClear,
                  padding: const EdgeInsets.all(0),
                  child: Icon(
                    CupertinoIcons.xmark,
                    color: Theme.of(context).iconTheme.color!.withOpacity(0.4),
                    size: 17,
                    semanticLabel: "input",
                  ),
                ),
              ),
            ),
          ],
        ),
        hintText: translate.aWordOrTwo,
        fillColor: Theme.of(context)
            .inputDecorationTheme
            .fillColor!
            .withOpacity(focusNode.hasFocus ? 0.6 : 0.4),
      ),
    );
  }
}
