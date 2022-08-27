import 'package:educate_me/data/user.dart';
import 'package:educate_me/features/teacher/home/teacher_home.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

import '../../core/utils/app_controller.dart';
import '../../core/utils/app_utils.dart';
import '../../data/services/auth_service.dart';
import '../../locator.dart';

class SignInViewModel extends BaseViewModel {
  final _service = locator<AuthenticationService>();
  final AppController controller = Get.find<AppController>();
  final usernameTEC = TextEditingController();
  final emailTEC = TextEditingController();
  final passwordTEC = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool _isObscure = true;
  bool _isAppleSignAvailable = false;

  bool get isAppleSignAvailable => _isAppleSignAvailable;

  Future checkAppleSignAvailable() async {
    setBusyForObject(_isAppleSignAvailable, true);
    final appleSignInAvailable = await TheAppleSignIn.isAvailable();
    _isAppleSignAvailable = appleSignInAvailable;
    setBusyForObject(_isAppleSignAvailable, false);
  }

  var googleSignIn;

  bool get isObscure => _isObscure;

  toggleObscure() {
    _isObscure = !_isObscure;
    notifyListeners();
  }

  Future<void> doSignIn() async {
    if (formKey.currentState!.validate()) {
      setBusy(true);
      var result = await _service.loginWithEmail(
          email: usernameTEC.text.trim(), password: passwordTEC.text.trim());
      if (!result.hasError) {
        _handleUserFlow();
      } else {
        showErrorMessage(message: result.errorMessage);
      }
      setBusy(false);
    }
  }

  Future<void> doSGoogleSignIn() async {
    setBusyForObject(googleSignIn, true);
    var result = await _service.signInWithGoogle();
    setBusyForObject(googleSignIn, false);
    if (!result.hasError) {
      _handleUserFlow();
    } else {
      showErrorMessage(message: result.errorMessage);
    }
  }

  Future<void> doAppleSignIn() async {
    setBusy(true);
    var result =
        await _service.signInWithApple(scopes: [Scope.email, Scope.fullName]);
    setBusy(false);
    if (!result.hasError) {
      _handleUserFlow();
    } else {
      showErrorMessage(message: result.errorMessage);
    }
  }

  Future<void> resetPassword() async {
    if (formKey.currentState!.validate()) {
      setBusy(true);
      var result = await _service.sendPasswordResetEmail(emailTEC.text.trim());
      if (!result.hasError) {
        Get.back();
        showInfoMessage(message: 'pwd.reset.email.send'.tr);
      } else {
        showErrorMessage(message: result.errorMessage);
      }
      setBusy(false);
    }
  }
  void createAdmin()async{
    setBusy(true);
    var result = await _service.signUpUserWithEmail(email: 'admin@educateme.com', password: 'Admin#001');
    setBusy(false);
  }

  void _handleUserFlow() async {
    var user = controller.appUser;
    if (user != null) {
      if(user.role == UserRole.teacher){
        Get.offAll(()=>const TeacherHomeView());
      }
    }else{
      showErrorMessage(message: 'no_user'.tr);
    }
  }

  @override
  void dispose() {
    emailTEC.dispose();
    usernameTEC.dispose();
    passwordTEC.dispose();
    super.dispose();
  }
}
