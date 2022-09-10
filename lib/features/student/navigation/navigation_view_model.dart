import 'package:educate_me/data/services/firestore_service.dart';
import 'package:educate_me/data/user.dart';
import 'package:educate_me/locator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';

import '../../../core/utils/app_controller.dart';
import '../../../core/utils/app_utils.dart';

class NavigationViewModel extends IndexTrackingViewModel {
  final _service = locator<FirestoreService>();
  final AppController controller = Get.find<AppController>();
  final nameTEC = TextEditingController();
  final ageTEC = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Future initAppUsers({String? selectedChildId}) async {
    setBusy(true);
    final child =
        await _service.getChildUsers(controller.appUser?.userId ?? '');
    controller.appChild = child;
    if (child.isNotEmpty) {
      controller.currentChild = selectedChildId == null
          ? child[0]
          : controller.appChild.firstWhere((e) => e.userId == selectedChildId);
    }
    setBusy(false);
  }

  void initChildAccountDetails() {
    nameTEC.text = controller.currentChild?.name ?? '';
    ageTEC.text = controller.currentChild?.age ?? '';
    notifyListeners();
  }

  void onSwitchProfile(UserModel child) async {
    controller.currentChild = child;
    setBusy(true);
    await _service.populateCurrentChild();
    setBusy(false);
  }

  Future<void> updateChildAccountDetails() async {
    if (formKey.currentState!.validate()) {
      setBusy(true);
      var result = await _service.updateChildAccount(name: nameTEC.text);
      if (!result.hasError) {
        ///init app child in switch account popup
        await initAppUsers(selectedChildId: controller.currentChild?.userId);
        showInfoMessage(message: 'text078'.tr);
      } else {
        showErrorMessage(message: result.errorMessage ?? '');
      }
      setBusy(false);
    }
  }

  @override
  void dispose() {
    nameTEC.dispose();
    ageTEC.dispose();
    super.dispose();
  }
}
