import 'package:get_it/get_it.dart';
import 'package:habits_plus/core/services/images.dart';
import 'package:habits_plus/core/services/notifications.dart';
import 'package:habits_plus/core/viewmodels/base_model.dart';
import 'package:habits_plus/core/viewmodels/detail_model.dart';
import 'package:habits_plus/core/viewmodels/drawer_model.dart';
import 'package:habits_plus/core/viewmodels/home_model.dart';
import 'package:habits_plus/core/viewmodels/settings_model.dart';
import 'package:habits_plus/core/viewmodels/start_model.dart';
import 'package:habits_plus/core/viewmodels/statistic_model.dart';

import 'core/services/database.dart';
import 'core/viewmodels/create_model.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<BaseViewModel>(() => BaseViewModel());
  locator.registerLazySingleton<NotificationServices>(
    () => NotificationServices(),
  );
  locator.registerLazySingleton<StartViewModel>(() => StartViewModel());
  locator.registerLazySingleton<CreateViewModel>(
    () => CreateViewModel(),
  );
  locator.registerLazySingleton<DatabaseServices>(() => DatabaseServices());
  locator.registerLazySingleton<HomeViewModel>(() => HomeViewModel());
  locator.registerLazySingleton<DetailPageView>(() => DetailPageView());
  locator.registerLazySingleton<ImageServices>(() => ImageServices());
  locator.registerLazySingleton<DrawerViewModel>(() => DrawerViewModel());
  locator.registerLazySingleton<StatisticViewModel>(() => StatisticViewModel());
  locator.registerLazySingleton<SettingsViewModel>(() => SettingsViewModel());
}
