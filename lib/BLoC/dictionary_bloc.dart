import 'dart:async';

import 'package:personal_dictionary/Model/Word.dart';
import 'package:personal_dictionary/Repository/dictionary_repository.dart';

import 'bloc.dart';

class DictionaryBloc extends Bloc {
  final _controller = StreamController<List<Word>>();
  final _dictionaryRepository = DictionaryRepository();

  Stream<List<Word>> get stream => _controller.stream;

  List<Word> allWords = new List();

  @override
  void dispose() {
    _controller.close();
  }

  fetchAllWords() async {
    allWords = await _dictionaryRepository.getAllWords();
    _controller.sink.add(allWords);
  }

  addWord(Word word) async {
    await _dictionaryRepository.addNewWord(word);
    allWords.add(word);
    _controller.sink.add(allWords);
  }

  deleteWord(Word word) async {
    await _dictionaryRepository.deleteWord(word);
    allWords.remove(word);
    _controller.sink.add(allWords);
  }

  getWordsWithFilter(String word) {
    List<Word> searchResult =
        allWords.where((w) => w.word.toLowerCase().contains(word?.toLowerCase())).toList();
    _controller.sink.add(searchResult);
  }
}
