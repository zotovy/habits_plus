import 'dart:io';

import 'package:flutter/material.dart';
import 'package:habits_plus/core/enums/viewstate.dart';
import 'package:habits_plus/core/models/habit.dart';
import 'package:habits_plus/core/models/userData.dart';
import 'package:habits_plus/core/util/constant.dart';
import 'package:habits_plus/core/viewmodels/detail_model.dart';
import 'package:habits_plus/localization.dart';
import 'package:habits_plus/ui/view/loading.dart';
import 'package:habits_plus/ui/widgets/detailPage/appbar.dart';
import 'package:habits_plus/ui/widgets/detailPage/bottomSheet.dart';
import 'package:habits_plus/ui/widgets/detailPage/calendar.dart';
import 'package:habits_plus/ui/widgets/detailPage/commentTile.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../locator.dart';

class DetailHabitPage extends StatefulWidget {
  Habit habit;
  DetailHabitPage(this.habit);

  @override
  _DetailHabitPageState createState() => _DetailHabitPageState();
}

class _DetailHabitPageState extends State<DetailHabitPage> {
  DetailPageView _model = locator<DetailPageView>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    String userId = Provider.of<UserData>(context, listen: false).currentUserId;

    _model.initHabit(widget.habit);
    _model.fetchComments(userId);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _model,
      child: Consumer(
        builder: (_, DetailPageView model, child) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              key: _scaffoldKey,
              backgroundColor: Theme.of(context).backgroundColor,
              appBar: DetailAppBar(model),
              body: model.state == ViewState.Busy
                  ? LoadingPage()
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                              CalendarDetailWidget(model.habit.progressBin),

                              // Comments
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      AppLocalizations.of(context)
                                          .translate('comments')
                                          .toString()
                                          .toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Theme.of(context)
                                            .textSelectionColor
                                            .withOpacity(0.75),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: () => showModalBottomSheet(
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (_) => DetailPageBottomPage(
                                          saveContent: (String value) {
                                            model.newCommentValue = value;
                                          },
                                          saveImage: (File image) {
                                            model.commentImage = image;
                                          },
                                          onConfirm: () {
                                            String userId =
                                                Provider.of<UserData>(context,
                                                        listen: false)
                                                    .currentUserId;
                                            model.createComment(userId);
                                            model.commentImage = null;
                                          },
                                          image: model.commentImage,
                                          onImageDelete: () =>
                                              model.commentImage = null,
                                          pickImage: () async {
                                            File _image =
                                                await ImagePicker.pickImage(
                                              source: ImageSource.gallery,
                                            );

                                            if (_image != null) {
                                              model.commentImage =
                                                  await ImageCropper.cropImage(
                                                sourcePath: _image.path,
                                                aspectRatioPresets: [
                                                  CropAspectRatioPreset.square,
                                                  CropAspectRatioPreset
                                                      .ratio3x2,
                                                  CropAspectRatioPreset
                                                      .original,
                                                  CropAspectRatioPreset
                                                      .ratio4x3,
                                                  CropAspectRatioPreset
                                                      .ratio16x9
                                                ],
                                                androidUiSettings:
                                                    AndroidUiSettings(
                                                  toolbarTitle: 'Cropper',
                                                  toolbarColor:
                                                      Colors.deepOrange,
                                                  toolbarWidgetColor:
                                                      Colors.white,
                                                  initAspectRatio:
                                                      CropAspectRatioPreset
                                                          .original,
                                                  lockAspectRatio: false,
                                                ),
                                                iosUiSettings: IOSUiSettings(
                                                  minimumAspectRatio: 1.0,
                                                ),
                                              );
                                            }
                                            return model.commentImage;
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ] +
                            List.generate(
                              model.comments.length,
                              (int i) {
                                return CommentTile(model.comments[i]);
                              },
                            ) +
                            [],
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
