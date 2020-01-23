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
      var word = new Word(data["word"], data["meaning"]);
      word.id = g.documentID;
      words.add(word);
    });
    return words;
  }

  Future<void> addNewWord(Word word) async {
    final CollectionReference postRef = databaseReference.collection('words');
    await Firestore.instance.runTransaction((Transaction tx) async {
      await tx.set(postRef.document(), word.toJson());
    });
  }

  Future<void> deleteWord(Word word) async {
    await databaseReference.collection('words').document(word.id).delete();
  }
}
