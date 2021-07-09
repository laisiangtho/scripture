part of '../main.dart';

// NOTE: adapter/purchase.dart
// this.product,
// this.purchase,
// this.completePurchase,
// this.transactionDate,
class PurchaseAdapter extends TypeAdapter<PurchaseType> {
  @override
  final int typeId = 7;

  @override
  PurchaseType read(BinaryReader reader) {
    final int numOfFields = reader.readByte();
    final Map<int, dynamic> fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PurchaseType()
      ..productId = fields[0] as String
      ..purchaseId = fields[1] as String
      ..completePurchase = fields[2] as bool
      ..transactionDate = fields[3] as String
      ..consumable = fields[4] as bool;
  }

  @override
  void write(BinaryWriter writer, PurchaseType obj) {
    writer
      ..writeByte(5)

      ..writeByte(0)
      ..write(obj.productId)
      ..writeByte(1)
      ..write(obj.purchaseId)
      ..writeByte(2)
      ..write(obj.completePurchase)
      ..writeByte(3)
      ..write(obj.transactionDate)
      ..writeByte(4)
      ..write(obj.consumable);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PurchaseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;

}