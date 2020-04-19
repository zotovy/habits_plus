class HabitNotification {
  String habitId;
  int notificationId;
  String title;
  String description;
  DateTime date;

  HabitNotification({
    this.habitId,
    this.title,
    this.description,
    this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'habitId': habitId,
      'notificationId': notificationId,
      'title': title,
      'description': description,
      'date': date.toString(),
    };
  }

  factory HabitNotification.fromJson(Map<String, dynamic> json) {
    return HabitNotification(
      habitId: json['habitId'],
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date']),
    );
  }
}
