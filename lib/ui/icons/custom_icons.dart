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

  static const IconData instagram = const IconData(
    0xe000,
    fontFamily: _kFontFam,
  );
  static const IconData telegram = const IconData(
    0xe001,
    fontFamily: _kFontFam,
  );
  static const IconData facebook = const IconData(
    0xe002,
    fontFamily: _kFontFam,
  );
  static const IconData twitter = const IconData(
    0xe003,
    fontFamily: _kFontFam,
  );
  static const IconData vk = const IconData(
    0xe004,
    fontFamily: _kFontFam,
  );
  static const IconData edit = const IconData(
    0xe005,
    fontFamily: _kFontFam,
  );
  static const IconData send = const IconData(
    0xe006,
    fontFamily: _kFontFam,
  );
  static const IconData github = const IconData(
    0xe007,
    fontFamily: _kFontFam,
  );
}
