import 'dart:async';

import 'package:personal_dictionary/Model/Word.dart';

import 'bloc.dart';

class DictionaryBloc extends Bloc {
  final _controller = StreamController<List<Word>>();

  Stream<List<Word>> get stream => _controller.stream;

  List<Word> allWords = new List();

  @override
  void dispose() {
    _controller.close();
  }

  fetchAllWords() async {
    List<Word> words = new List();
    allWords = words;
    _controller.sink.add(words);
  }

  getWordsWithFilter(String word) {
    List<Word> searchResult = allWords.where((w) => w.word.contains(word)).toList();
    _controller.sink.add(searchResult);
  }
}
