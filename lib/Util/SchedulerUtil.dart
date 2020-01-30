import 'package:workmanager/workmanager.dart';

class SchedulerUtil {
  static const String WordOfTheDayTask = "wordOfTheDay";
  static const String WordOfTheDayTaskId = "1001";

  static Future schedulePeriodicTask(final String taskId, final String taskName,
      final Function callbackDispatcher, final Duration frequency) async {
    await Workmanager.initialize(
        callbackDispatcher, // The top level function, aka callbackDispatcher
        isInDebugMode:
            true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
        );
    Workmanager.registerPeriodicTask(taskId, taskName, frequency: frequency);
  }
}
