part of data.type;

class BoxOfBookmarks<E> extends BoxOfAbstract<BookmarksType> {
  int index(int bookId, int chapterId) {
    return indexOfvalues((e) => e.bookId == bookId && e.chapterId == chapterId);
    // return values.toList().indexWhere((e) => e.bookId == bookId && e.chapterId == chapterId);
  }

  Future<void> userSwitch(int index, String identify, int bookId, int chapterId) {
    if (index >= 0) {
      return deleteAtIndex(index);
    } else {
      return box.add(
        BookmarksType(
          identify: identify,
          date: DateTime.now(),
          bookId: bookId,
          chapterId: chapterId,
        ),
      );
    }
  }
}

@HiveType(typeId: 11)
class BookmarksType {
  @HiveField(0)
  String identify;

  @HiveField(1)
  DateTime? date;

  @HiveField(2)
  int bookId;
  @HiveField(3)
  int chapterId;

  BookmarksType({
    this.identify = '',
    this.date,
    this.bookId = 1,
    this.chapterId = 1,
  });

  factory BookmarksType.fromJSON(Map<String, dynamic> o) {
    return BookmarksType(
      identify: o["identify"] as String,
      date: o["date"] as DateTime,
      bookId: o["book"] as int,
      chapterId: o["chapterId"] as int,
    );
  }

  Map<String, dynamic> toJSON() {
    return {"identify": identify, "date": date, "bookId": bookId, "chapterId": chapterId};
  }
}

class BookmarksAdapter extends TypeAdapter<BookmarksType> {
  @override
  final int typeId = 11;

  @override
  BookmarksType read(BinaryReader reader) {
    final int numOfFields = reader.readByte();
    final Map<int, dynamic> fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    // this.identify:'',
    // this.date,
    // this.bookId:1,
    // this.chapterId:1,
    return BookmarksType()
      ..identify = fields[0] as String
      ..date = fields[1] as DateTime
      ..bookId = fields[2] as int
      ..chapterId = fields[3] as int;
  }

  @override
  void write(BinaryWriter writer, BookmarksType obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.identify)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.bookId)
      ..writeByte(3)
      ..write(obj.chapterId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookmarksAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
