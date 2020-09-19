part of 'core.dart';

enum SpeechState { playing, stopped, paused, continued }

// speech
mixin _Speech {
  // FlutterTts speechCore;
  // dynamic speechLangList;
  // String speechLangName;
  // dynamic speechEngine;

  // double speechVolume = 0.9;
  // double speechPitch = .9;
  // double speechRate = .8;

  // SpeechState speechState = SpeechState.stopped;

  Future initSpeech() async{
    // speechCore = FlutterTts();
    // speechLangList = await speechCore.getLanguages;
    // // print(speechLangList);
    // if (!kIsWeb) {
    //   if (Platform.isAndroid) {
    //     speechEngine = await speechCore.getEngines;
    //   }
    // }
    // speechEngine = await speechCore.getEngines;
    // if (speechEngine != null) {
    //   for (dynamic engine in speechEngine) {
    //     print(engine);
    //   }
    // }
  }

}


/*

[ko-KR, mr-IN, ru-RU, zh-TW, hu-HU, th-TH, ur-PK, nb-NO, da-DK, tr-TR, et-EE, bs, sw, pt-PT, vi-VN, en-US, sv-SE, ar, su-ID, bn-BD, gu-IN, kn-IN, el-GR, hi-IN, fi-FI, km-KH, bn-IN, fr-FR, uk-UA, en-AU, nl-NL, fr-CA, sr, pt-BR, ml-IN, si-LK, de-DE, ku, cs-CZ, pl-PL, sk-SK, fil-PH, it-IT, ne-NP, hr, en-NG, zh-CN, es-ES, cy, ta-IN, ja-JP, sq, yue-HK, en-IN, es-US, jv-ID, la, id-ID, te-IN, ro-RO, ca, en-GB]

  initTts() {
    // flutterTts = FlutterTts();

    // _getLanguages();

    // if (!kIsWeb) {
    //   if (Platform.isAndroid) {
    //     _getEngines();
    //   }
    // }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      // if (audioVerseList.length > 0) {
      //   if (audioVerseIndex < audioVerseList.length) {
      //     audioVerseIndex++;
      //   }
      // }
      if (audioVerseIndex < audioVerseList.length) {
        audioVerseIndex++;
        print("Next $audioVerseIndex");
        _speak();
      } else {
        print("Complete");
        setState(() {
          ttsState = TtsState.stopped;
        });
      }
      // print("Complete");
      // setState(() {
      //   ttsState = TtsState.stopped;
      // });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        print("Cancel");
        ttsState = TtsState.stopped;
      });
    });

    if (kIsWeb || Platform.isIOS) {
      flutterTts.setPauseHandler(() {
        setState(() {
          print("Paused");
          ttsState = TtsState.paused;
        });
      });

      flutterTts.setContinueHandler(() {
        setState(() {
          print("Continued");
          ttsState = TtsState.continued;
        });
      });
    }

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  // Future _getLanguages() async {
  //   languages = await flutterTts.getLanguages;
  //   if (languages != null) setState(() => languages);
  // }

  // Future _getEngines() async {
  //   var engines = await flutterTts.getEngines;
  //   if (engines != null) {
  //     for (dynamic engine in engines) {
  //       print(engine);
  //     }
  //   }
  // }

  Future _speak() async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);
    _newVoiceText = verseToSpeech;
    if (language != null) {
      print(language+' : '+_newVoiceText);
      if (_newVoiceText.isNotEmpty) {
        var result = await flutterTts.speak(_newVoiceText);
        if (result == 1) setState(() => ttsState = TtsState.playing);
      }
    } else {
      print('please choose language');
    }
  }

  String get verseToSpeech {
    // audioVerseList.length
    if (audioVerseList.length > 0) {
      if (audioVerseIndex < audioVerseList.length) {
        // VERSE verse = audioVerseList[audioVerseIndex];
        VERSE verse = audioVerseList.singleWhere((e) => e.id == audioVerseIndex);
        return verse.text;
      }
    }
    return '';
  }

  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  // Future _pause() async {
  //   var result = await flutterTts.pause();
  //   if (result == 1) setState(() => ttsState = TtsState.paused);
  // }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  List<DropdownMenuItem<String>> getLanguageDropDownMenuItems() {
    var items = List<DropdownMenuItem<String>>();
    for (dynamic type in languages) {
      items.add(DropdownMenuItem(value: type as String, child: Text(type as String)));
    }
    return items;
  }

  void changedLanguageDropDownItem(String selectedType) {
    setState(() {
      language = selectedType;
      flutterTts.setLanguage(language);
    });
  }

  // void _onChange(String text) {
  //   setState(() {
  //     _newVoiceText = text;
  //   });
  // }

  Widget dropdownWidget() {
    return DropdownButton(
      //map each value from the lIst to our dropdownMenuItem widget
      items: getLanguageDropDownMenuItems(),
      onChanged:changedLanguageDropDownItem,
      value: language,
    );
    //     if (languages != null) DropdownButton(
    //       value: language,
    //       items: getLanguageDropDownMenuItems(),
    //       onChanged: changedLanguageDropDownItem,
    //     )
  }
*/