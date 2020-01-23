import 'dart:core';

class Word {
  String word;
  String meaning;
  String id;

  Word(String word, String meaning) {
    this.id = id;
    this.word = word;
    this.meaning = meaning;
  }

  Map<String, dynamic> toJson() {

    return {
      'word': word,
      'meaning': meaning
    };
  }
}
