part of 'main.dart';

mixin _Bar on _State {
  Widget sliverPersistentHeader() {
    return new SliverPersistentHeader(
      pinned: true,
      floating:true,
      delegate: new ScrollHeaderDelegate(_bar,minHeight: 40, maxHeight: 50)
    );
  }

  Widget _barDecoration({double stretch, Widget child}){
    return Container(
      decoration: BoxDecoration(
        // color: this.backgroundColor??Theme.of(context).primaryColor,
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: new BorderRadius.vertical(
          bottom: Radius.elliptical(3, 2)
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 0.0,
            // color: Colors.black38,
            color: Theme.of(context).backgroundColor.withOpacity(stretch >= 0.5?stretch:0.0),
            spreadRadius: 0.7,
            offset: Offset(0.5, .1),
          )
        ]
      ),
      child: child
    );
  }

  Widget _bar(BuildContext context,double offset,bool overlaps, double shrink, double stretch){
    return _barDecoration(
      stretch: overlaps?1.0:stretch,
      child: Row(
        children: <Widget>[
          Expanded(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 400),
              margin: EdgeInsets.only(left:12,right:focusNode.hasFocus?0:12, top: 7, bottom: 7),
              child: input(shrink,stretch)
            ),
          ),
          LayoutBuilder(builder: (context, constraints){
            return AnimatedContainer(
              duration: Duration(milliseconds: 200),
              width: focusNode.hasFocus?70:0,
              child: focusNode.hasFocus?new CupertinoButton (
                onPressed: inputCancel,
                padding: EdgeInsets.zero,
                minSize: 35.0,
                child:Text('Cancel', maxLines: 1, style: TextStyle(fontSize: 14))
              ):Container()
            );
          })
        ]
      ),
    );
  }

  Widget input(double shrink,double stretch){
    // double stretch = percentage;
    // double shrink = percentage;
    return TextFormField(
      key: formKey,
      controller: textController,
      focusNode: focusNode,
      // autofocus: true,
      enableInteractiveSelection: true,
      enabled: true,
      // maxLength: 5,
      textInputAction: TextInputAction.search,
      keyboardType: TextInputType.text,
      // initialValue: null,
      // showCursor: true,
      // cursorHeight:22.0,
      enableSuggestions: true,
      onFieldSubmitted: inputSubmit,
      // buildCounter: (BuildContext a, {int currentLength, bool isFocused, int maxLength}) {},
      // textAlign: focusNode.hasFocus?TextAlign.start:TextAlign.center,
      maxLines: 1,
      // obscureText: true,
      style: TextStyle(
        fontFamily: 'sans-serif',
        // fontSize: (10+(15-10)*stretch),
        fontWeight: FontWeight.w300,
        height: 1,
        // fontSize: 15 + (2*stretch),
        fontSize: 15 + (2*shrink),
        // color: Colors.black
      ),
      decoration: InputDecoration(
        // labelText: 'Search',
        // isDense: true,
        // (widget.focusNode.hasFocus && textController.text.isNotEmpty)?
        suffixIcon: Opacity(
          opacity: shrink,
          child: SizedBox.shrink(
            child: (focusNode.hasFocus && this.textController.text.isNotEmpty)?new CupertinoButton (
              onPressed: inputClear,
              // color: Colors.orange,
              padding: EdgeInsets.zero,
              // child:Icon(Icons.clear,color:Colors.grey,size: 17),
              child:Icon(CustomIcon.cancel,color:Colors.grey,size: 10),
            ):null
          )
        ),
        // prefixIcon: Icon(CustomIcon.find,color:Colors.grey[focusNode.hasFocus?100:400],size: 20),
        prefixIcon: Icon(CustomIcon.find,color:Theme.of(context).backgroundColor,size: 20),
        hintText: " ...search Verse",
        hintStyle: TextStyle(color: Colors.grey),
        contentPadding: EdgeInsets.symmetric(horizontal: 2,vertical: (3*shrink)),
        fillColor: Theme.of(context).primaryColor.withOpacity(shrink),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).backgroundColor.withOpacity(shrink),width: 0.8),
          borderRadius: BorderRadius.all(Radius.circular(100)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).backgroundColor.withOpacity(shrink),width: 0.5),
          borderRadius: BorderRadius.all(Radius.circular(7)),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 0.0),
          // borderRadius: BorderRadius.all(Radius.circular(10)),
        )
      )
    );
  }
}
