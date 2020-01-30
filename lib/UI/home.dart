import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_cache.dart';
import 'package:flutter/material.dart';
import 'package:personal_dictionary/BLoC/home_state_bloc.dart';
import 'package:personal_dictionary/Common/cache_flare_animations.dart';
import 'package:personal_dictionary/Common/custom_colors.dart';
import 'package:personal_dictionary/Common/home_state.dart';
import 'package:personal_dictionary/Interface/IDictionaryEventListener.dart';
import 'package:personal_dictionary/Model/HomeStateData.dart';
import 'package:personal_dictionary/Model/word.dart';
import 'package:personal_dictionary/UI/save_word_view.dart';
import 'package:personal_dictionary/UI/words_list_view.dart';
import 'package:personal_dictionary/Widget/base_stateless_widget.dart';
import 'package:personal_dictionary/Widget/loading_view.dart';

class HomeScreen extends BaseStatelessWidget
    implements IDictionaryEventListener {
  final HomeStateBloc _bloc = new HomeStateBloc();
  Word wordToUpdate;

  @override
  Widget build(BuildContext context) {
    cacheFlareAnimationFiles();
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: StreamBuilder<HomeStateData>(
              stream: _bloc.homeStateStream,
              builder: (context, homeStateSnapshot) {
                HomeStateData homeStateData = homeStateSnapshot.data;
                return Stack(
                  children: <Widget>[
                    getHomeBodyAsPerState(homeStateData),
                    getLoadingView(homeStateData)
                  ],
                );
              }),
          color: CustomColors.blackBackground,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: StreamBuilder<HomeStateData>(
            stream: _bloc.homeStateStream,
            builder: (context, homeStateSnapshot) {
              HomeStateData homeStateData = homeStateSnapshot.data;
              String animation = "To Add";
              if (homeStateData?.homeState == HomeState.AddNewWord ||
                  homeStateData?.homeState == HomeState.EditWord) {
                animation = "To Close";
              }
              return Container(
                height: 60,
                width: 60,
                child: FlareActor("assets/animations/add_close.flr",
                    animation: animation, color: Colors.red),
              );
            }),
        onPressed: _addNewWordOrCloseFabClick,
      ),
    );
  }

  Widget getHomeBodyAsPerState(HomeStateData homeStateData) {
    if (homeStateData?.homeState == HomeState.AddNewWord) {
      return SaveViewWord(
        dictionaryEventListener: this,
        homeStateBloc: _bloc,
      );
    }

    if (homeStateData?.homeState == HomeState.EditWord) {
      return SaveViewWord(
          dictionaryEventListener: this,
          homeStateBloc: _bloc,
          wordToUpdate: wordToUpdate);
    }

    return WordListView(
      onWordListingCompleted: () {
        _bloc.setHomeState(HomeState.ViewWordList,"");
      },
      onUpdateWordClick: (word) {
        _bloc.setHomeState(HomeState.EditWord,"");
        wordToUpdate = word;
      },
    );
  }

  Widget getLoadingView(HomeStateData homeStateData) {
    return Visibility(
      visible: homeStateData?.homeState == HomeState.Loading,
      child: LoadingView(
          progressMessage:
              homeStateData?.message ?? "Loading words, please wait..."),
    );
  }

  void cacheFlareAnimationFiles() {
    WidgetsFlutterBinding.ensureInitialized();
    // Don't prune the Flare cache, keep loaded Flare files warm and ready
    // to be re-displayed.
    FlareCache.doesPrune = false;
    warmUpFlare();
  }

  void _addNewWordOrCloseFabClick() {
    _bloc.setHomeStateAsPerCurrentState();
  }

  @override
  onEventCompleted(DictionaryEvent event) {
    _bloc.setHomeState(HomeState.ViewWordList, "");
  }

  @override
  onEventError(DictionaryEvent event) {
    _bloc.setHomeState(HomeState.ViewWordList, "");
  }

  @override
  onEventStart(DictionaryEvent event) {
    _bloc.setHomeState(HomeState.Loading, getProgressMessage(event));
  }

  String getProgressMessage(DictionaryEvent event) {
    switch (event) {
      case DictionaryEvent.AddNewWord:
        return "Adding new word, please wait..";
      case DictionaryEvent.UpdateWord:
        return "Updating word, please wait..";
      case DictionaryEvent.FetchingWord:
        return "Loading words, please wait..";
      case DictionaryEvent.DeleteWord:
        return "Deleting word, please wait..";
        break;
    }
    return "Loading, please wait...";
  }
}
