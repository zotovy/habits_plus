import 'dart:io';

import 'package:habits_plus/core/enums/internet.dart';

class InternetServices {
  /// Return true if device is connected to the Internet and false if not
  Future<bool> hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
  }

  /// Return InternetConnection.Connected if device is connected to the Internet
  /// and InternetConnection.NotConnected if not
  Future<InternetConnection> checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return InternetConnection.Connected;
      }
    } on SocketException catch (_) {
      return InternetConnection.NotConnected;
    }
  }
}
