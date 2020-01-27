import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_dictionary/BLoC/dictionary_bloc.dart';
import 'package:personal_dictionary/Common/custom_colors.dart';
import 'package:personal_dictionary/Model/word.dart';
import 'package:personal_dictionary/Widget/base_stateless_widget.dart';

class SaveViewWord extends BaseStatelessWidget {
  final DictionaryBloc _bloc = DictionaryBloc();
  final TextEditingController _newWordTextController = TextEditingController();
  final TextEditingController _meaningTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 200,
              width: 200,
              child: FlareActor("assets/animations/analysis.flr",
                  animation: "analysis", color: Colors.red),
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
        ),
      ),
    );
  }

  void _addNewWord() async {
    var word = _newWordTextController.text;
    var meaning = _meaningTextController.text;
    if (word != null &&
        word.isNotEmpty &&
        meaning != null &&
        meaning.isNotEmpty) {
      await _bloc.addWord(Word(word, meaning));
      showToast("New word added :)");
    } else {
      showToast("Enter word and meaning to save");
    }
  }
}
