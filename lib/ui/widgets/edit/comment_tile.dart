import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habits_plus/core/models/comment.dart';
import 'package:habits_plus/core/services/images.dart';
import 'package:habits_plus/core/util/constant.dart';
import 'package:habits_plus/localization.dart';
import 'package:habits_plus/ui/icons/custom_icons.dart';
import 'package:habits_plus/ui/widgets/edit/bottom_dialog.dart';
import 'package:habits_plus/ui/widgets/edit/delete_dialog.dart';

import '../../../locator.dart';

class CommentTile extends StatefulWidget {
  Comment comment;
  Function(Comment comment) onCommentChange;
  Function onDelete;

  CommentTile({
    @required this.comment,
    @required this.onCommentChange,
    @required this.onDelete,
  });

  @override
  _CommentTileState createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  /// This function return formatted string
  String formateDate() {
    bool isToday = dateFormater.parse(DateTime.now().toString()) ==
        dateFormater.parse(widget.comment.timestamp.toString());

    String hour, minutes, date;

    // format hour
    if (widget.comment.timestamp.hour < 10) {
      hour = '0' + widget.comment.timestamp.hour.toString();
    } else {
      hour = widget.comment.timestamp.hour.toString();
    }

    // format minutes
    if (widget.comment.timestamp.minute < 10) {
      minutes = '0' + widget.comment.timestamp.minute.toString();
    } else {
      minutes = widget.comment.timestamp.minute.toString();
    }

    if (!isToday) {
      String _month = AppLocalizations.of(context).translate(
        monthNames[widget.comment.timestamp.month] + '_',
      );
      date = '${widget.comment.timestamp.day} $_month ';
    } else {
      date = '';
    }

    return '$date$hour:$minutes';
  }

  /// This func call when user pressed edit icon
  void onEdit() {
    showModalBottomSheet(
      context: context,
      builder: (_) => EditCommentDialog(
        initialComment: widget.comment.content,
        initialImage: widget.comment.imageBase64String,
        onConfirm: (String content, String base64String) {
          setState(() {
            widget.comment.content = content;
            widget.comment.imageBase64String = base64String;
            widget.comment.hasImage =
                base64String != null && base64String != '';
          });
          widget.onCommentChange(widget.comment);
        },
      ),
    );
  }

  /// This func call when user press on delete icon
  void onDelete() {
    showDialog(
      context: context,
      builder: (_) => DeleteDialog(),
    );
  }

  Widget _buildToolTip() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          // Edit
          GestureDetector(
            onTap: onEdit,
            child: Icon(
              CustomIcons.edit,
              color: Theme.of(context).textSelectionColor.withOpacity(0.75),
              size: 16,
            ),
          ),
          SizedBox(width: 5),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => DeleteDialog(
                  onYes: () => widget.onDelete(),
                ),
              );
            },
            child: Icon(
              EvaIcons.close,
              color: Colors.redAccent,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildImgPreview() {
    return widget.comment.hasImage
        ? Padding(
            padding: EdgeInsets.only(right: 10),
            child: InkWell(
              onTap: () => Navigator.pushNamed(
                context,
                'image_preview',
                arguments: [
                  widget.comment.imageBase64String,
                  widget.comment.id
                ],
              ),
              child: Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 1),
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.transparent
                          : Colors.white10,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Hero(
                  tag: widget.comment.id,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).disabledColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: locator<ImageServices>().imageFromBase64String(
                      widget.comment.imageBase64String,
                      fit: BoxFit.cover,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
          )
        : SizedBox.shrink();
  }

  Widget _buildContent() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            widget.comment.content,
            style: TextStyle(
              color: Theme.of(context).textSelectionHandleColor,
              fontSize: 16,
            ),
          ),
          Text(
            formateDate(),
            style: TextStyle(
              color: Theme.of(context).textSelectionColor.withOpacity(0.5),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
      // padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    _buildImgPreview(),
                    _buildContent(),
                  ],
                ),
              ),
              _buildToolTip(),
            ],
          ),
        ),
      ),
    );
  }
}
