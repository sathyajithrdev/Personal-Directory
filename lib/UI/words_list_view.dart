import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:personal_dictionary/BLoC/bloc_provider.dart';
import 'package:personal_dictionary/BLoC/dictionary_bloc.dart';
import 'package:personal_dictionary/Common/custom_colors.dart';
import 'package:personal_dictionary/Common/custom_styles.dart';
import 'package:personal_dictionary/Model/word.dart';
import 'package:personal_dictionary/Widget/base_stateless_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class WordListView extends BaseStatelessWidget {
  final DictionaryBloc _bloc = DictionaryBloc();

  @override
  Widget build(BuildContext context) {
    _bloc.fetchAllWords();
    return BlocProvider<DictionaryBloc>(
      bloc: _bloc,
      child: StreamBuilder(
          stream: _bloc.wordsStream,
          builder: (context, wordsSnapshot) {
            return getWordListUI(wordsSnapshot.data);
          }),
    );
  }

  Column getWordListUI(List<Word> words) {
    return Column(
      children: <Widget>[
        _buildWordsSearch(),
        Expanded(
          child: _buildWordList(words),
        )
      ],
    );
  }

  Padding _buildWordsSearch() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
            color: CustomColors.searchBackground,
            borderRadius: BorderRadius.circular(10)),
        child: TextField(
          onChanged: (query) => _bloc.getWordsWithFilter(query),
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.view_headline,
                color: Colors.white,
              ),
              hintStyle: TextStyle(color: Colors.white70),
              hintText: 'Search words'),
        ),
      ),
    );
  }

  Widget _buildWordList(List<Word> words) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: _buildStreamBuilder(words),
    );
  }

  Widget _buildStreamBuilder(List<Word> results) {
    if (results == null || results.isEmpty) {
      return Center(
          child: Text(
        'No words added yet;',
        style: CustomTextStyles.mediumTextStyle(),
      ));
    }
    return _buildSearchResults(results);
  }

  Widget _buildSearchResults(List<Word> results) {
    return ListView.separated(
      itemCount: results.length,
      separatorBuilder: (context, index) => Divider(),
      itemBuilder: (context, index) {
        final word = results[index];
        return Slidable(
          key: Key(word.id),
          actionPane: SlidableDrawerActionPane(),
          child: Container(
            decoration: BoxDecoration(
                color: CustomColors.wordsBackground,
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      child: Text(
                        word.word,
                        style: TextStyle(color: Colors.teal, fontSize: 16),
                      ),
                      onTap: () => openGoogleSearch(word.word),
                    ),
                  ),
                  Text(
                    "    ",
                    style: TextStyle(color: Colors.teal, fontSize: 16),
                  ),
                  Expanded(
                      flex: 7,
                      child: Text(
                        word.meaning,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ))
                ],
              ),
            ),
          ),
          actions: <Widget>[
            IconSlideAction(
                caption: 'Edit',
                color: Colors.green,
                iconWidget: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                )),
            IconSlideAction(
              caption: 'Delete',
              color: Colors.redAccent,
              iconWidget: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Icon(
                  Icons.delete_forever,
                  color: Colors.white,
                ),
              ),
              onTap: () => _deleteWord(word),
            ),
          ],
        );
      },
    );
  }

  _deleteWord(Word word) async {
    await _bloc.deleteWord(word);
    showToast("Word deleted :)");
  }

  openGoogleSearch(String word) async {
    String url = "http://www.google.com/search?q=$word+meaning";
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}
