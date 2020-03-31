import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:habits_plus/core/models/comment.dart';
import 'package:habits_plus/core/util/constant.dart';
import 'package:habits_plus/localization.dart';

class CommentTile extends StatefulWidget {
  Comment comment;
  CommentTile(this.comment);

  @override
  _CommentTileState createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  Widget _buildImgPreview() {
    return widget.comment.hasImage
        ? Padding(
            padding: EdgeInsets.only(right: 10),
            child: InkWell(
              onTap: () => Navigator.pushNamed(context, 'image_preview',
                  arguments: [widget.comment.imageUrl, widget.comment.id]),
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
                      image: DecorationImage(
                        image:
                            CachedNetworkImageProvider(widget.comment.imageUrl),
                        fit: BoxFit.cover,
                      ),
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
    String date = '';

    if (dateFormater.parse(DateTime.now().toString()) ==
        dateFormater.parse(widget.comment.timestamp.toString())) {
      date =
          '${widget.comment.timestamp.hour}:${widget.comment.timestamp.minute < 10 ? '0' + widget.comment.timestamp.minute.toString() : widget.comment.timestamp.minute}';
    } else {
      date =
          '${widget.comment.timestamp.day} ${AppLocalizations.of(context).translate(monthNames[widget.comment.timestamp.month] + '_')} ${widget.comment.timestamp.hour}:${widget.comment.timestamp.minute < 10 ? '0' + widget.comment.timestamp.minute.toString() : widget.comment.timestamp.minute}';
    }

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
            date,
            style: TextStyle(
              color: Theme.of(context).disabledColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTime() {
    String date = DateTime.now().day == widget.comment.timestamp.day
        ? ''
        : widget.comment.timestamp.day.toString() +
            AppLocalizations.of(context).translate(
              monthNames[widget.comment.timestamp.month] + '_',
            );

    return Text(
      date,
      style: TextStyle(
        fontSize: 14,
        color: Theme.of(context).textSelectionColor,
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
              _buildContent(),
              _buildImgPreview(),
            ],
          ),
        ),
      ),
    );
  }
}
