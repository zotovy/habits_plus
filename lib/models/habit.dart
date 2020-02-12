import 'package:cloud_firestore/cloud_firestore.dart';

class Habit {
  String title;
  String description;
  int amount; // 0 is no amount type
  bool isDisable; // firstly - false
  DateTime timeStamp;
  int percentage;
  bool isSuccessed; // firstly - false
  int colorCode; // more info on github
  List<bool> repeatDays;
  int timesADay;

  Habit({
    this.title,
    this.description,
    this.amount,
    this.isDisable,
    this.timeStamp,
    this.percentage,
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
      amount: doc['amount'],
      isDisable: doc['isDisable'],
      timeStamp: (doc['timeStamp'] as Timestamp).toDate(),
      percentage: doc['percentage'],
      isSuccessed: doc['isSuccessed'],
      colorCode: doc['colorCode'],
      repeatDays: repeatDays,
      timesADay: doc['timesADay'],
    );
  }
}
