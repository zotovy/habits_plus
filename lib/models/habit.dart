import 'package:cloud_firestore/cloud_firestore.dart';

class Habit {
  String title;
  String description;
  bool isDisable; // firstly - false
  DateTime startTime;
  DateTime endTime;
  int percentage;
  bool isTimeHasCome; // firstly - false
  bool isSuccessed; // firstly - false
  int colorCode; // more info on github
  List<bool> repeatDays;
  int timesADay;

  Habit({
    this.title,
    this.description,
    this.isDisable,
    this.startTime,
    this.endTime,
    this.percentage,
    this.isTimeHasCome,
    this.isSuccessed,
    this.colorCode,
    this.repeatDays,
    this.timesADay,
  });

  factory Habit.fromDoc(DocumentSnapshot doc) {
    // Implement repeat days
    String str = doc['repeatDays'];
    List<bool> repeatDays = [];
    for (var i = 0; i < str.length; i++) {
      repeatDays.add(str[i] == '1' ? true : false);
    }

    // Create habit
    return Habit(
      title: doc['title'],
      description: doc['description'],
      isDisable: doc['isDisable'],
      startTime: (doc['startTime'] as Timestamp).toDate(),
      endTime: (doc['endTime'] as Timestamp).toDate(),
      percentage: doc['percentage'],
      isTimeHasCome: doc['isTimeHasCome'],
      isSuccessed: doc['isSuccessed'],
      colorCode: doc['colorCode'],
      repeatDays: repeatDays,
      timesADay: doc['timesADay'],
    );
  }
}
