import 'dart:io';

import 'package:habits_plus/core/enums/viewstate.dart';
import 'package:habits_plus/core/models/comment.dart';
import 'package:habits_plus/core/models/habit.dart';
import 'package:habits_plus/core/services/database.dart';
import 'package:habits_plus/core/services/storage.dart';
import 'package:habits_plus/core/viewmodels/base_model.dart';
import 'package:habits_plus/core/viewmodels/home_model.dart';
import 'package:uuid/uuid.dart';

import '../../locator.dart';

class DetailPageView extends BaseViewModel {
  DatabaseServices _databaseServices = locator<DatabaseServices>();
  StorageServices _storageServices = locator<StorageServices>();

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

    // Upload image
    String _imagePath;
    if (_commentImage != null) {
      _imagePath = await _storageServices.uploadCommentImage(_commentImage);
    }

    // Create comment & uplod him
    Comment _comment = Comment(
      authorId: userId,
      content: _commentContent,
      habitId: _habit.id,
      hasImage: _imagePath == null ? false : true,
      id: _id,
      imageUrl: _imagePath == null ? '' : _imagePath,
      timestamp: DateTime.now(),
    );
    setCommentState(ViewState.Busy);
    bool dbcode = await _databaseServices.saveComment(_comment);
    _comments.add(_comment);
    setCommentState(ViewState.Idle);

    return dbcode;
  }

  void initHabit(Habit habit) {
    _habit = habit;
    notifyListeners();
  }
}
