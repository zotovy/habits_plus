/// flutter:
///   fonts:
///    - family:  custom_icons
///      fonts:
///       - asset: assets/fonts/custom_icons.ttf
///
///
///
import 'package:flutter/widgets.dart';

class CustomIcons {
  CustomIcons._();

  static const _kFontFam = 'custom_icons';

  static const IconData edit = const IconData(
    0xe000,
    fontFamily: _kFontFam,
  );
}
