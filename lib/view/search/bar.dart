part of 'main.dart';

mixin _Bar on _State {
  Widget bar() {
    return SliverAppBar(
      title: AnimatedOpacity(
        duration: Duration(milliseconds: 100),
        opacity: focusNode.hasFocus?0.0:1.0,
        child: Text('Bring to light',),
      ),
      // Allows the user to reveal the app bar if they begin scrolling
      // back up the list of items.
      floating: true,
      pinned: true,
      backgroundColor: core.nodeFocus?null:Theme.of(context).scaffoldBackgroundColor,
      elevation: 0.7,
      forceElevated: core.nodeFocus,
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(7), bottomRight: Radius.circular(7)
        )
      ),
      // Display a placeholder widget to visualize the shrinking size.
      // flexibleSpace: Placeholder(),
      // Make the initial height of the SliverAppBar larger than normal.
      expandedHeight: core.nodeFocus?40:100,
      // toolbarHeight:70,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(56.0),
        child: Container(
          width: double.infinity,
          height: 35.0,
          margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
          child: _barSearch(true),
        ),
      ),
    );
  }

  Widget _barSearch(bool innerBoxIsScrolled){
    // BuildContext context,double offset,bool overlaps, double shrink, double stretch
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            child: Builder(builder: (BuildContext context) => _barForm(innerBoxIsScrolled))
          ),
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 500),
          width: focusNode.hasFocus?70:0,
          child: focusNode.hasFocus?Semantics(
            enabled: true,
            label: "Cancel",
            child: new CupertinoButton(
              onPressed: onCancel,
              padding: EdgeInsets.zero,
              minSize: 35.0,
              child:Text(
                'Cancel',
                semanticsLabel: "search",
                maxLines: 1
              )
            )
          ):null,
        )
      ]
    );
  }

  Widget _barForm(bool innerBoxIsScrolled){
    // BuildContext context, double shrink, double stretch
    return TextFormField(
      controller: textController,
      focusNode: focusNode,
      textInputAction: TextInputAction.search,
      keyboardType: TextInputType.text,
      onChanged: onSuggest,
      onFieldSubmitted: onSearch,
      // autofocus: true,
      enableInteractiveSelection: true,
      enabled: true,
      enableSuggestions: true,
      maxLines: 1,
      style: TextStyle(
        fontFamily: 'sans-serif',
        // fontSize: (10+(15-10)*stretch),
        fontWeight: FontWeight.w300,
        // height: 1.1,
        // fontSize: 17,
        height: 1.1,
        fontSize: 19,
        // fontSize: 15 + (2*stretch),
        // fontSize: 17 + (2*shrink),
        // fontSize: 20 + (2*shrink),

        // color: Colors.black
        color: Theme.of(context).colorScheme.primaryVariant
      ),

      decoration: InputDecoration(
        suffixIcon: Selector<Core, bool>(
          selector: (BuildContext _, Core e) => e.nodeFocus && e.collection.searchQuery.isNotEmpty,
          builder: (BuildContext _, bool word, Widget? child) {
            return word?SizedBox.shrink(
              child: Semantics(
                label: "Clear",
                child: new CupertinoButton (
                  onPressed: onClear,
                  // minSize: 20,
                  padding: EdgeInsets.zero,
                  child:Icon(
                    CupertinoIcons.xmark_circle_fill,
                    color:Colors.grey,
                    size: 20,
                    semanticLabel: "input"
                  ),
                )
              )
            ):child!;
          },
          child: SizedBox(),
        ),
        prefixIcon: Icon(
          LaiSiangthoIcon.find,
          color:Theme.of(context).hintColor,
          size: 17
        ),
        hintText: " ... a word or two",
        hintStyle: TextStyle(color: Colors.grey),
        // contentPadding: EdgeInsets.symmetric(horizontal: 2,vertical: (7*shrink)),
        contentPadding: EdgeInsets.symmetric(horizontal: 0,vertical: 0),
        // contentPadding: EdgeInsets.symmetric(horizontal: 2,vertical: (10*shrink)),
        // fillColor: Theme.of(context).primaryColor.withOpacity(shrink),
        // fillColor: focusNode.hasFocus?Theme.of(context).scaffoldBackgroundColor:Theme.of(context).backgroundColor,
        fillColor: Theme.of(context).backgroundColor.withOpacity(0.1),
      )
    );
  }
}
