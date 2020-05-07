import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:habits_plus/core/models/userData.dart';
import 'package:habits_plus/core/services/firebase.dart';
import 'package:habits_plus/core/services/internet.dart';
import 'package:habits_plus/core/services/logs.dart';
import 'package:habits_plus/core/util/logger.dart';
import 'package:habits_plus/locator.dart';
import 'package:provider/provider.dart';

class BugModel {
  String name;
  String desc;
  List<String> log;
  DateTime date;
  String userId;
  List<String> deviceInfo;

  BugModel({
    this.name,
    this.desc,
    this.log,
    this.date,
    this.userId,
    this.deviceInfo,
  });

  Map<String, dynamic> toDocument() {
    return {
      'name': name,
      'desc': desc,
      'log': log,
      'date': Timestamp.fromDate(date),
      'userId': userId,
      'deviceInfo': deviceInfo,
    };
  }
}

class MessageModel {
  String name;
  String email;
  String message;
  String userId;

  Map<String, dynamic> toDocument() {
    return {
      'name': name,
      'email': email,
      'message': message,
      'userId': userId,
    };
  }

  MessageModel({
    this.name,
    this.email,
    this.message,
    this.userId,
  });
}

class CommunityServices {
  FirebaseServices _firebaseServices = locator<FirebaseServices>();
  InternetServices _internetConnection = locator<InternetServices>();
  LogServices _logServices = locator<LogServices>();
  DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  /// This function report bug on firebase.
  /// Return true if success and false if not
  Future<bool> reportBug(BuildContext context, String name, String desc) async {
    try {
      // Check InternetConnection
      if (!await _internetConnection.hasInternetConnection()) return false;

      // Get log
      List<String> log = _logServices.log;

      // get device info
      List<String> deviceInfo = [];

      if (Platform.isAndroid) {
        AndroidDeviceInfo info = await _deviceInfo.androidInfo;
        deviceInfo.add('Platform: Android');
        deviceInfo.add('Device: ${info.device}');
        deviceInfo.add('Brand: ${info.brand}');
        deviceInfo.add('Display: ${info.display}');
        deviceInfo.add('Model: ${info.model}');
      } else if (Platform.isIOS) {
        IosDeviceInfo info = await _deviceInfo.iosInfo;
        deviceInfo.add('Platform: IOS');
        deviceInfo.add('Name: ${info.name}');
        deviceInfo.add('System version: ${info.systemVersion}');
        deviceInfo.add('UTS name: ${info.utsname}');
      }

      // Make bug model
      BugModel bug = BugModel(
        desc: desc,
        log: log,
        name: name,
        deviceInfo: deviceInfo,
        date: DateTime.now(),
        userId: Provider.of<UserData>(context, listen: false).currentUserId,
      );

      // save data
      bool code = await _firebaseServices.reportBug(bug);

      _logServices.addLog('report bug (dbcode=$code) (CommunityServices)');

      return code;
    } catch (e) {
      logger.e('Error while report bug', e);
      _logServices.addLog('Error while report bug $e');
      return false;
    }
  }

  Future<bool> sendMessage(
    BuildContext context,
    String name,
    String email,
    String message,
  ) async {
    try {
      // Check InternetConnection
      if (!await _internetConnection.hasInternetConnection()) return false;

      // make model
      MessageModel model = MessageModel(
        email: email,
        message: message,
        name: name,
        userId: Provider.of<UserData>(context, listen: false).currentUserId,
      );

      // save data
      bool code = await _firebaseServices.sendMessage(model);

      return code;
    } catch (e) {
      logger.e('Error while send message', e);
      _logServices.addLog('Error while send message. $e');
      return false; // return false
    }
  }
}
