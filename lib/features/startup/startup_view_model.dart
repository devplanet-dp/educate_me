import 'package:educate_me/data/user.dart';
import 'package:educate_me/features/signin/signin_view.dart';
import 'package:educate_me/features/teacher/home/teacher_home.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';

import '../../data/services/auth_service.dart';
import '../../locator.dart';

class StartUpViewModel extends BaseViewModel {
  final _authenticationService = locator<AuthenticationService>();

  Future handleStartUpLogic() async {
    var currentUser = await _authenticationService.isUserLoggedIn();
    if (currentUser.hasError) {
      Get.off(() => const SignInView());
    } else {
      _handleUserFlow(currentUser.data as UserModel);
    }
  }

  void _handleUserFlow(UserModel u) {
    if (u.role == UserRole.teacher) {
      Get.offAll(() => const TeacherHomeView());
    }
  }
}
