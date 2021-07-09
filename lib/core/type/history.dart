
part of 'main.dart';

// NOTE: adapter/history.dart
@HiveType(typeId: 1)
class HistoryType {
  @HiveField(0)
  String word;

  @HiveField(1)
  int hit;

  @HiveField(2)
  DateTime? date;

  HistoryType({
    this.word:'',
    this.hit:0,
    this.date,
  });

  factory HistoryType.fromJSON(Map<String, dynamic> o) {
    return HistoryType(
      word: o["word"] as String,
      hit: o["hit"] as int,
      date: o["date"] as DateTime
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "word":word,
      "hit":hit,
      "date":date
    };
  }
}
