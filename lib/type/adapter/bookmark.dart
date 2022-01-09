part of '../main.dart';

class BookmarkAdapter extends TypeAdapter<BookmarkType> {
  @override
  final int typeId = 2;

  @override
  BookmarkType read(BinaryReader reader) {
    final int numOfFields = reader.readByte();
    final Map<int, dynamic> fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    // this.identify:'',
    // this.date,
    // this.bookId:1,
    // this.chapterId:1,
    return BookmarkType()
      ..identify = fields[0] as String
      ..date = fields[1] as DateTime
      ..bookId = fields[2] as int
      ..chapterId = fields[3] as int;
  }

  @override
  void write(BinaryWriter writer, BookmarkType obj) {
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
      other is BookmarkAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;

}