# Type and models

connection

```shell
word -> { w: wordId, v: string }
sense -> { i: uId, w: wordId, t: 0, v: string }
usage -> { i: uId, v: string }
```

List of ResultModel

```json
[
  {
    word:'',
    sense:[
      {
        pos:'',
        clue:[
          {
            mean:''
            exam:['','']
          }
        ]
      }
    ],
    thesaurus:[]
  }
]
```

```dart
Iterable<WordType> get wordValues => Hive.box<WordType>(_wordName).values;
Iterable<SenseType> get senseValues => Hive.box<SenseType>(_senseName).values;
Iterable<UsageType> get usageValues => Hive.box<UsageType>(_usageName).values;
Iterable<SynsetType> get synsetValues => Hive.box<SynsetType>(_synsetName).values;
Iterable<SynmapType> get synmapValues => Hive.box<SynmapType>(_synmapName).values;

Iterable<WordType> suggestion(String word) => wordValues.where((e) => e.v.toLowerCase() == word.toLowerCase());
Iterable<WordType> suggestion(String word) => wordValues.where((e) => new RegExp(word,caseSensitive: false).hasMatch(e.v));
Iterable<WordType> wordStartWith(String word) => wordValues.where((e) => e.charStartsWith(word));
Iterable<WordType> wordExactMatch(String word) => wordValues.where((e) => e.charMatchExact(word));

factory Collection.fromJSON(Map<String, dynamic> o) {
  // NOTE: change of collection bible model
  return Collection(
    version: o['version'] as int,
    setting: CollectionSetting.fromJSON(o['setting']),
    keyword: o['keyword'].map<CollectionKeyword>((json) => CollectionKeyword.fromJSON(json)).toList(),
    // bible: o['bible'].map<CollectionBible>((json) => CollectionBible.fromJSON(json)).toList(),
    bible: (o['bible']??o['book']).map<CollectionBible>((json) => CollectionBible.fromJSON(json)).toList(),
    bookmark: o['bookmark'].map<CollectionBookmark>((json) => CollectionBookmark.fromJSON(json)).toList(),
  );
}

Map<String, dynamic> toJSON() {
  // List bible = _collectionBook.map((e)=>e.toJSON()).toList();
  return {
    'version':this.version,
    'setting':this.setting.toJSON(),
    'keyword':this.keyword.map((e)=>e.toJSON()).toList(),
    'bible':this.bible.map((e)=>e.toJSON()).toList(),
    'bookmark':this.bookmark.map((e)=>e.toJSON()).toList()
  };
}
```

ObjectMapType -> json

```json
{
  "key": {
    "a": "1",
    "b": "2",
    "c": "3"
  }
}
```

ObjectMapType

```dart
class ObjectMapType {
  Map<String, String> data;

  ObjectMapType({
    this.data,
  });

  factory ObjectMapType.fromJSON(Map<String, dynamic> o) {
    return ObjectMapType(
      data: Map.from(o["key"]).map((k, v) => MapEntry<String, String>(k, v)),
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "data": Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v))
    };
  }
}
```

ObjectListType -> json

```json
{
  "1": ["a","b","c"],
  "2": ["d","e","f"],
  "3": ["g","h","i"]
}
```

ObjectListType ??

```dart
class ObjectListType {
  String word;
  List<String> synonym;

  ObjectListType({
    this.word,
    this.synonym,
  });

  factory ObjectListType.fromJSON(Map<String, dynamic> o) {
    return ObjectListType(
      word: Map.from(o).map((k, v) => MapEntry<String, String>(k, v)),
      synonym: Map.from(o["key"]).map((k, v) => MapEntry<String, String>(k, v)),
    );
  }
//v: List.from(o['v'])
      // v: (o['v'] as List<dynamic>).cast<String>()

  Map<String, dynamic> toJSON() {
    return {
      "word": Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v))
      "synonym": Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v))
    };
  }
}
```

Makeup

```dart
final str = 'hello world [none] [~:zoo] [list:year] [also:yuppy] [list:good/better/best]';
final mks = 'none (-~-) {-zoo-} {-year-} (-also-) {-yuppy-} {-good-}, {-better-}, {-best-}';
String makeupChildrenTesting(String str) {
  // RegExp(r'\b\w+\b')
  return str.replaceAllMapped(RegExp(r'\[(.*?)\]'), (Match reg) {
    if (reg.groupCount > 1) return reg.group(0).toString();

    List<String> t = reg.group(1).toString().split(':');
    String name = t.first;
    String e = t.last;
    if (e.isNotEmpty) {
      List<String> href = e.split('/').map((i) => '{-$i-}').toList();
      if (name == 'list'){
        return href.join(', ');
      } else {
        return '(-0-) 1'.replaceAll('0',name).replaceAll('1',href.join(', '));
      }
    }
    return reg.group(0).toString();
  });
}

String makeupChildrenTesting(String str) {
  // RegExp(r'\b\w+\b')
  return str.replaceAllMapped(RegExp(r'\[(.*?)\]'), (Match reg) {
    if (reg.groupCount > 1) return reg.group(0).toString();

    String m = reg.group(1).toString();
    List<String> t = m.split(':');
    String name = t.first;
    String e = t.last;
    if (e.isNotEmpty) {
      return '($m)';
    }
    return reg.group(0).toString();
  });
}

final mks = 'none (-~-) {-zoo-} {-year-} (-also-) {-yuppy-} {-good-}, {-better-}, {-best-}';
final str = 'hello world (love) [none] [~:zoo(abc)] [space list:year] [also:yuppy] [list:good/better/best] last!';
final regExp = RegExp(r'\[(.*?)\]|\((.*?)\)',multiLine: true, dotAll: false, unicode: true);
List<String> makeupChildrenTesting() {
  return str.split(regExp.allMatches(str).map(
    (Match reg)  {
      return reg.group(0).toString();
    }
  ));
}

List<String> makeupChildrenList(String str) {

  return RegExp(r'\[(.*?)\]|\((.*?)\)').allMatches(str).map(
    (Match reg)  {
      if (reg.groupCount > 1) return reg.group(0).toString();
      List<String> t = reg.group(1).toString().split(':');
      String name = t.first;
      String e = t.last;
      if (e.isNotEmpty) {
        List<String> href = e.split('/').map((i) => '{-$i-}').toList();
        if (name == 'list'){
          return href.join(', ');
        } else {
          return '(-0-) 1'.replaceAll('0',name).replaceAll('1',href.join(', '));
        }
      }
      return reg.group(0).toString();
    }
  );

  Iterable<Match> abc = RegExp(r'\[(.*?)\]').allMatches(str);
  return abc.map(
    (Match reg) {
      if (reg.groupCount > 1) return reg.group(0).toString();
      List<String> t = reg.group(1).toString().split(':');
      String name = t.first;
      String e = t.last;
      if (e.isNotEmpty) {
        List<String> href = e.split('/').map((i) => '{-$i-}').toList();
        if (name == 'list'){
          return href.join(', ');
        } else {
          return '(-0-) 1'.replaceAll('0',name).replaceAll('1',href.join(', '));
        }
      }
      return reg.group(0).toString();
    }
  ).toList();
}

final str = 'hello world (love) [none] [~:zoo(abc)] [space list:year] [also:yuppy] [list:good/better/best] last!';
final mks = 'none (-~-) {-zoo-} {-year-} (-also-) {-yuppy-} {-good-}, {-better-}, {-best-}';
final regExp = RegExp(r'\((.*?)\)|\[(.*?)\]',multiLine: true, dotAll: false, unicode: true);
List<String> makeupChildrenTesting() {
  return str.split(regExp);
}

final List<String> span = [];

void main() {
  str.splitMapJoin(regExp,
    onMatch: (Match match) {
      String matchString = match.group(0).toString();

      List<String> t = chunks[i].replaceAllMapped(exp, (Match e) => e.group(1)).toString().split(':');
      String name = t.first;
      String e = t.last;
      if (t.length == 2 && e.isNotEmpty) {
      }
      if (match.group(1).isNotEmpty)

      span.add(matchString);
      return matchString;
    },
    onNonMatch: (String nonMatch) {
      nonMatch = nonMatch.trim();
      if (nonMatch.isNotEmpty) {
        span.add(nonMatch);
      }
      return nonMatch;
    }
  );
  debugPrint(span);
}


```

```dart
data = Hive.box<BoxModel>(boxName);
ValueListenableBuilder(
  valueListenable: data.listenable(),
  builder: (context, Box<BoxModel> items, _) => 'return widget'
);
```
