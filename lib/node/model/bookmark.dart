class CollectionBookmark {
  int book;
  int chapter;
  // String verse;
  CollectionBookmark({this.book, this.chapter});

  factory CollectionBookmark.fromJSON(Map<String, dynamic> o) {
    return CollectionBookmark(
      book: o['book'] as int,
      chapter: o['chapter'] as int
    );
  }
  Map<String, dynamic> toJSON() {
    return {
      'book': this.book,
      'chapter': this.chapter
    };
  }
  Map<String, dynamic> toView(chapterName,bookName,testamentName) {
    return this.toJSON()..addAll({
      'book': book,
      'chapter': chapter,
      'chapterName': chapterName,
      'bookName': bookName,
      'testamentName': testamentName
    });
    // return {
    //   'book': book,
    //   'chapter': chapter,
    //   'bookName': bookName
    // };
  }
}