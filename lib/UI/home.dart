import 'package:flare_flutter/flare_cache.dart';
import 'package:flutter/material.dart';
import 'package:personal_dictionary/BLoC/home_state_bloc.dart';
import 'package:personal_dictionary/Common/cache_flare_animations.dart';
import 'package:personal_dictionary/Common/custom_colors.dart';
import 'package:personal_dictionary/Common/home_state.dart';
import 'package:personal_dictionary/Model/HomeStateData.dart';
import 'package:personal_dictionary/UI/save_word_view.dart';
import 'package:personal_dictionary/UI/words_list_view.dart';
import 'package:personal_dictionary/Widget/base_stateless_widget.dart';
import 'package:personal_dictionary/Widget/loading_view.dart';

class HomeScreen extends BaseStatelessWidget {
  final HomeStateBloc _bloc = new HomeStateBloc();

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    // Don't prune the Flare cache, keep loaded Flare files warm and ready
    // to be re-displayed.
    FlareCache.doesPrune = false;
    warmUpFlare();
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: StreamBuilder<HomeStateData>(
              stream: _bloc.homeStateStream,
              builder: (context, homeStateSnapshot) {
                HomeStateData homeStateData = homeStateSnapshot.data;
                if (homeStateData?.homeState == HomeState.Loading) {
                  return LoadingView(progressMessage: homeStateData.message);
                }

                if (homeStateData?.homeState == HomeState.AddNewWord) {
                  return SaveViewWord();
                }

                if (homeStateData?.homeState == HomeState.EditWord) {
                  return SaveViewWord();
                }

                return WordListView();
              }),
          color: CustomColors.blackBackground,
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
        onPressed: _addNewWordOrCloseFabClick,
      ),
    );
  }

  void _addNewWordOrCloseFabClick() {
    _bloc.setHomeStateAsPerCurrentState();
  }
}
