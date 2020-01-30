abstract class IDictionaryEventListener {
  onEventStart(DictionaryEvent event);
  onEventCompleted(DictionaryEvent event);
  onEventError(DictionaryEvent event);
}


enum DictionaryEvent { AddNewWord, UpdateWord, FetchingWord, DeleteWord  }
