import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AppSettings {
  bool isDarkMode;
  bool isUserLogin;
  bool isNotifications;
  String pinCode;
  bool hasPinCode;
  Locale locale;
  bool isSync;

  AppSettings({
    this.isDarkMode,
    this.isUserLogin,
    this.isNotifications,
    this.pinCode,
    this.hasPinCode,
    this.locale,
    this.isSync,
  });

  Map<String, dynamic> toDocument() {
    return {
      'isDarkMode': isDarkMode,
      'isUserLogin': isUserLogin,
      'isNotifications': isNotifications,
      'pinCode': pinCode,
      'hasPinCode': hasPinCode,
      'locale': locale.countryCode,
      'isSync': isSync,
    };
  }

  factory AppSettings.fromDocument(DocumentSnapshot snapshot) {
    return AppSettings(
      isDarkMode: snapshot.data['isDarkMode'] == null
          ? false
          : snapshot.data['isDarkMode'],
      isUserLogin: snapshot.data['isUserLogin'] == null
          ? false
          : snapshot.data['isUserLogin'],
      isNotifications: snapshot.data['isNotifications'] == null
          ? false
          : snapshot.data['isNotifications'],
      pinCode:
          snapshot.data['pinCode'] == null ? false : snapshot.data['pinCode'],
      hasPinCode: snapshot.data['hasPinCode'] == null
          ? false
          : snapshot.data['hasPinCode'],
      locale: snapshot.data['locale'] == null
          ? Locale('en', 'EN')
          : Locale(
              snapshot.data['locale'],
              snapshot.data['locale'].toUpperCase(),
            ),
      isSync: snapshot.data['isSync'] == null ? false : snapshot.data['isSync'],
    );
  }
}
