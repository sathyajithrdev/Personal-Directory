import 'dart:async';

import 'package:personal_dictionary/BLoC/bloc.dart';
import 'package:personal_dictionary/Common/home_state.dart';
import 'package:personal_dictionary/Model/HomeStateData.dart';
import 'package:rxdart/rxdart.dart';

class HomeStateBloc extends Bloc {
  final _homeStateStreamController = new BehaviorSubject<HomeStateData>();

  Stream<HomeStateData> get homeStateStream =>
      _homeStateStreamController.stream;

  HomeStateBloc() {
    setHomeState(HomeState.ViewWordList, "Loading words, please wait...");
  }

  @override
  void dispose() {
    _homeStateStreamController.close();
  }

  void setHomeState(HomeState state, String message) {
    _homeStateStreamController.sink
        .add(new HomeStateData(homeState: state, message: message));
  }

  void setHomeStateAsPerCurrentState() {
    if (_homeStateStreamController.value.homeState == HomeState.AddNewWord ||
        _homeStateStreamController.value.homeState == HomeState.EditWord) {
      setHomeState(HomeState.ViewWordList, "Loading words, please wait...");
    } else {
      setHomeState(HomeState.AddNewWord, "");
    }
  }
}
