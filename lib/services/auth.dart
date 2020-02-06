import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habits_plus/localization.dart';
import 'package:habits_plus/models/user.dart';
import 'package:habits_plus/models/userData.dart';
import 'package:habits_plus/services/database.dart';
import 'package:habits_plus/ui/home.dart';

import 'package:provider/provider.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;
  static final _firestore = Firestore.instance;

  static dynamic signUpUser(
    BuildContext context,
    String email,
    String _username,
    String password,
    GlobalKey<ScaffoldState> scaffoldKey,
  ) async {
    try {
      // Unique username check
      bool isUsernameExists = await DatabaseServices.isUsernameUsed(_username);

      if (isUsernameExists) {
        scaffoldKey.currentState.showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.redAccent,
            elevation: 0,
            content: Container(
              height: 25,
              child: Center(
                child: Text(
                  AppLocalizations.of(context)
                      .translate('error_username_already_exists'),
                ),
              ),
            ),
          ),
        );
        return null;
      }

      // Register user in Firebase Auth system
      AuthResult authResult = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Register user in Firebase storage system
      FirebaseUser signedInUser = authResult.user;
      if (signedInUser != null) {
        _firestore.collection('/users').document(signedInUser.uid).setData({
          'email': email,
          'profileImageUrl': '',
          'username': _username,
        });
        Provider.of<UserData>(context, listen: false).currentUserId =
            signedInUser.uid;

        User user =
            User.fromDoc(await DatabaseServices.getUserById(signedInUser.uid));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => HomePage(),
          ),
        );
      }
    } catch (error) {
      bool isReceptive = true;
      String message = '';

      // Check receptive errors
      if (error.message == 'The email address is badly formatted.') {
        message =
            AppLocalizations.of(context).translate('error_email_bad_formated');
      } else if (error.message ==
          'The email address is already in use by another account.') {
        message = AppLocalizations.of(context)
            .translate('error_email_already_exists');
      } else {
        isReceptive = false;
      }

      if (isReceptive) {
        scaffoldKey.currentState.showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.redAccent,
            elevation: 0,
            content: Container(
              height: 25,
              child: Center(
                child: Text(message),
              ),
            ),
          ),
        );
        print(
            'Failed to signup: $email with $password \nTime: ${DateTime.now()}');
      } else {
        scaffoldKey.currentState.showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.redAccent,
            elevation: 0,
            content: Container(
              height: 25,
              child: Center(
                child: Text('Invald error happend. Please, try later'),
              ),
            ),
          ),
        );
        print(
            'Signup error: ${error.message} \nTime:${DateTime.now()}\nVariables: \n   email: $email\n   password:$password');
      }
    }
  }

  static void logout() {
    _auth.signOut();
  }

  static void login(
    String email,
    String password,
    GlobalKey<ScaffoldState> scaffoldKey,
    BuildContext context,
  ) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      var getResult = await DatabaseServices.getUserById(result.user.uid);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => HomePage(),
        ),
      );
    } catch (e) {
      bool isReceptive = true;
      String message = '';
      if (e.message ==
          'There is no user record corresponding to this identifier. The user may have been deleted.') {
        message =
            AppLocalizations.of(context).translate('error_incorrect_password');
      } else if (e.message == 'The email address is badly formatted.') {
        message =
            AppLocalizations.of(context).translate('error_email_bad_formated');
      } else {
        message = e.message;
        isReceptive = false;
      }

      if (isReceptive) {
        scaffoldKey.currentState.showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.redAccent,
            elevation: 0,
            content: Container(
              height: 25,
              child: Center(
                child: Text(message),
              ),
            ),
          ),
        );
        print(
            'Failed to login: $email with $password \nTime: ${DateTime.now()}');
      } else {
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.redAccent,
          elevation: 0,
          content: Container(
            height: 25,
            child: Center(
              child: Text('Invald error happend. Please, try later'),
            ),
          ),
        );
        print(
            'Login error: $message \nTime:${DateTime.now()}\nVariables: \n   email: $email\n   password:$password');
      }
    }
  }
}
