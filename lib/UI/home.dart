import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:personal_dictionary/BLoC/bloc_provider.dart';
import 'package:personal_dictionary/BLoC/dictionary_bloc.dart';
import 'package:personal_dictionary/Common/CustomColors.dart';
import 'package:personal_dictionary/Common/CustomStyles.dart';
import 'package:personal_dictionary/Model/Word.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DictionaryBloc _bloc;
  List<String> animationList = [
    "human_1",
    "human_2",
    "human_3",
    "human_4",
    "human_5"
  ];
  int currentAnimation = 0;
  bool _isAddNewWord = false;
  TextEditingController _newWordTextController = TextEditingController();
  TextEditingController _meaningTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _bloc = DictionaryBloc();
    _bloc.fetchAllWords();
    return Scaffold(
      body: SafeArea(
        child: BlocProvider<DictionaryBloc>(
          bloc: _bloc,
          child: Container(
            child: getHomeScreenBody(),
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
        onPressed: _showAddNewWordUI,
      ),
    );
  }

  Widget getHomeScreenBody() {
    if (_isAddNewWord) {
      return getAddNewWordUI();
    }
    return getWordListUI();
  }

  Column getWordListUI() {
    return Column(
      children: <Widget>[
        _buildWordsSearch(),
        Expanded(
          child: _buildWordList(),
        )
      ],
    );
  }

  Widget getAddNewWordUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 200,
          width: 200,
          child: FlareActor("assets/animations/analysis.nma",
              animation: "apple_falls", color: Colors.red),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            decoration: BoxDecoration(
                color: CustomColors.searchBackground,
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.white70),
                    hintText: 'New word'),
                controller: _newWordTextController,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 30),
          child: Container(
            decoration: BoxDecoration(
                color: CustomColors.searchBackground,
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                style: TextStyle(color: Colors.white),
                maxLines: 4,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.white70),
                    hintText: 'Meaning',
                    fillColor: Colors.white),
                controller: _meaningTextController,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 50,
          width: 160,
          child: RaisedButton(
            elevation: 6,
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(24.0),
                side: BorderSide(color: Colors.lightBlueAccent)),
            color: Colors.teal,
            child: Text(
              "Save",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            onPressed: () => _addNewWord(),
          ),
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

  Widget _buildWordList() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: _buildStreamBuilder(),
    );
  }

  Widget _buildStreamBuilder() {
    return StreamBuilder(
      stream: _bloc.stream,
      builder: (context, snapshot) {
        final results = snapshot.data;

        if (results == null || results.isEmpty) {
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
        return Dismissible(
          key: Key(word.id),
          onDismissed: (direction) => _deleteWord(word),
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
                      child: Text(
                        word.word,
                        style: TextStyle(color: Colors.teal, fontSize: 16),
                      )),
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
        );
      },
    );
  }

  void _showAddNewWordUI() {
    setState(() {
      _isAddNewWord = !_isAddNewWord;
    });
  }

  void _addNewWord() async {
    var word = _newWordTextController.text;
    var meaning = _meaningTextController.text;
    if (word != null &&
        word.isNotEmpty &&
        meaning != null &&
        meaning.isNotEmpty) {
      await _bloc.addWord(Word(word, meaning));

      setState(() {
        if (currentAnimation < animationList.length) {
          currentAnimation = currentAnimation + 1;
        }
      });
      Fluttertoast.showToast(
          msg: "New word added :)",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  _deleteWord(Word word) async {
    await _bloc.deleteWord(word);

    Fluttertoast.showToast(
        msg: "Word deleted :)",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
