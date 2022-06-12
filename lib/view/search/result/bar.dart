part of 'main.dart';

mixin _Bar on _State {
  Widget bar(BuildContext context, ViewHeaderData org) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onSuggest,
              child: _formField(),
            ),
          ),
          WidgetButton(
            padding: const EdgeInsets.only(left: 15),
            show: args!.hasParam,
            onPressed: param?.currentState!.maybePop,
            child: const WidgetLabel(
              icon: LideaIcon.home,
            ),
          ),
        ],
      ),
    );
  }

  Widget _formField() {
    return TextFormField(
      readOnly: true,
      enabled: false,
      maxLines: 1,
      controller: textController,
      decoration: InputDecoration(
        hintText: preference.text.aWordOrTwo,
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
        fillColor: Theme.of(context).inputDecorationTheme.fillColor!.withOpacity(0.4),
      ),
    );
  }
}
