import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:habits_plus/localization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ImageSourcePicker extends StatelessWidget {
  Function(ImageSource) onTap;

  ImageSourcePicker({
    this.onTap,
  });

  List<IconData> icons = [];
  List<String> text = [];
  List<ImageSource> source = [];

  Widget _tile(BuildContext context, int i) {
    return GestureDetector(
      onTap: () {
        onTap(source[i]);
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: <Widget>[
            // Icon
            Icon(
              icons[i],
              color: Theme.of(context).primaryColor,
              size: 28,
            ),

            SizedBox(width: 10),

            // Text
            Text(
              text[i],
              style: TextStyle(
                color: Theme.of(context).textSelectionHandleColor,
                fontSize: 18,
              ),
            ),

            // Go
            Expanded(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).disabledColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Initialization
    icons = [MdiIcons.camera, EvaIcons.image];
    text = [
      AppLocalizations.of(context).translate('camera'),
      AppLocalizations.of(context).translate('gallery'),
    ];
    source = [ImageSource.camera, ImageSource.gallery];

    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Scaffold(
        body: Center(
          child: Container(
            width: 300,
            height: 106,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: List.generate(
                2,
                (int i) => _tile(context, i),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
