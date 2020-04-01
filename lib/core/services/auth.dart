import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:habits_plus/core/viewmodels/home_model.dart';
import 'package:habits_plus/localization.dart';
import 'package:habits_plus/core/models/user.dart';
import 'package:habits_plus/core/models/userData.dart';
import 'package:habits_plus/core/services/database.dart';
import 'package:habits_plus/ui/view/home.dart';
import 'package:habits_plus/ui/view/signup.dart';
import 'package:habits_plus/core/util/constant.dart';
import 'package:http/http.dart' as http;

import 'package:provider/provider.dart';

import '../../locator.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;
  static final _firestore = Firestore.instance;

  dynamic signUpUser(
    BuildContext context,
    String email,
    String name,
    String profileImg,
    String password,
    GlobalKey<ScaffoldState> scaffoldKey,
  ) async {
    try {
      // Register user in Firebase Auth system
      FirebaseUser signedInUser;
      AuthResult authResult = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      signedInUser = authResult.user;

      // Register user in Firebase storage system
      if (signedInUser != null) {
        _firestore.collection('/users').document(signedInUser.uid).setData({
          'email': email,
          'name': name,
          'profileImageUrl': profileImg,
        });
        Provider.of<UserData>(context, listen: false).currentUserId =
            signedInUser.uid;

        User user =
            await locator<DatabaseServices>().getUserById(signedInUser.uid);
        Navigator.pop(context);
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

  void login(
    String email,
    String password,
    GlobalKey<ScaffoldState> scaffoldKey,
    BuildContext context,
  ) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      var getResult =
          await locator<DatabaseServices>().getUserById(result.user.uid);

      Navigator.pop(context);
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

  // Sign in user by google
  // If success return
  // {
  //   'error': false,
  //   'errorMessage': null,
  //   'data': FirebaseUser,
  // }
  // else
  // {
  //   'error': true,
  //   'errorMessage': String,
  //   'data': null,
  // }
  Future signInByGoogle(BuildContext context) async {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    final FirebaseUser fireUser =
        (await auth.signInWithCredential(credential)).user;
    final FirebaseUser currentUser = await _auth.currentUser();

    // Check new user
    if (fireUser.email == null) {
      print('Invalid Email');
      return {
        'error': true,
        'error_message': "User hasn't email",
        'data': null,
      };
    }
    if (fireUser.displayName == null) {
      print('Invalid name');
      return {
        'error': true,
        'error_message': "User hasn't name",
        'data': null,
      };
    }
    if (fireUser.isAnonymous) {
      print('Anonymous user');
      return {
        'error': true,
        'error_message': "User is an anonymous",
        'data': null,
      };
    }
    if (await fireUser.getIdToken() == null) {
      print('User id token is null');
      return {
        'error': true,
        'error_message': "Invalid token",
        'data': null,
      };
    }
    if (fireUser.uid != currentUser.uid) {
      print('Invalid user');
      return {
        'error': true,
        'error_message': "Invalid user",
        'data': null,
      };
    }

    if (!(await DatabaseServices.isUserExists(fireUser.uid))) {
      print('asd');
      await _firestore.collection('/users').document(fireUser.uid).setData({
        'email': fireUser.email,
        'name': fireUser.displayName,
        'profileImageUrl': fireUser.photoUrl,
      });
    }

    String userId = Provider.of<UserData>(context, listen: false).currentUserId;
    locator<HomeViewModel>().fetch(userId);

    Navigator.pop(context);

    // Success
  }

  Future signInByFacebook(BuildContext context) async {
    final result = await facebookSignIn.logIn(['email', 'public_profile']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        print('success');
        final AuthCredential credential = FacebookAuthProvider.getCredential(
          accessToken: result.accessToken.token,
        );
        FirebaseUser fireUser =
            (await auth.signInWithCredential(credential)).user;

        if (await DatabaseServices.isUserExists(fireUser.uid)) {
          Navigator.pop(context);
        } else {
          final responce = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,email&access_token=${result.accessToken.token}',
          );
          String name = json.decode(responce.body)['name'];
        }

        break;
      case FacebookLoginStatus.cancelledByUser:
        print('canceled');
        break;
      case FacebookLoginStatus.error:
        print('Error: ${result.errorMessage}');
        break;
    }
  }
}
