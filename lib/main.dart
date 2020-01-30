import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:personal_dictionary/BLoC/dictionary_bloc.dart';
import 'package:personal_dictionary/UI/home.dart';
import 'package:workmanager/workmanager.dart';

import 'Model/word.dart';
import 'Util/SchedulerUtil.dart';
import 'Util/SharedPreferenceUtil.dart';

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
          length: 3,
          child: Scaffold(
            bottomNavigationBar: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.directions_car)),
                Tab(icon: Icon(Icons.directions_transit)),
                Tab(icon: Icon(Icons.directions_bike)),
              ],
            ),
            body: TabBarView(
              children: [
                HomeScreen(),
                Icon(Icons.directions_transit),
                Icon(Icons.directions_bike),
              ],
            ),
          ),
        ));
  }

  void _registerTipOfTheDayTaskIfRequired() async {
    bool isScheduled = await SharedPreferenceUtil.getBool(
        SharedPreferenceUtil.prefKeyIsWordOfTheDayScheduled);
    if (!isScheduled) {
      await SchedulerUtil.schedulePeriodicTask(
          SchedulerUtil.WordOfTheDayTaskId,
          SchedulerUtil.WordOfTheDayTask,
          _showNotificationWithDefaultSound,
          Duration(minutes: 15));
      SharedPreferenceUtil.setBool(
          SharedPreferenceUtil.prefKeyIsWordOfTheDayScheduled, true);
    }
  }

  void _showNotificationWithDefaultSound() {
    Workmanager.executeTask((task, inputData) async {
      DictionaryBloc dictionaryBloc = new DictionaryBloc();
      List<Word> words = await dictionaryBloc.getAllWords();

      if (words.length > 0) {
        var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
            '2001', 'Word of the day', 'To show word of the day notification',
            importance: Importance.Max, priority: Priority.High);
        var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
        var platformChannelSpecifics = new NotificationDetails(
            androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

        var randomIndex = new Random().nextInt(words.length - 1);
        var word = words[randomIndex];
        var body = "${word.word} : ${word.meaning}";

        FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
            new FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
        var initializationSettingsAndroid =
            new AndroidInitializationSettings('@mipmap/ic_launcher');
        var initializationSettingsIOS = IOSInitializationSettings(
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);
        var initializationSettings = InitializationSettings(
            initializationSettingsAndroid, initializationSettingsIOS);
        flutterLocalNotificationsPlugin.initialize(initializationSettings,
            onSelectNotification: onSelectNotification);

        await flutterLocalNotificationsPlugin.show(
          randomIndex,
          'Word of the day',
          body,
          platformChannelSpecifics,
          payload: 'Default_Sound',
        );
      }
      return Future.value(true);
    });
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
  }
}
