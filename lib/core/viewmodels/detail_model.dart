import 'dart:io';

import 'package:habits_plus/core/enums/viewstate.dart';
import 'package:habits_plus/core/models/comment.dart';
import 'package:habits_plus/core/models/habit.dart';
import 'package:habits_plus/core/services/database.dart';
import 'package:habits_plus/core/services/images.dart';
import 'package:habits_plus/core/viewmodels/base_model.dart';
import 'package:uuid/uuid.dart';

import '../../locator.dart';

class DetailPageView extends BaseViewModel {
  DatabaseServices _databaseServices = locator<DatabaseServices>();

  Habit _habit;
  List<Comment> _comments = [];

  // Comments
  ViewState _commentState = ViewState.Idle;
  String _commentContent = '';
  File _commentImage;

  String get newCommentValue => _commentContent;
  File get commentImage => _commentImage;
  Habit get habit => _habit;

  List<Comment> get comments => _comments;
  set newCommentValue(String newValue) => _commentContent = newValue;
  set commentImage(File image) {
    _commentImage = image;
    notifyListeners();
  }

  set habit(Habit habit) {
    _habit = habit;
    notifyListeners();
  }

  void setCommentState(ViewState _state) {
    _commentState = _state;
    notifyListeners();
  }

  void fetchComments(String userId) async {
    setState(ViewState.Busy);
    _comments = (await _databaseServices.getCommentsByHabitId(_habit.id))
        .cast<Comment>();
    setState(ViewState.Idle);
  }

  Future createComment(String userId) async {
    String _id = Uuid().v4();

    // Get path
    String _imagePath;
    if (_commentImage != null) {
      _imagePath = locator<ImageServices>().base64String(
        _commentImage.readAsBytesSync(),
      );
    }

    // Create comment & uplod him
    Comment _comment = Comment(
      authorId: userId,
      content: _commentContent,
      habitId: _habit.id,
      hasImage: _imagePath == null ? false : true,
      id: _id,
      imageBase64String: _imagePath == null ? '' : _imagePath,
      timestamp: DateTime.now(),
    );
    setCommentState(ViewState.Busy);
    bool dbcode = await _databaseServices.saveComment(_comment);
    _comments.add(_comment);
    habit.comments.add(_comment);
    setCommentState(ViewState.Idle);

    return dbcode;
  }

  void initHabit(Habit habit) {
    _habit = habit;
    notifyListeners();
  }
}
