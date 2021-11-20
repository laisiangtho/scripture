part of '../main.dart';

class BookAdapter extends TypeAdapter<BookType> {
  @override
  final int typeId = 9;

  @override
  BookType read(BinaryReader reader) {
    final int numOfFields = reader.readByte();
    final Map<int, dynamic> fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookType()
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
  void write(BinaryWriter writer, BookType obj) {
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
      other is BookAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
