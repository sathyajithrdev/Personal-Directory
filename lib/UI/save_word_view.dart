import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_dictionary/BLoC/dictionary_bloc.dart';
import 'package:personal_dictionary/BLoC/home_state_bloc.dart';
import 'package:personal_dictionary/Common/custom_colors.dart';
import 'package:personal_dictionary/Interface/IDictionaryEventListener.dart';
import 'package:personal_dictionary/Model/word.dart';
import 'package:personal_dictionary/Widget/base_stateless_widget.dart';

class SaveViewWord extends BaseStatelessWidget {
  final IDictionaryEventListener dictionaryEventListener;
  final DictionaryBloc bloc;
  final HomeStateBloc homeStateBloc;

  final TextEditingController _newWordTextController = TextEditingController();
  final TextEditingController _meaningTextController = TextEditingController();
  final Word wordToUpdate;
  final bool isUpdateMode;

  SaveViewWord(
      {@required this.homeStateBloc,
      this.wordToUpdate,
      this.dictionaryEventListener})
      : isUpdateMode = wordToUpdate != null,
        bloc = DictionaryBloc(listener: dictionaryEventListener);

  @override
  Widget build(BuildContext context) {
    _newWordTextController.text = wordToUpdate?.word ?? "";
    _meaningTextController.text = wordToUpdate?.meaning ?? "";

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
                onPressed: () => _addNewOrUpdateWord(),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _addNewOrUpdateWord() async {
    if (isUpdateMode) {
      await updateWord();
    } else {
      await addNewWord();
    }
  }

  Future updateWord() async {
    this.wordToUpdate.word = _newWordTextController.text;
    this.wordToUpdate.meaning = _meaningTextController.text;
    var validation = bloc.validateWordToSave(this.wordToUpdate);
    if (validation.item1) {
      await bloc.updateWord(wordToUpdate);
      showToast("Updated word :)");
    } else {
      showToast(validation.item2);
    }
  }

  Future addNewWord() async {
    var wordToAdd =
        Word(_newWordTextController.text, _meaningTextController.text);

    var validation = bloc.validateWordToSave(wordToAdd);
    if (validation.item1) {
      await bloc.addWord(wordToAdd);
      showToast("New word added :)");
    } else {
      showToast(validation.item2);
    }
  }
}
