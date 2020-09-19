// part of 'main.dart';

// To enable: uncomment
// core.dart import package:flutter_tts/flutter_tts.dart
// speech.dart

// class BottomSheetAudio extends StatefulWidget {
//   BottomSheetAudio({
//     Key key,
//     this.controller,
//     this.verseSelectionList,
//     this.scrollToIndex,
//   }) : super(key: key);
//   final ScrollController controller;
//   final List<int> verseSelectionList;
//   final Future<void> Function(int) scrollToIndex;

//   @override
//   BottomSheetAudioState createState() => BottomSheetAudioState();
// }

// class BottomSheetAudioState extends State<BottomSheetAudio> {
//   // final scaffoldKey = GlobalKey<ScaffoldState>();
//   final core = Core();

//   int _verseIndex = 0;
//   int get _verseIndexMax => verseList.length-1;
//   bool get hasVersePrevious => _verseIndex > 0;
//   bool get hasVerseNext => _verseIndex < _verseIndexMax;

//   CollectionBible get info => core.collectionPrimary;
//   BIBLE get bible => core.scripturePrimary.verseChapterData;
//   // CollectionBible get info => core.collectionParallel;
//   // BIBLE get bible => core.scriptureParallel.verseChapterData;

//   // CollectionBible get tmpbible => bible?.info;
//   DefinitionBook get book => bible?.book?.first?.info;
//   CHAPTER get chapter => bible?.book?.first?.chapter?.first;
//   List<VERSE> get verseList => chapter?.verse;

//   String get bookName => book.name;
//   String get chapterName => chapter.name;
//   // String get verseName => bible.book.first.chapter.first.verse.first.name;
//   // String get verseName => verseList[_verseIndex].name;

//   String get widgetTitle => bible.info.shortname;

//   // NOTE: when verse slider slide, click next or previous button while playing
//   bool hasPause = false;
//   get hasPlay => core.speechState == SpeechState.playing;
//   // get hasStop => core.speechState == SpeechState.stopped;
//   // get isPaused??? => core.speechState == SpeechState.paused;
//   // get isContinued => core.speechState == SpeechState.continued;

//   @override
//   initState() {
//     super.initState();
//     // TODO: change primary scroll when next and previous button are tap
//     initTts();
//   }

//   initTts() {
//     core.speechCore.setStartHandler(() {
//       setState(() => core.speechState = SpeechState.playing);
//     });

//     core.speechCore.setCompletionHandler(() {
//       if (_verseIndex < verseList.length) {
//         _verseIndex++;
//         if (_verseIndex < verseList.length){
//           _play();
//           return;
//         }
//       }
//       _verseIndex = 0;
//       setState(() => core.speechState = SpeechState.stopped);
//     });

//     core.speechCore.setCancelHandler(() {
//       setState(() => core.speechState = SpeechState.stopped);
//     });

//     core.speechCore.setErrorHandler((e) {
//       print(e);
//       setState(() => core.speechState = SpeechState.stopped);
//     });
//   }

//   Future _play() async {
//     await core.speechCore.setVolume(core.speechVolume);
//     await core.speechCore.setSpeechRate(core.speechRate);
//     await core.speechCore.setPitch(core.speechPitch);
//     if (core.speechLangName != null) {
//       if (verseToSpeech.isNotEmpty) {
//         await widget.scrollToIndex(_verseIndex);
//         var result = await core.speechCore.speak(verseToSpeech);
//         if (result == 1) setState(() => core.speechState = SpeechState.playing);
//       }
//     } else {
//       print('please choose language');
//     }
//   }

//   Future _stop() async {
//     var result = await core.speechCore.stop();
//     if (result == 1) setState(() => core.speechState = SpeechState.stopped);
//   }

//   void _next(){
//     if (hasVerseNext){
//       _verseIndex++;
//     } else {
//       _verseIndex = 0;
//     }
//     setState((){});
//     if (hasPlay) {
//       _stop();
//       _play();
//     } else {
//       widget.scrollToIndex(_verseIndex);
//     }
//   }

//   void _previous() {
//     if (hasVersePrevious){
//       _verseIndex--;
//     } else {
//       _verseIndex = 0;
//     }
//     setState((){});
//     if (hasPlay) {
//       _stop();
//       _play();
//     } else {
//       widget.scrollToIndex(_verseIndex);
//     }
//   }

//   VERSE get verse {
//     if (verseList.length > 0) {
//       // if (_verseIndex < verseList.length) {
//       //   return verseList[_verseIndex];
//       // }
//       // NOTE: when primary chapter change, and previous.length is greater than current.length
//       if (_verseIndex > _verseIndexMax) {
//         _verseIndex = 0;
//       }
//       return verseList[_verseIndex];
//     }
//     return null;
//   }

//   String get verseToSpeech {
//     // audioVerseList.length
//     if (verse == null) {
//       return '';
//     }
//     return verse.text;
//   }



//   @override
//   void dispose() {
//     super.dispose();
//     core.speechCore.stop();
//   }

//   List<DropdownMenuItem<String>> getLanguageDropDownMenuItems() {
//     var items = List<DropdownMenuItem<String>>();
//     for (dynamic type in core.speechLangList) {
//       items.add(DropdownMenuItem(value: type as String, child: Text(type as String)));
//     }
//     return items;
//   }

//   void changedLanguageDropDownItem(String selectedType) {
//     setState(() {
//       core.speechLangName = selectedType;
//       core.speechCore.setLanguage(core.speechLangName);
//     });
//   }

//   Widget dropdownWidget() {
//     return DropdownButton(
//       items: getLanguageDropDownMenuItems(),
//       onChanged:changedLanguageDropDownItem,
//       value: core.speechLangName,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: NestedScrollView(
//         // controller: widget.controller,
//         physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
//         headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
//           return <Widget>[
//             SliverOverlapAbsorber(
//               handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
//               sliver: SliverAppBar(
//                 backgroundColor: Colors.transparent,
//                 elevation: 0,
//                 title: Text(widgetTitle),
//                 actions: <Widget>[
//                   // CupertinoButton(
//                   //   onPressed: null,
//                   //   child:Icon(Icons.linear_scale),
//                   // )
//                   dropdownWidget()
//                 ]
//               )
//             ),
//           ];
//         },
//         body: Builder(
//           builder: (BuildContext context) {
//             return CustomScrollView(
//               physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
//               slivers: <Widget>[
//                 SliverOverlapInjector(
//                   handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context)
//                 ),
//                 // SliverToBoxAdapter()
//                 SliverToBoxAdapter(
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(vertical:10),
//                     child: audioStatus(),
//                   ),
//                 ),
//                 SliverToBoxAdapter(
//                   child: audioController(),
//                 ),
//                 SliverToBoxAdapter(
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(vertical:10, horizontal: 20),
//                     child: information(),
//                   ),
//                 ),
//                 SliverToBoxAdapter(
//                   child: _settingColumn(),
//                 )
//               ]
//             );
//           }
//         )
//       ),
//     );
//   }

//   Widget audioController(){
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         RaisedButton(
//           padding: EdgeInsets.all(5),
//           child: Icon(
//             Icons.keyboard_arrow_left,size: 40,
//           ),
//           shape: new CircleBorder(),
//           elevation: 1.5,
//           highlightElevation: 1.0,
//           disabledElevation: 0.5,
//           color: Colors.white,
//           textColor: Colors.grey,
//           disabledColor: Colors.white.withOpacity(0.9),
//           materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//           onPressed: hasVersePrevious?_previous:null,
//           // shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0),
//           // side: BorderSide(color: Colors.grey))
//         ),
//         RaisedButton(
//           padding: EdgeInsets.all(5),
//           child: Icon(
//             hasPlay?Icons.pause:Icons.play_arrow, size: 50,
//           ),
//           shape: new CircleBorder(
//             // side: BorderSide(color: Colors.grey[200])
//           ),
//           elevation: 1.5,
//           highlightElevation: 1.0,
//           disabledElevation: 0.8,
//           color: Colors.white,
//           textColor: Colors.grey,
//           disabledColor: Colors.white.withOpacity(0.9),
//           materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//           onPressed: (core.speechLangName == null)?null:hasPlay?_stop:_play,
//           // onPressed: ()=>null,
//         ),
//         RaisedButton(
//           padding: EdgeInsets.all(5),
//           child: Icon(
//             Icons.keyboard_arrow_right, size: 40,
//           ),
//           shape: new CircleBorder(),
//           elevation: 1.5,
//           highlightElevation: 1.0,
//           disabledElevation: 0.5,
//           color: Colors.white,
//           textColor: Colors.grey,
//           disabledColor: Colors.white.withOpacity(0.9),
//           materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//           onPressed: hasVerseNext?_next:null,
//         ),
//       ],
//     );
//   }

//   Widget audioStatus(){
//     return RichText(
//       textAlign: TextAlign.center,
//       text: new TextSpan(
//         text: '$bookName ',
//         // text: primaryBible.book.first.info.name,
//         children: <TextSpan>[
//           new TextSpan(
//             text: chapterName
//           ),
//           new TextSpan(
//             // text: primaryBible.book.first.chapter.first.verse.first.name
//             text: ': '+verse.name
//           ),
//         ],
//         style: TextStyle(
//           color: Colors.black54
//         )
//       )
//     );
//   }

//   Widget information(){
//     // return Column(
//     //   children: [
//     //     Text(info.),
//     //     Text('1900'),
//     //   ],
//     // );
//     return RichText(
//       textAlign: TextAlign.center,
//       text: new TextSpan(
//         text: info.name,
//         children: <TextSpan>[
//           // new TextSpan( text: '\n'),
//           new TextSpan(
//             text: ' (${info.year}). '
//           ),
//           new TextSpan( text: '\n'),
//           new TextSpan(
//             text: 'Audio is basically text-to-speech API that are available on your device.'
//           ),
//           new TextSpan(
//             text: ' Language must be selected before it can play'
//           ),
//           new TextSpan(
//             text: '...'
//           ),
//         ],
//         style: TextStyle(
//           color: Colors.black54
//         )
//       )
//     );
//   }

//   Widget _settingColumn() {
//     return Column(
//       children: [
//         _verseSlider(),
//         _volume(),
//         _pitch(),
//         _rate()
//       ],
//     );
//   }

//   Widget _verseSlider() {
//     return Slider(
//       value: _verseIndex.toDouble(),
//       onChanged: (v) {
//         if (hasPlay) {
//           _stop();
//           hasPause = true;
//         }
//         setState(
//           () => _verseIndex = v.toInt()
//         );
//       },

//       onChangeEnd: (v) async{
//         await widget.scrollToIndex(_verseIndex);
//         if (hasPause) {
//           _play();
//           hasPause = false;
//         }
//       },
//       min: 0.0,
//       max: (verseList.length-1).toDouble(),
//       divisions: verseList.length,
//       label: "Verse: ${verse.name}",
//       inactiveColor: Colors.grey[300],
//       activeColor: Colors.grey,
//     );
//   }

//   Widget _volume() {
//     return Slider(
//       value: core.speechVolume,
//       onChanged: (volume) {
//         setState(() => core.speechVolume = volume);
//       },
//       min: 0.0,
//       max: 1.0,
//       divisions: 10,
//       label: "Volume: ${core.speechVolume}",
//       inactiveColor: Colors.grey[300],
//       activeColor: Colors.grey,
//     );
//   }

//   Widget _pitch() {
//     return Slider(
//       value: core.speechPitch,
//       onChanged: (pitch) {
//         setState(() => core.speechPitch = pitch);
//       },
//       min: 0.5,
//       max: 2.0,
//       divisions: 15,
//       label: "Pitch: ${core.speechPitch}",
//       inactiveColor: Colors.grey[300],
//       activeColor: Colors.grey,
//     );
//   }

//   Widget _rate() {
//     return Slider(
//       value: core.speechRate,
//       onChanged: (rate) {
//         setState(() => core.speechRate = rate);
//       },
//       min: 0.0,
//       max: 1.0,
//       divisions: 10,
//       label: "Rate: ${core.speechRate}",
//       inactiveColor: Colors.grey[300],
//       activeColor: Colors.grey,
//     );
//   }
// }