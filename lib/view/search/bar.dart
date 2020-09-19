part of 'main.dart';

mixin _Bar on _State {
  Widget sliverPersistentHeader() {
    return new SliverPersistentHeader(
      pinned: true,
      floating:true,
      delegate: new ScrollPageBarDelegate(_bar,minHeight: 40, maxHeight: 50)
    );
  }

  Widget _bar(BuildContext context,double offset,bool overlaps, double shrink, double stretch){
    return Row(
      children: <Widget>[
        Expanded(
          child: AnimatedContainer(
            duration: Duration(milliseconds: 400),
            // margin: EdgeInsets.symmetric(horizontal: 12,vertical: 7*percentage),
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
              child:Text('Cancel', maxLines: 1, style: TextStyle(color: Colors.black87,fontSize: 14),),
            ):Container(),
          );
        })
      ]
    );
  }

  Widget input(double shrink,double stretch){
    // double stretch = percentage;
    // double shrink = percentage;
    return TextFormField(
      key: formKey,
      controller: textController,
      focusNode: focusNode,
      autofocus: false,
      enableInteractiveSelection: true,
      // enabled: inputEnable,
      // maxLength: 5,
      // autovalidate: false,
      textInputAction: TextInputAction.search,
      keyboardType: TextInputType.text,
      // initialValue: null,
      // showCursor: true,
      // enableSuggestions: true,
      // keyboardAppearance: KeyBoardAapp,
      // onSaved: (String value) {
      //   print('save');
      // },
      // onChanged: (String value){
      //   if (value.length > 0) FocusScope.of(context).requestFocus(focusNode);
      //   // textNotifier.value=value;
      // },
      // onTap: (){
      //   print('tap');
      //   // setState(() {
      //   //   inputEnable=true;
      //   //   // FocusScope.of(context).requestFocus(focusNode);
      //   //   focusNode.requestFocus();
      //   // });
      //   // focusNode.requestFocus();
      //   // FocusScope.of(context).requestFocus(focusNode);
      // },
      validator: (value) {
        return null;
      },
      // onEditingComplete: (){
      //   print('onEditingComplete');
      // },
      onFieldSubmitted: inputSubmit,
      // buildCounter: (BuildContext a, {int currentLength, bool isFocused, int maxLength}) {},
      textAlign: focusNode.hasFocus?TextAlign.start:TextAlign.center,
      maxLines: 1,
      // obscureText: true,
      style: TextStyle(
        fontFamily: 'sans-serif',
        // fontSize: (10+(15-10)*stretch),
        height: 1,
        fontSize: 15 + (2*stretch),
        color: Colors.black
      ),
      decoration: InputDecoration(
        // labelText: 'Search',
        // isDense: true,
        // (widget.focusNode.hasFocus && textController.text.isNotEmpty)?
        suffixIcon: Opacity(
          opacity: shrink,
          child: SizedBox.shrink(
            // child:(focusNode.hasFocus && textController.text.isNotEmpty)?InkWell(
            //   child: Icon(Icons.cancel,color:Colors.grey,size: 14),
            //   onTap: inputClear
            // ):null

            child: (focusNode.hasFocus && this.textController.text.isNotEmpty)?new CupertinoButton (
              onPressed: inputClear,
              // color: Colors.orange,
              padding: EdgeInsets.zero,
              // child:Icon(Icons.clear,color:Colors.grey,size: 17),
              child:Icon(CustomIcon.cancel,color:Colors.grey,size: 10),
            ):null

            // child:ValueListenableBuilder<String>(
            //   valueListenable: textNotifier,
            //   builder: (a,String value,c){
            //     return (focusNode.hasFocus && value.isNotEmpty)?new CupertinoButton (
            //       onPressed: inputClear,
            //       padding: EdgeInsets.zero,
            //       child:Icon(Icons.clear,color:Colors.grey,size: 17),
            //     ):Container();
            //   },
            // )
            // child:ValueListenableBuilder<String>(
            //   valueListenable: textNotifier,
            //   builder: (a,String value,c){
            //     return (focusNode.hasFocus && value.isNotEmpty)?new CupertinoButton (
            //       onPressed: inputClear,
            //       padding: EdgeInsets.zero,
            //       child:Icon(Icons.clear,color:Colors.grey,size: 17),
            //     ):Container();
            //   },
            // )
          )
        ),
        prefixIcon: Icon(CustomIcon.find,color:Colors.grey[focusNode.hasFocus?100:400],size: 20),
        // prefixIcon: Icon(Icons.search,color:Colors.grey[focusNode.hasFocus?100:400],size: 22),
        hintText: " ...search Verse",
        // hintStyle: TextStyle(color: Colors.grey),
        contentPadding: EdgeInsets.symmetric(horizontal: 1,vertical: (3*shrink)),
        // fillColor: Color(0xffeff1f4).withOpacity(shrink),
        fillColor: Colors.grey[focusNode.hasFocus?300:200].withOpacity(shrink),
        // fillColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(shrink),
        // fillColor: Theme.of(context).backgroundColor.withOpacity(shrink),
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300].withOpacity(shrink), width: 0.1),
          borderRadius: BorderRadius.all(Radius.circular(100)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[200].withOpacity(shrink), width: 0.1),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        // border: OutlineInputBorder(
        //   borderSide: BorderSide(color: Colors.red, width: 7),
        //   borderRadius: BorderRadius.all(Radius.circular(3)),
        // )
      )
    );
  }
}
