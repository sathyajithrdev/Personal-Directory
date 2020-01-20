import 'package:flutter/material.dart';
import 'package:personal_dictionary/BLoC/bloc_provider.dart';
import 'package:personal_dictionary/BLoC/dictionary_bloc.dart';
import 'package:personal_dictionary/Common/CustomColors.dart';
import 'package:personal_dictionary/Common/CustomStyles.dart';
import 'package:personal_dictionary/Model/Word.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = DictionaryBloc();
    bloc.fetchAllWords();

    return Scaffold(
      body: SafeArea(
        child: BlocProvider<DictionaryBloc>(
          bloc: bloc,
          child: Container(
            child: Column(
              children: <Widget>[
                _buildWordsSearch(bloc),
                Expanded(
                  child: _buildWordList(bloc),
                )
              ],
            ),
            color: CustomColors.blackBackground,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Container(
          child: Icon(
            Icons.add,
            color: Colors.red,
          ),
        ),
        onPressed: _addNewWord,
      ),
    );
  }

  Padding _buildWordsSearch(DictionaryBloc bloc) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
            color: CustomColors.searchBackground,
            borderRadius: BorderRadius.circular(10)),
        child: TextField(
          onChanged: (query) => bloc.getWordsWithFilter(query),
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

  Widget _buildWordList(DictionaryBloc bloc) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: _buildStreamBuilder(bloc),
    );
  }

  Widget _buildStreamBuilder(DictionaryBloc bloc) {
    return StreamBuilder(
      stream: bloc.stream,
      builder: (context, snapshot) {
        final results = snapshot.data;

        if (results == null) {
          return Center(child: Text('Enter a restaurant name or cuisine type'));
        }

        if (results.isEmpty) {
          return Center(
              child: Text(
            'No words added yet;',
            style: CustomTextStyles.mediumTextStyle(),
          ));
        }

        return _buildSearchResults(results);
      },
    );
  }

  Widget _buildSearchResults(List<Word> results) {
    return ListView.separated(
      itemCount: results.length,
      separatorBuilder: (context, index) => Divider(),
      itemBuilder: (context, index) {
        final word = results[index];
        return Text(
          word.word,
          style: TextStyle(color: Colors.white),
        );
      },
    );
  }

  void _addNewWord() {}
}
