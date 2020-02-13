import 'dart:math';

import 'package:flutter/material.dart';
import 'package:personal_dictionary/UI/home.dart';
import 'package:workmanager/workmanager.dart';

import 'Model/word.dart';
import 'Repository/dictionary_repository.dart';
import 'Util/SharedPreferenceUtil.dart';
import 'Util/notification_util.dart';
import 'Util/scheduler_util.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    _registerTipOfTheDayTaskIfRequired();
    return MaterialApp(
      title: 'My Dictionary',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          bottomNavigationBar: new Material(
            color: Colors.black38,
            child: TabBar(
              tabs: [
                Tab(
                    icon: Icon(
                  Icons.home,
                  color: Colors.white,
                )),
                Tab(
                    icon: Icon(
                  Icons.settings,
                  color: Colors.white,
                )),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              HomeScreen(),
              Icon(Icons.settings),
            ],
          ),
        ),
      ),
    );
  }

  void _registerTipOfTheDayTaskIfRequired() async {
    bool isScheduled = await SharedPreferenceUtil.getBool(
        SharedPreferenceUtil.prefKeyIsWordOfTheDayScheduled);
//    if (!isScheduled) {
      await SchedulerUtil().scheduleOneOffTask(
          SchedulerUtil.WordOfTheDayTaskId,
          SchedulerUtil.WordOfTheDayTask,
          Duration(minutes: 1));
      debugPrint("Scheduled sendWordOfTheDayLocalNotification");
      SharedPreferenceUtil.setBool(
          SharedPreferenceUtil.prefKeyIsWordOfTheDayScheduled, true);
//      await AndroidAlarmManager.initialize();
//      await AndroidAlarmManager.periodic(
//          const Duration(minutes: 1), 1001, sendWordOfTheDayLocalNotification);
    }
//  }
}

void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) {
    return sendWordOfTheDayLocalNotification();
  });
}

Future<bool> sendWordOfTheDayLocalNotification() async {
  debugPrint("sendWordOfTheDayLocalNotification called");
  List<Word> words = await new DictionaryRepository().getAllWords();

  if (words.length > 0) {
    debugPrint("Words found to notify");
    var randomIndex = new Random().nextInt(words.length - 1);
    if (randomIndex < 0 || randomIndex >= words.length) {
      randomIndex = 0;
    }
    var word = words[randomIndex];
    var body = "${word.word} : ${word.meaning}";
    debugPrint("WOD is: $body");
    await NotificationUtil.sendWordOfTheDayLocalNotification(randomIndex, body);
  } else {
    debugPrint("No words found to notify");
  }

  await SchedulerUtil().scheduleOneOffTask(
      SchedulerUtil.WordOfTheDayTaskId,
      SchedulerUtil.WordOfTheDayTask,
      Duration(minutes: 15));

  return Future.value(false);
}
