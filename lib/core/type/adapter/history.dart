part of '../main.dart';

class HistoryAdapter extends TypeAdapter<HistoryType> {
  @override
  final int typeId = 1;

  @override
  HistoryType read(BinaryReader reader) {
    final int numOfFields = reader.readByte();
    final Map<int, dynamic> fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HistoryType()
      ..word = fields[0] as String
      ..hit = fields[1] as int
      ..date = fields[2] as DateTime;
  }

  @override
  void write(BinaryWriter writer, HistoryType obj) {
    writer
      ..writeByte(3)

      ..writeByte(0)
      ..write(obj.word)
      ..writeByte(1)
      ..write(obj.hit)
      ..writeByte(2)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;

}