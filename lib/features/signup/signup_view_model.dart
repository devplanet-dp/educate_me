import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';

import '../../core/utils/app_controller.dart';
import '../../core/utils/app_utils.dart';
import '../../data/services/auth_service.dart';
import '../../locator.dart';

class SignUpViewModel extends BaseViewModel {
  final _service = locator<AuthenticationService>();
  final AppController controller = Get.find<AppController>();
  final usernameTEC = TextEditingController();
  final emailTEC = TextEditingController();
  final passwordTEC = TextEditingController();
  final formKey = GlobalKey<FormState>();

  int _childCount = 1;

  int get childCount => _childCount;

  incrementChild() {
    _childCount++;
    notifyListeners();
  }

  decrementChildCount() {
    if(_childCount!=0) {
      _childCount--;
      notifyListeners();
    }
  }

  bool _isObscure = true;

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

  void _handleUserFlow() async {
    var user = controller.appUser;
    if (user != null) {
    } else {
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
