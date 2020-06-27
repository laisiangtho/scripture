class CollectionKeyword {
  String word;
  CollectionKeyword({this.word});
  factory CollectionKeyword.fromJSON(String word) {
    return CollectionKeyword(
      word: word
    );
  }
  String toJSON() {
    return this.word;
  }
}