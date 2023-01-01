import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'core/shared/app_theme.dart';
import 'core/utils/device_utils.dart';
import 'features/startup/startup_view.dart';
import 'firebase_options.dart';
import 'locale.dart';
import 'locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kReleaseMode) {
    //increase the cache size
    CustomImageCache();
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([
    // DeviceOrientation.portraitDown,
    // DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).then((_) async {
    await setupLocator();

    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 800),
        splitScreenMode: true,
        builder: (context, _) {
          return GetMaterialApp(
            translations: AppLocale(),
            locale: Get.deviceLocale,
            fallbackLocale: const Locale(
              'en_US',
            ),
            darkTheme: themeDataDark,
            themeMode: ThemeMode.light,
            debugShowCheckedModeBanner: false,
            title: 'Math Educate Me',
            theme: themeData,
            home: const StartUpView(),
          );
        });
  }
}
