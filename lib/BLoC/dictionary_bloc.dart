import 'dart:async';

import 'package:personal_dictionary/Model/Word.dart';
import 'package:personal_dictionary/Repository/dictionary_repository.dart';

import 'bloc.dart';

class DictionaryBloc extends Bloc {
  final _wordStreamController = StreamController<List<Word>>();
  final _homeModeStreamController = StreamController<int>();
  final _dictionaryRepository = DictionaryRepository();

  Stream<List<Word>> get wordsStream => _wordStreamController.stream;

  Stream<int> get homeModeStream => _homeModeStreamController.stream;

  List<Word> allWords = new List();
  int homeMode = 1;

  DictionaryBloc() {
    _homeModeStreamController.sink.add(homeMode);
  }

  @override
  void dispose() {
    _wordStreamController.close();
    _homeModeStreamController.close();
  }

  setHomeMode() {
    if (homeMode == 1) {
      homeMode = 2;
      _homeModeStreamController.sink.add(homeMode);
    } else {
      homeMode = 1;
      _homeModeStreamController.sink.add(homeMode);
    }
  }

  fetchAllWords() async {
    allWords = await _dictionaryRepository.getAllWords();
    _wordStreamController.sink.add(allWords);
  }

  addWord(Word word) async {
    await _dictionaryRepository.addNewWord(word);
    allWords.add(word);
    _wordStreamController.sink.add(allWords);
  }

  deleteWord(Word word) async {
    await _dictionaryRepository.deleteWord(word);
    allWords.remove(word);
    _wordStreamController.sink.add(allWords);
  }

  getWordsWithFilter(String word) {
    List<Word> searchResult = allWords
        .where((w) => w.word.toLowerCase().contains(word?.toLowerCase()))
        .toList();
    _wordStreamController.sink.add(searchResult);
  }
}
