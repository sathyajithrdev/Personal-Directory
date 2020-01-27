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
    setHomeState(HomeState.ViewWordList);
  }

  @override
  void dispose() {
    _homeStateStreamController.close();
  }

  void setHomeState(HomeState state) {
    _homeStateStreamController.sink.add(new HomeStateData(homeState: state));
  }

  void setHomeStateAsPerCurrentState() {
    if (_homeStateStreamController.value.homeState == HomeState.AddNewWord) {
      setHomeState(HomeState.ViewWordList);
    } else {
      setHomeState(HomeState.AddNewWord);
    }
  }
}
