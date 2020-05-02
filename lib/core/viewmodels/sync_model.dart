import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:habits_plus/core/enums/internet.dart';
import 'package:habits_plus/core/enums/viewstate.dart';
import 'package:habits_plus/core/models/userData.dart';
import 'package:habits_plus/core/services/firebase.dart';
import 'package:habits_plus/core/util/logger.dart';
import 'package:habits_plus/core/viewmodels/home_model.dart';
import 'package:habits_plus/core/viewmodels/settings_model.dart';
import 'package:habits_plus/ui/view/settings.dart';
import 'package:habits_plus/ui/view/sync/exit_dialog.dart';
import 'package:habits_plus/ui/widgets/sync/sync_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habits_plus/core/enums/authstatus.dart';
import 'package:habits_plus/core/models/user.dart';
import 'package:habits_plus/core/services/database.dart';
import 'package:habits_plus/core/services/images.dart';
import 'package:habits_plus/core/util/constant.dart';
import 'package:habits_plus/core/viewmodels/base_model.dart';
import 'package:habits_plus/locator.dart';
import 'package:provider/provider.dart';

class LoginResponce {
  bool success;
  AuthError error;
  User user;

  LoginResponce({
    this.success,
    this.error,
    this.user,
  });
}

class SyncViewModel extends BaseViewModel {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  DatabaseServices _databaseServices = locator<DatabaseServices>();
  ImageServices _imageServices = locator<ImageServices>();
  FirebaseServices _firebaseServices = locator<FirebaseServices>();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  FacebookLogin _facebookSignIn = FacebookLogin();
  Firestore _firestore = Firestore.instance;
  SettingsViewModel _settingsViewModel = locator<SettingsViewModel>();
  User _user;

  // ANCHOR: get
  User get user {
    if (_user == null) {
      // fetch
      _user = _settingsViewModel.user;
    }
    return _user;
  }

  Future<InternetConnection> hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return InternetConnection.Connected;
      }
    } on SocketException catch (_) {
      return InternetConnection.NotConnected;
    }
  }

  void setUserToOtherPages(User user) async {
    locator<SettingsViewModel>().user = user;
  }

  /// return: user id
  Future<LoginResponce> loginWithEmail(
      BuildContext context, String email, String password) async {
    // setState
    setState(ViewState.Busy);

    try {
      // Check internet connection
      if ((await hasInternetConnection()) == InternetConnection.NotConnected) {
        return LoginResponce(
          error: AuthError.NetworkError,
          success: false,
          user: null,
        );
      }

      // Get unsaved data status
      bool status = _databaseServices.hasUnsavedData();
      if (status) {
        // Show dialog
        bool isDialogConfirmed = false;
        await showDialog(
          context: context,
          builder: (_) => SyncExitDialog(
            onYes: () => isDialogConfirmed = true,
            onNo: () => isDialogConfirmed = false,
          ),
        );

        if (isDialogConfirmed) {
          // TODO: clear all data in sharedPreferences & login
        } else {
          return LoginResponce(
            error: AuthError.UserExit,
            success: false,
            user: null,
          );
        }
      }

      // Login
      AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // extract fireuser
      FirebaseUser firebaseUser = result.user;

      // get user image
      String photoBase64;
      if (firebaseUser.photoUrl != null) {
        http.Response responce = await http.get(firebaseUser.photoUrl);
        photoBase64 = _imageServices.base64String(responce.bodyBytes);
      }

      // make user
      User user = User(
        email: firebaseUser.email,
        id: firebaseUser.uid,
        isEmailConfirm: firebaseUser.isEmailVerified,
        name: firebaseUser.displayName,
        profileImgBase64String: photoBase64,
      );

      // save user
      bool dbcode = await _databaseServices.setUser(user);

      // set isSync
      dbcode = dbcode && await _databaseServices.setIsSync(true);

      if (!dbcode) {
        return LoginResponce(
          error: AuthError.SaveError,
          success: false,
          user: null,
        );
      }

      // if user doesnt exist -> sign up
      if (!await _firebaseServices.isUserExist(user.id)) {
        bool code = await saveToDb(user);
        if (!code) {
          return LoginResponce(
            error: AuthError.SaveError,
            success: false,
            user: null,
          );
        }

        // push to db
        _databaseServices.setUser(user);
      }

      if (!user.isEmailConfirm) {
        await firebaseUser.sendEmailVerification();
      }

      // return user
      return LoginResponce(
        error: null,
        success: true,
        user: user,
      );
    } catch (e) {
      // init error type
      AuthError errorType;

      // check platform
      if (Platform.isAndroid) {
        // indetificate error
        switch (e.message) {
          case 'There is no user record corresponding to this identifier. The user may have been deleted.':
            errorType = AuthError.UserNotFound;
            break;
          case 'The password is invalid or the user does not have a password.':
            errorType = AuthError.PasswordNotValid;
            break;
          case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
            errorType = AuthError.NetworkError;
            break;
          default:
            print('Case ${e.message} is not yet implemented');
        }
      } else if (Platform.isIOS) {
        // indetificate error
        switch (e.code) {
          case 'Error 17011':
            errorType = AuthError.UserNotFound;
            break;
          case 'Error 17009':
            errorType = AuthError.PasswordNotValid;
            break;
          case 'Error 17020':
            errorType = AuthError.NetworkError;
            break;
          // ...
          default:
            print('Case ${e.message} is not yet implemented');
        }
      }

      if (errorType != AuthError.PasswordNotValid) {
        logger.e('Error while loging', [e.toString()]);
      }

      return LoginResponce(
        error: errorType,
        success: false,
        user: null,
      );
    } finally {
      // setState
      setState(ViewState.Idle);
    }
  }

  Future<bool> resetPassword(String email) async {
    try {} catch (e) {}
  }

  /// return: is success
  Future<bool> saveToDb(User user) async {
    try {
      // set data to firebase
      await userRef.document(user.id).setData(user.toDocument());

      // return user id
      return true;
    } catch (e) {
      logger.e('Error while signup $e');
      return false;
    }
  }

  /// get current user
  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  /// sign out
  Future<void> signOut() async {
    setState(ViewState.Busy);
    await _firebaseAuth.signOut();
    setState(ViewState.Idle);
  }

  /// send email
  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  /// check email verification
  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

  Future<LoginResponce> signInWithGoogle(BuildContext context) async {
    setState(ViewState.Busy);
    try {
      // Check internet connection
      if ((await hasInternetConnection()) == InternetConnection.NotConnected) {
        return LoginResponce(
          error: AuthError.NetworkError,
          success: false,
          user: null,
        );
      }

      // Get unsaved data status
      bool status = _databaseServices.hasUnsavedData();
      if (status) {
        // Show dialog
        bool isDialogConfirmed = false;
        await showDialog(
          context: context,
          builder: (_) => SyncExitDialog(
            onYes: () => isDialogConfirmed = true,
            onNo: () => isDialogConfirmed = false,
          ),
        );

        if (isDialogConfirmed) {
          // TODO: clear all data in sharedPreferences & login
        } else {
          return LoginResponce(
            error: AuthError.UserExit,
            success: false,
            user: null,
          );
        }
      }

      // Sign in in google
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();

      // get auth
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      //get credential
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      // signIn in habits+
      final AuthResult authResult = await _firebaseAuth.signInWithCredential(
        credential,
      );

      // get user & compare to current user
      final FirebaseUser fireuser = authResult.user;
      final FirebaseUser currentUser = await _firebaseAuth.currentUser();
      assert(fireuser.uid == currentUser.uid);

      String photoUrl;
      if (fireuser.photoUrl != null) {
        try {
          http.Response response = await http.get(fireuser.photoUrl);
          photoUrl = _imageServices.base64String(response.bodyBytes);
        } catch (e) {}
      }

      // Build app user
      User user = User(
        email: fireuser.email,
        id: fireuser.uid,
        isEmailConfirm: fireuser.isEmailVerified,
        name: fireuser.displayName,
        profileImgBase64String: photoUrl,
        profileImageUrl: fireuser.photoUrl,
      );

      // Push into firebase
      if (!(await _firebaseServices.isUserExist(fireuser.uid))) {
        bool code = await saveToDb(user);
        if (!code) {
          return LoginResponce(
            error: AuthError.SaveError,
            success: false,
            user: null,
          );
        }
        // push to db
        await _databaseServices.setUser(user);
      }

      if (!user.isEmailConfirm) {
        await fireuser.sendEmailVerification();
      }

      return LoginResponce(
        error: null,
        success: true,
        user: user,
      );
    } catch (e) {
      logger.e('Error while sign with google $e');
      return LoginResponce(
        error: AuthError.SaveError,
        success: false,
        user: null,
      );
    } finally {
      setState(ViewState.Idle);
    }
  }

  Future<LoginResponce> signInWithFacebook(BuildContext context) async {
    setState(ViewState.Busy);

    try {
      // Check internet connection
      if ((await hasInternetConnection()) == InternetConnection.NotConnected) {
        return LoginResponce(
          error: AuthError.NetworkError,
          success: false,
          user: null,
        );
      }

      // Get unsaved data status
      bool status = _databaseServices.hasUnsavedData();
      if (status) {
        // Show dialog
        bool isDialogConfirmed = false;
        await showDialog(
          context: context,
          builder: (_) => SyncExitDialog(
            onYes: () => isDialogConfirmed = true,
            onNo: () => isDialogConfirmed = false,
          ),
        );

        if (isDialogConfirmed) {
          // TODO: clear all data in sharedPreferences & login
        } else {
          return LoginResponce(
            error: AuthError.UserExit,
            success: false,
            user: null,
          );
        }
      }

      final result = await _facebookSignIn.logIn(['email', 'public_profile']);

      switch (result.status) {
        case FacebookLoginStatus.loggedIn:

          // log ig
          final AuthCredential credential = FacebookAuthProvider.getCredential(
            accessToken: result.accessToken.token,
          );

          // get user
          FirebaseUser fireuser =
              (await _firebaseAuth.signInWithCredential(credential)).user;

          // get user info
          String name;
          String email;
          bool isUserExist = await _firebaseServices.isUserExist(fireuser.uid);
          if (isUserExist) {
            final responce = await http.get(
              'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${result.accessToken.token}',
            );
            name = json.decode(responce.body)['name'];
            email = json.decode(responce.body)['email'];
          }

          // Make user
          User user = User(
            email: email,
            id: fireuser.uid,
            isEmailConfirm: false,
            name: name == null ? 'User' : name,
            profileImageUrl: fireuser.photoUrl,
          );

          // signup
          if (!isUserExist) {
            bool code = await saveToDb(user);
            if (!code) {
              return LoginResponce(
                error: AuthError.SaveError,
                success: false,
                user: null,
              );
            }
            // push to db
            await _databaseServices.setUser(user);
          }

          // if (!user.isEmailConfirm) {
          //   await fireuser.sendEmailVerification();
          // }

          // return
          return LoginResponce(
            error: null,
            success: true,
            user: user,
          );

          break;
        case FacebookLoginStatus.cancelledByUser:
          print('canceled');
          break;
        case FacebookLoginStatus.error:
          print('Error: ${result.errorMessage}');
          break;
      }
    } catch (e) {
      logger.e('Error while facebook login $e');
      return LoginResponce(
        error: AuthError.SaveError,
        success: false,
        user: null,
      );
    } finally {
      setState(ViewState.Idle);
    }
  }

  Future<LoginResponce> signUp(String email, String password) async {
    setState(ViewState.Busy);
    try {
      // Register user in Firebase Auth system
      AuthResult authResult =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      FirebaseUser signedInUser = authResult.user;

      User user = User(
        email: email,
        id: signedInUser.uid,
        isEmailConfirm: _settingsViewModel.user.isEmailConfirm,
        name: _settingsViewModel.user.name,
        profileImageUrl: '',
        profileImgBase64String: _settingsViewModel.user.profileImgBase64String,
      );
      if (signedInUser != null) {
        // Make user

        // set user in firebase storage system
        _firestore.collection('users').document(signedInUser.uid).setData(
              user.toDocument(),
            );
      }

      return LoginResponce(
        error: null,
        success: true,
        user: user,
      );
    } catch (e) {
      AuthError errorType;
      if (Platform.isAndroid) {
        // indetificate error
        switch (e.message) {
          case 'There is no user record corresponding to this identifier. The user may have been deleted.':
            errorType = AuthError.UserNotFound;
            break;
          case 'The password is invalid or the user does not have a password.':
            errorType = AuthError.PasswordNotValid;
            break;
          case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
            errorType = AuthError.NetworkError;
            break;
          default:
            print('Case ${e.message} is not yet implemented');
        }
      } else if (Platform.isIOS) {
        // indetificate error
        switch (e.code) {
          case 'Error 17011':
            errorType = AuthError.UserNotFound;
            break;
          case 'Error 17009':
            errorType = AuthError.PasswordNotValid;
            break;
          case 'Error 17020':
            errorType = AuthError.NetworkError;
            break;
          default:
            print('Case ${e.message} is not yet implemented');
        }
      }

      if (errorType != AuthError.PasswordNotValid) {
        logger.e('Error while loging', [e.toString()]);
      }

      return LoginResponce(
        error: errorType,
        success: false,
        user: null,
      );
    } finally {
      setState(ViewState.Idle);
    }
  }
}
