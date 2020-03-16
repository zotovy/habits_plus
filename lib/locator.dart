import 'package:get_it/get_it.dart';
import 'package:habits_plus/core/services/auth.dart';
import 'package:habits_plus/core/viewmodels/base_model.dart';
import 'package:habits_plus/core/viewmodels/login_model.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<BaseViewModel>(() => BaseViewModel());
  locator.registerLazySingleton<LoginViewModel>(() => LoginViewModel());
  locator.registerLazySingleton<AuthService>(() => AuthService());
}
