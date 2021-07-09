
part of 'main.dart';

// item.productID == consumableId
// purchaseID
// transactionDate
// pendingCompletePurchase
@HiveType(typeId: 7)
class PurchaseType {
  @HiveField(0)
  String productId;

  @HiveField(1)
  String? purchaseId;

  @HiveField(2)
  bool completePurchase;

  @HiveField(3)
  String? transactionDate;

  @HiveField(4)
  bool? consumable;

  PurchaseType({
    this.productId:'',
    this.purchaseId,
    this.completePurchase:false,
    this.transactionDate,
    this.consumable:false
  });

  factory PurchaseType.fromJSON(Map<String, dynamic> o) {
    return PurchaseType(
      productId: o["productId"] as String,
      purchaseId: o["purchaseId"] as String,
      completePurchase: o["completePurchase"] as bool,
      transactionDate: o["transactionDate"] as String,
      consumable: o["consumable"] as bool
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "productId":productId,
      "purchaseId":purchaseId,
      "completePurchase":completePurchase,
      "transactionDate":transactionDate,
      "consumable":consumable
    };
  }
}