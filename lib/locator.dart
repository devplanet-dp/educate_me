import 'package:get_it/get_it.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_themes/stacked_themes.dart';

import 'data/services/api_service.dart';
import 'data/services/auth_service.dart';
import 'data/services/cloud_storage_service.dart';
import 'data/services/image_service.dart';
import 'data/services/local_storage_service.dart';

GetIt locator = GetIt.instance;

Future setupLocator() async {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => ThemeService.getInstance());
  locator.registerLazySingleton(() => BottomSheetService());
  locator.registerLazySingleton(() => CloudStorageService());
  locator.registerLazySingleton(() => ImageSelector());
  locator.registerLazySingleton(() => AuthenticationService());
  locator.registerLazySingleton(() => ApiService());

  var instance = await LocalStorageService.getInstance();
  locator.registerSingleton<LocalStorageService>(instance!);
}
