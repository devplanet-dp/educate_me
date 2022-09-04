import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educate_me/data/services/firestore_service.dart';
import 'package:educate_me/data/user.dart';
import 'package:educate_me/features/signup/create_account_view.dart';
import 'package:educate_me/features/student/navigation/navigation_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';
import 'package:uuid/uuid.dart';

import '../../core/utils/app_controller.dart';
import '../../core/utils/app_utils.dart';
import '../../data/services/auth_service.dart';
import '../../locator.dart';

class SignUpViewModel extends BaseViewModel {
  final _authService = locator<AuthenticationService>();
  final _fireService = locator<FirestoreService>();
  final AppController controller = Get.find<AppController>();
  final usernameTEC = TextEditingController();
  final emailTEC = TextEditingController();
  final passwordTEC = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final List<ChildController> _childCount = [
    ChildController(
        nameTEC: TextEditingController(), ageTEC: TextEditingController())
  ];

  List<ChildController> get childCount => _childCount;

  incrementChild() {
    _childCount.add(ChildController(
        nameTEC: TextEditingController(), ageTEC: TextEditingController()));
    notifyListeners();
  }

  decrementChildCount() {
    if (_childCount.length != 1) {
      _childCount.removeLast();
      notifyListeners();
    }
  }

  bool _isObscure = true;

  bool get isObscure => _isObscure;

  toggleObscure() {
    _isObscure = !_isObscure;
    notifyListeners();
  }

  Future<void> doSignSignUp() async {
    if (formKey.currentState!.validate()) {
      setBusy(true);
      var result = await _authService.signUpUserWithEmail(
          email: emailTEC.text, password: passwordTEC.text);
      if (!result.hasError) {
        Get.off(() => const CreateAccountView());
      } else {
        showErrorMessage(message: result.errorMessage);
      }
      setBusy(false);
    }
  }

  Future<void> addUsers() async {
    if (formKey.currentState!.validate()) {
      setBusy(true);
      for (var child in childCount) {
        var user = UserModel(
            name: child.nameTEC.text,
            email: '',
            role: UserRole.student,
            userId: const Uuid().v4(),
            createdDate: Timestamp.now(),
            age: child.ageTEC.text);
        var result = await _fireService.createChild(
            parentId: controller.appUser?.userId ?? '', child: user);
      }
      Get.offAll(()=>const NavigationView());
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
    for (var e in childCount) {
      e.nameTEC.dispose();
      e.ageTEC.dispose();
    }
    super.dispose();
  }
}

class ChildController {
  final TextEditingController nameTEC;
  final TextEditingController ageTEC;

  ChildController({required this.nameTEC, required this.ageTEC});
}
