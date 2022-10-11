part of data.type;

class BoxOfBooks<E> extends BoxOfAbstract<BooksType> {}

@HiveType(typeId: 10)
class BooksType {
  @HiveField(0)
  String identify;
  @HiveField(1)
  String name;
  @HiveField(2)
  String shortname;

  @HiveField(3)
  int year;
  @HiveField(4)
  int version;

  @HiveField(5)
  String description;
  @HiveField(6)
  String publisher;
  @HiveField(7)
  String contributors;
  @HiveField(8)
  String copyright;

  @HiveField(9)
  int available;
  @HiveField(10)
  int update;

  @HiveField(11)
  String langName;
  @HiveField(12)
  String langCode;
  @HiveField(13)
  String langDirection;

  @HiveField(14)
  bool selected;

  BooksType({
    this.identify = '',
    this.name = '',
    this.shortname = '',
    this.year = 0,
    this.version = 0,
    this.description = '',
    this.publisher = '',
    this.contributors = '',
    this.copyright = '',
    this.available = 0,
    this.update = 0,
    this.langName = '',
    this.langCode = '',
    this.langDirection = 'ltr',
    this.selected = false,
  });

  factory BooksType.fromJSON(Map<String, dynamic> o) {
    String stringProperty(String key) {
      // NOTE: required for some of the previous version
      if (o.containsKey(key)) {
        if (o[key] is String) {
          return o[key];
        } else if (o[key] is Map && o[key].containsKey('text')) {
          return o[key]['text'];
        }
      }
      return '';
    }

    int intProperty(String key) {
      // NOTE: required for some of the previous version
      if (o.containsKey(key)) {
        if (o[key] is String) {
          return int.parse(o[key]);
        } else {
          return int.parse(o[key].toString());
        }
      }
      return 0;
    }

    return BooksType(
      identify: o['identify'],
      name: o['name'],
      shortname: o['shortname'],
      description: stringProperty('description'),
      publisher: stringProperty('publisher'),
      contributors: stringProperty('contributors'),
      copyright: stringProperty('copyright'),
      year: intProperty('year'),
      version: intProperty('version'),
      available: intProperty('available'),
      update: intProperty('update'),

      // identify: o["identify"] as String,
      // name: o["name"] as String,
      // shortname: o["shortname"] as String,
      // year: o["year"] as int,
      // version: o["version"] as int,
      // description: o["description"] as String,
      // publisher: o["publisher"] as String,

      langName: o["language"]['text'] as String,
      langCode: o["language"]['name'] as String,
      langDirection: o["language"]['textdirection'] as String,
      // hit: o["hit"] as int,
      // date: o["date"] as DateTime
      selected: (o["selected"] ?? false) as bool,
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "identify": identify,
      "name": name,
      "shortname": shortname,
      "year": year,
      "version": version,
      "description": description,
      "publisher": publisher,
      "contributors": contributors,
      "copyright": copyright,
      "available": available,
      "update": update,
      "langName": langName,
      "langCode": langCode,
      "langDirection": langDirection,
      "selected": selected,
    };
  }

  BooksType copyWith({
    String? identify,
    String? name,
    String? shortname,
    int? year,
    int? version,
    String? description,
    String? publisher,
    String? contributors,
    String? copyright,
    int? available,
    int? update,
    String? langName,
    String? langCode,
    String? langDirection,
    bool? selected,
  }) {
    return BooksType(
      identify: identify ?? this.identify,
      name: name ?? this.name,
      shortname: shortname ?? this.shortname,
      year: year ?? this.year,
      version: version ?? this.version,
      description: description ?? this.description,
      publisher: publisher ?? this.publisher,
      contributors: contributors ?? this.contributors,
      copyright: copyright ?? this.copyright,
      available: available ?? this.available,
      update: update ?? this.update,
      langName: langName ?? this.langName,
      langCode: langCode ?? this.langCode,
      langDirection: langDirection ?? this.langDirection,
      selected: selected ?? this.selected,
    );
  }

  // BooksType userSetting() {
  //   return BooksType(
  //     available:this.available,
  //     update:this.update
  //   );
  //   // return {
  //   //   available:this.available,
  //   //   order:this.order
  //   // };
  // }
  // BooksType copyWith({
  //   int? version,
  //   int? mode,
  //   double? fontSize,
  //   String? searchQuery,

  //   String? identify,
  //   int? bookId,
  //   int? chapterId,
  //   int? verseId,
  // }) {
  //   return BooksType(
  //     version: version??this.version,
  //     mode: mode??this.mode,
  //     fontSize: fontSize??this.fontSize,
  //     searchQuery: searchQuery??this.searchQuery,

  //     identify: identify??this.identify,
  //     bookId: bookId??this.bookId,
  //     chapterId: chapterId??this.chapterId,
  //     verseId: verseId??this.verseId
  //   );
  // }
}

class BooksAdapter extends TypeAdapter<BooksType> {
  @override
  final int typeId = 10;

  @override
  BooksType read(BinaryReader reader) {
    final int numOfFields = reader.readByte();
    final Map<int, dynamic> fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BooksType()
      ..identify = fields[0] as String
      ..name = fields[1] as String
      ..shortname = fields[2] as String
      ..year = fields[3] as int
      ..version = fields[4] as int
      ..description = fields[5] as String
      ..publisher = fields[6] as String
      ..contributors = fields[7] as String
      ..copyright = fields[8] as String
      ..available = fields[9] as int
      ..update = fields[10] as int
      ..langName = fields[11] as String
      ..langCode = fields[12] as String
      ..langDirection = fields[13] as String
      ..selected = (fields[14] ?? false) as bool;
  }

  @override
  void write(BinaryWriter writer, BooksType obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.identify)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.shortname)
      ..writeByte(3)
      ..write(obj.year)
      ..writeByte(4)
      ..write(obj.version)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.publisher)
      ..writeByte(7)
      ..write(obj.contributors)
      ..writeByte(8)
      ..write(obj.copyright)
      ..writeByte(9)
      ..write(obj.available)
      ..writeByte(10)
      ..write(obj.update)
      ..writeByte(11)
      ..write(obj.langName)
      ..writeByte(12)
      ..write(obj.langCode)
      ..writeByte(13)
      ..write(obj.langDirection)
      ..writeByte(14)
      ..write(obj.selected);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BooksAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
