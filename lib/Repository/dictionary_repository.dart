import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_dictionary/Model/Word.dart';

class DictionaryRepository {
  final databaseReference = Firestore.instance;

  Future<List<Word>> getAllWords() async {
    var wordDocument =
        await databaseReference.collection('words').getDocuments();

    var words = new List<Word>();

    wordDocument.documents.forEach((g) {
      var data = g.data;
      words.add(new Word(g.documentID, data["word"], data["meaning"]));
    });
    return words;
  }

  Future<void> addNewWord(Word word) async {
    final CollectionReference postRef = databaseReference.collection('words');
    await Firestore.instance.runTransaction((Transaction tx) async {
      await tx.set(postRef.document(), word.toJson());
    });
  }
}
