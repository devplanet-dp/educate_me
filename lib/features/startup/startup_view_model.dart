import 'package:educate_me/data/user.dart';
import 'package:educate_me/features/student/navigation/navigation_view.dart';
import 'package:educate_me/features/signin/signin_view.dart';
import 'package:educate_me/features/teacher/home/teacher_home.dart';
import 'package:educate_me/features/teacher/navigation/teacher_navigation_view.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';

import '../../data/services/auth_service.dart';
import '../../locator.dart';
import '../welcome/welcome_view.dart';

class StartUpViewModel extends BaseViewModel {
  final _authenticationService = locator<AuthenticationService>();

  Future handleStartUpLogic() async {
    var currentUser = await _authenticationService.isUserLoggedIn();
    if (currentUser.hasError) {
      if(!kIsWeb) {
        Get.off(() => const WelcomeView());
      }else{
        Get.off(() => const SignInView());
      }
    } else {
      _handleUserFlow(currentUser.data as UserModel);
    }
  }

  void _handleUserFlow(UserModel u) {
    if (u.role == UserRole.teacher) {
      Get.offAll(() => const TeacherNavigationView());
    }else{
      Get.offAll(()=>const NavigationView());
    }
  }
}
