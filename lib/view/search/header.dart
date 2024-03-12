part of 'main.dart';

mixin _Header on _State {
  Widget _header(BuildContext context, ViewHeaderData data) {
    // AnimatedBuilder(
    //   animation: _cancelController,
    //   builder: (_, child) {

    //   },
    // );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizeTransition(
          sizeFactor: _backController,
          axis: Axis.horizontal,
          child: ViewButton(
            onPressed: state.navigator.maybePop,
            constraints: BoxConstraints(minHeight: data.minHeight),
            child: const Icon(
              LideaIcon.home,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Hero(
            tag: 'search-form',
            child: AnimatedBuilder(
              animation: _cancelController,
              builder: (_, child) {
                return AnimatedBuilder(
                  animation: _backController,
                  builder: (_, child) {
                    return Padding(
                      padding: EdgeInsets.only(
                        top: 9,
                        bottom: 9,
                        // left: 10 * _cancelController.value,
                        // right: 10 * _backController.value,
                        left: _backController.value > 0.0 ? 0 : 10,
                        right: _cancelController.value > 0.0 ? 0 : 10,
                      ),
                      child: child,
                    );
                  },
                  child: child,
                );
              },
              child: TextFormField(
                key: _formKey,
                controller: _textController,
                focusNode: _focusNode,
                textInputAction: TextInputAction.search,
                keyboardType: TextInputType.text,
                onChanged: onSuggest,
                onFieldSubmitted: onSearch,
                maxLines: 1,
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: InputDecoration(
                  /*
                  prefixIcon: ViewMark(
                    margin: const EdgeInsets.all(7),
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
                    labelPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    label: primaryScripture.info.langCode.toUpperCase(),
                  ),
                  */
                  // labelStyle: Theme.of(context).textTheme.labelSmall,
                  // hintStyle: Theme.of(context).textTheme.headlineSmall,
                  prefixIcon: Selector<Core, BooksType>(
                    selector: (_, e) => e.scripturePrimary.info,
                    builder: (BuildContext _, BooksType info, Widget? child) {
                      return ViewMark(
                        margin: const EdgeInsets.all(7),
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
                        labelStyle: state.textTheme.labelSmall,
                        labelPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        label: info.langCode.toUpperCase(),
                      );
                    },
                  ),
                  suffixIcon: FadeTransition(
                    opacity: _clearAnimation,
                    child: FadeTransition(
                      opacity: _cancelController,
                      child: ViewButton(
                        onPressed: onClear,
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
                  ),
                  hintText: App.preference.text.aWordOrTwo,
                  fillColor: Theme.of(context)
                      .inputDecorationTheme
                      .fillColor!
                      .withOpacity(_focusNode.hasFocus ? 0.6 : 0.4),
                ),
              ),
            ),
          ),
        ),
        SizeTransition(
          sizeFactor: _cancelController,
          axis: Axis.horizontal,
          child: ViewButton(
            constraints: BoxConstraints(minHeight: data.minHeight),
            // padding: const EdgeInsets.symmetric(vertical: 5),
            // padding: EdgeInsets.zero,

            onPressed: onCancel,
            // child: ViewLabel(
            //   // alignment: Alignment.center,
            //   // padding: const EdgeInsets.only(right: 13),
            //   // padding: const EdgeInsets.symmetric(horizontal: 10),
            //   label: App.preference.text.cancel,
            //   // icon: Icons.cancel,
            // ),
            style: Theme.of(context).textTheme.labelMedium,
            child: ViewMark(
              // alignment: Alignment.center,
              // padding: const EdgeInsets.only(right: 13),
              // padding: const EdgeInsets.symmetric(horizontal: 10),
              label: App.preference.text.cancel,
              // softWrap: true,
              // icon: Icons.cancel,
            ),
            // child: ViewLabel(
            //   // alignment: Alignment.center,
            //   // padding: const EdgeInsets.only(right: 13),
            //   // padding: const EdgeInsets.symmetric(horizontal: 10),
            //   label: App.preference.text.cancel,
            //   softWrap: true,
            //   // icon: Icons.cancel,
            // ),
            // child: const Icon(
            //   Icons.cancel,
            // ),
            // child: Text(
            //   App.preference.text.cancel,
            //   softWrap: false,
            //   maxLines: 1,
            // ),
          ),
        ),
      ],
    );
  }
}
