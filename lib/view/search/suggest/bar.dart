part of 'main.dart';

mixin _Bar on _State {
  Widget bar(BuildContext context, ViewHeaderData org) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: _formField(),
          ),
          WidgetButton(
            padding: const EdgeInsets.only(left: 15),
            child: WidgetMark(
              mainAxisAlignment: MainAxisAlignment.start,
              label: preference.text.cancel,
            ),
            onPressed: onCancel,
          ),
        ],
      ),
    );
  }

  Widget _formField() {
    return TextFormField(
      key: formKey,
      controller: textController,
      focusNode: focusNode,
      textInputAction: TextInputAction.search,
      keyboardType: TextInputType.text,
      onChanged: onSuggest,
      onFieldSubmitted: onSearch,
      maxLines: 1,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 8),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(5),
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
            child: Selector<Core, String>(
              selector: (BuildContext _, Core e) {
                return e.scripturePrimary.bible.info.langCode;
              },
              builder: (BuildContext _, String langCode, Widget? child) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  child: Text(
                    langCode.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                );
              },
            ),
          ),
        ),
        suffixIcon: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            FadeTransition(
              opacity: clearAnimation,
              child: Semantics(
                enabled: true,
                label: preference.text.clear,
                child: WidgetButton(
                  onPressed: onClear,
                  padding: const EdgeInsets.all(0),
                  child: Icon(
                    Icons.clear_rounded,
                    color: Theme.of(context).iconTheme.color!.withOpacity(0.4),
                    semanticLabel: "input",
                  ),
                ),
              ),
            ),
          ],
        ),
        hintText: preference.text.aWordOrTwo,
        fillColor: Theme.of(context)
            .inputDecorationTheme
            .fillColor!
            .withOpacity(focusNode.hasFocus ? 0.6 : 0.4),
      ),
    );
  }
}
