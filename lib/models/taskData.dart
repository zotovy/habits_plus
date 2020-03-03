import 'package:flutter/foundation.dart';
import 'package:habits_plus/models/task.dart';

class TaskData extends ChangeNotifier {
  List<Task> tasks;
  List<Task> doneTasks = [];
  List<Task> notDoneTasks = [];
}
