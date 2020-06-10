import 'package:habits_plus/core/enums/sync_type.dart';
import 'package:habits_plus/core/models/app_settings.dart';
import 'package:habits_plus/core/models/comment.dart';
import 'package:habits_plus/core/models/habit.dart';
import 'package:habits_plus/core/models/task.dart';
import 'package:habits_plus/core/models/user.dart';

class SyncModel {
  SyncType type;
  Map<String, dynamic> data;

  SyncModel({
    this.type,
    this.data,
  });

  Map<String, dynamic> toJson() {
    var _data;
    if (type == SyncType.CreateHabit ||
        type == SyncType.DeleteHabit ||
        type == SyncType.UpdateHabit) {
      _data = data['habit'].toJson();
    } else if (type == SyncType.CreateTask ||
        type == SyncType.UpdateTask ||
        type == SyncType.DeleteTask) {
      _data = data['task'].toJson();
    } else if (type == SyncType.CreateComment ||
        type == SyncType.UpdateComment ||
        type == SyncType.DeleteComment) {
      _data = data['comment'].toJson();
    } else if (type == SyncType.UpdateUser) {
      _data = data['user'].toJson();
    }

    return {
      'type': type.toString(),
      'data': data,
    };
  }

  factory SyncModel.fromJson(Map<String, dynamic> json) {
    // Convert _type String --> SyncType
    SyncType _type;
    switch (json['type']) {
      case 'SyncType.CreateHabit':
        _type = SyncType.CreateHabit;
        break;
      case 'SyncType.UpdateHabit':
        _type = SyncType.UpdateHabit;
        break;
      case 'SyncType.DeleteHabit':
        _type = SyncType.DeleteHabit;
        break;
      case 'SyncType.CreateTask':
        _type = SyncType.CreateTask;
        break;
      case 'SyncType.UpdateTask':
        _type = SyncType.UpdateTask;
        break;
      case 'SyncType.DeleteTask':
        _type = SyncType.DeleteTask;
        break;
      case 'SyncType.CreateComment':
        _type = SyncType.CreateComment;
        break;
      case 'SyncType.UpdateComment':
        _type = SyncType.UpdateComment;
        break;
      case 'SyncType.DeleteComment':
        _type = SyncType.DeleteComment;
        break;
      case 'SyncType.UpdateUser':
        _type = SyncType.UpdateUser;
        break;
    }

    // Convert data
    Map<String, dynamic> _data;
    if (_type == SyncType.CreateHabit ||
        _type == SyncType.DeleteHabit ||
        _type == SyncType.UpdateHabit) {
      _data = {
        'habit': Habit.fromJson(json['habit']),
      };
    } else if (_type == SyncType.CreateTask ||
        _type == SyncType.UpdateTask ||
        _type == SyncType.DeleteTask) {
      _data = {
        'task': Task.fromJson(json['task']),
      };
    } else if (_type == SyncType.CreateComment ||
        _type == SyncType.UpdateComment ||
        _type == SyncType.DeleteComment) {
      _data = {
        'comment': Comment.fromJson(json['comment']),
      };
    } else if (_type == SyncType.UpdateUser) {
      _data = {
        'user': User.fromJson(json['user']),
      };
    }

    return SyncModel(
      data: _data,
      type: _type,
    );
  }
}
