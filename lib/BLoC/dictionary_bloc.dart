import 'dart:async';

import 'package:personal_dictionary/Model/busy_data.dart';
import 'package:personal_dictionary/Model/word.dart';
import 'package:personal_dictionary/Repository/dictionary_repository.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc.dart';

class DictionaryBloc extends Bloc {
  final StreamController<List<Word>> _wordStreamController =
      new BehaviorSubject();
  final StreamController<int> _homeModeStreamController = new BehaviorSubject();
  final StreamController<BusyData> _loadingStreamController =
      new BehaviorSubject();

  final _dictionaryRepository = DictionaryRepository();

  Stream<List<Word>> get wordsStream => _wordStreamController.stream;

  Stream<int> get homeModeStream => _homeModeStreamController.stream;

  Stream<BusyData> get loadingStream => _loadingStreamController.stream;

  List<Word> allWords = new List();
  int homeMode = 1;

  DictionaryBloc() {
    _loadingStreamController.sink.add(new BusyData(isLoading: false));
    _homeModeStreamController.sink.add(homeMode);
  }

  @override
  void dispose() {
    _wordStreamController.close();
    _homeModeStreamController.close();
    _loadingStreamController.close();
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
    setIsLoading(
        isLoading: true, message: "Loading dictionary, please wait...");
    allWords = await _dictionaryRepository.getAllWords();
    _wordStreamController.sink.add(allWords);
    setIsLoading(isLoading: false);
  }

  addWord(Word word) async {
    setIsLoading(
        isLoading: true, message: "Adding word to dictionary, please wait...");
    await _dictionaryRepository.addNewWord(word);
    allWords.add(word);
    _wordStreamController.sink.add(allWords);
    setIsLoading(isLoading: false);
  }

  deleteWord(Word word) async {
    setIsLoading(
        isLoading: true,
        message: "Deleting word from dictionary, please wait...");
    await _dictionaryRepository.deleteWord(word);
    allWords.remove(word);
    _wordStreamController.sink.add(allWords);
    setIsLoading(isLoading: false);
  }

  getWordsWithFilter(String word) {
    List<Word> searchResult = allWords
        .where((w) => w.word.toLowerCase().contains(word?.toLowerCase()))
        .toList();
    _wordStreamController.sink.add(searchResult);
  }

  setIsLoading({bool isLoading, String message = ""}) {
    _loadingStreamController.sink
        .add(new BusyData(isLoading: isLoading, message: message));
  }
}
