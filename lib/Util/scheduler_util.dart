import 'package:workmanager/workmanager.dart';

import '../main.dart';

class SchedulerUtil {
  static const String WordOfTheDayTask = "wordOfTheDay";
  static const String WordOfTheDayTaskId = "1001";

  Future scheduleOneOffTask(final String taskId, final String taskName,
      final Duration frequency) async {
    await Workmanager.initialize(
        callbackDispatcher, // The top level function, aka callbackDispatcher
        isInDebugMode:
            true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
        );
    await Workmanager.registerOneOffTask(taskId, taskName,
        initialDelay: frequency);
  }
}
