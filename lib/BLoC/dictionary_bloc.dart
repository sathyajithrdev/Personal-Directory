import 'dart:async';

import 'package:personal_dictionary/Interface/IDictionaryEventListener.dart';
import 'package:personal_dictionary/Model/busy_data.dart';
import 'package:personal_dictionary/Model/word.dart';
import 'package:personal_dictionary/Repository/dictionary_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

import 'bloc.dart';

class DictionaryBloc extends Bloc {
  final IDictionaryEventListener listener;

  final StreamController<List<Word>> _wordStreamController =
      new BehaviorSubject();
  final StreamController<int> _homeModeStreamController = new BehaviorSubject();

  final _dictionaryRepository = DictionaryRepository();

  Stream<List<Word>> get wordsStream => _wordStreamController.stream;

  Stream<int> get homeModeStream => _homeModeStreamController.stream;

  List<Word> allWords = new List();
  int homeMode = 1;

  DictionaryBloc({this.listener}) {
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
    listener?.onEventStart(DictionaryEvent.FetchingWord);
    allWords = await _dictionaryRepository.getAllWords() ?? new List();
    _wordStreamController.sink.add(allWords);
    listener?.onEventCompleted(DictionaryEvent.FetchingWord);
  }

  addWord(Word word) async {
    listener?.onEventStart(DictionaryEvent.AddNewWord);
    await _dictionaryRepository.addNewWord(word);
    allWords.add(word);
    _wordStreamController.sink.add(allWords);
    listener?.onEventCompleted(DictionaryEvent.AddNewWord);
  }

  deleteWord(Word word) async {
    listener?.onEventStart(DictionaryEvent.DeleteWord);
    await _dictionaryRepository.deleteWord(word);
    allWords.remove(word);
    _wordStreamController.sink.add(allWords);
    listener?.onEventCompleted(DictionaryEvent.DeleteWord);
  }

  Future<void> updateWord(Word word) async {
    listener?.onEventStart(DictionaryEvent.UpdateWord);
    await _dictionaryRepository.updateWord(word);
    _wordStreamController.sink.add(allWords);
    listener?.onEventCompleted(DictionaryEvent.UpdateWord);

  }

  getWordsWithFilter(String word) {
    List<Word> searchResult = allWords
        .where((w) => w.word.toLowerCase().contains(word?.toLowerCase()))
        .toList();
    _wordStreamController.sink.add(searchResult);
  }

  Tuple2<bool, String> validateWordToSave(Word word) {
    if (word.word == null || word.word.trim().isEmpty) {
      return Tuple2(false, "Word can't be empty");
    }

    if (word.meaning == null || word.meaning.trim().isEmpty) {
      return Tuple2(false, "Meaning can't be empty");
    }

    return Tuple2(true, "");
  }
}

