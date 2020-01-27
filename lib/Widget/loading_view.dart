import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_dictionary/Common/custom_styles.dart';

class LoadingView extends StatelessWidget {
  final String progressMessage;

  LoadingView({this.progressMessage = "Loading, please wait..."});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Container(
            height: 200,
            width: 200,
            child: FlareActor("assets/animations/analysis.flr",
                animation: "analysis", color: Colors.red),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              progressMessage,
              style: CustomTextStyles.mediumTextStyle(),
            ),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }
}
