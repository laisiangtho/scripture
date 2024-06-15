part of 'main.dart';

mixin _Header on _State {
  Widget appBarTitleTest(bool toggle) {
    return Container(
      padding: state.fromContext.viewPadding,
      height: kToolbarHeight,
      decoration: BoxDecoration(
        color: toggle ? Theme.of(context).primaryColor : null,
        border: toggle
            ? Border(
                bottom: BorderSide(
                  width: 0.5,
                  color: Theme.of(context).dividerColor,
                ),
              )
            : null,
      ),
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizeTransition(
              sizeFactor: _backController,
              axis: Axis.horizontal,
              child: OptionButtons(
                navigator: state.navigator,
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
                            // top: 8,
                            // bottom: 8,
                            // top: 4,
                            // bottom: 14,
                            // top: 9,
                            // bottom: 9,
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
                      // labelStyle: Theme.of(context).textTheme.labelSmall,
                      // hintStyle: Theme.of(context).textTheme.headlineSmall,
                      prefixIcon: const SearchPrefixIcon(),
                      suffixIcon: SearchSuffixIcon(
                        clearController: _clearController,
                        cancelController: _cancelController,
                        // clearAnimation: _clearAnimation,
                        // cancelController: _cancelController,
                        onPressed: onClear,
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
              // child: ViewButton(
              //   // constraints: BoxConstraints(minHeight: data.minHeight),
              //   onPressed: onCancel,
              //   style: Theme.of(context).textTheme.labelMedium,
              //   child: ViewMark(
              //     label: App.preference.text.cancel,
              //   ),
              // ),
              child: OptionButtons.label(
                label: App.preference.text.cancel,
                onPressed: onCancel,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizeTransition(
            sizeFactor: _backController,
            axis: Axis.horizontal,
            child: OptionButtons(
              navigator: state.navigator,
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
                          // top: 8,
                          // bottom: 8,
                          // top: 4,
                          // bottom: 14,
                          // top: 9,
                          // bottom: 9,
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
                    // labelStyle: Theme.of(context).textTheme.labelSmall,
                    // hintStyle: Theme.of(context).textTheme.headlineSmall,
                    prefixIcon: const SearchPrefixIcon(),
                    suffixIcon: SearchSuffixIcon(
                      clearController: _clearController,
                      cancelController: _cancelController,
                      // clearAnimation: _clearAnimation,
                      // cancelController: _cancelController,
                      onPressed: onClear,
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
            // child: ViewButton(
            //   // constraints: BoxConstraints(minHeight: data.minHeight),
            //   onPressed: onCancel,
            //   style: Theme.of(context).textTheme.labelMedium,
            //   child: ViewMark(
            //     label: App.preference.text.cancel,
            //   ),
            // ),
            child: OptionButtons.label(
              label: App.preference.text.cancel,
              onPressed: onCancel,
            ),
          ),
        ],
      ),
    );
  }
}
