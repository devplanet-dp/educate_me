import 'package:educate_me/core/shared/app_colors.dart';
import 'package:educate_me/core/shared/shared_styles.dart';
import 'package:educate_me/core/utils/app_utils.dart';
import 'package:educate_me/core/utils/constants/app_assets.dart';
import 'package:educate_me/core/widgets/app_dialog.dart';
import 'package:educate_me/data/services/firestore_service.dart';
import 'package:educate_me/features/student/account/account_view.dart';
import 'package:educate_me/features/student/account/my_profile_view.dart';
import 'package:educate_me/features/student/forgot/forgot_pwd_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../core/utils/app_controller.dart';
import '../../../data/services/auth_service.dart';
import '../../../locator.dart';

class SettingViewModel extends BaseViewModel {
  final _authService = locator<AuthenticationService>();
  final _service = locator<FirestoreService>();
  final _dialogService = locator<DialogService>();
  final accountAuthBusy = false;
  final profileAuthBusy = false;
  final AppController controller = Get.find<AppController>();

  void signOut() async {
    var result = await _dialogService.showConfirmationDialog(
        title: 'Are you sure?', description: 'Sign out');
    if (result?.confirmed ?? false) {
      _authService.signOut();
    }
  }

  Future<void> authToAccount(String pwd) async {
    setBusyForObject(accountAuthBusy, true);
    var result = await _authService.getAuthWithPassword(password: pwd);
    setBusyForObject(accountAuthBusy, false);
    if (!result.hasError) {
      Get.to(() => const AccountView());
    } else {
      goToAccountView(isFailed: true, message: result.errorMessage);
    }
  }

  Future<void> authToProfileAccount(String pwd) async {
    setBusyForObject(profileAuthBusy, true);
    var result = await _authService.getAuthWithPassword(password: pwd);
    setBusyForObject(profileAuthBusy, false);
    if (!result.hasError) {
      await Get.to(() => const MyProfileView());
    } else {
      goToProfilesView(isFailed: true,message: result.errorMessage);
    }
  }

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

  void goToAccountView({bool isFailed = false, String? message}) async {
    Get.dialog(AppDialogWithInput(
      title: 'text005'.tr,
      image: kIcSafe,
      subtitle: message ?? 'text081'.tr,
      onNegativeTap: () => Get.back(),
      secondaryActionWidget: TextButton(
        onPressed: () => Get.off(() => const ForgotPwdView()),
        child: Text(
          'text083'.tr,
          style: kCaptionStyle.copyWith(
              color: kcPrimaryColor, fontSize: 18, fontWeight: FontWeight.w500),
        ).alignment(Alignment.topLeft),
      ),
      onPositiveTap: (input) {
        Get.back();
        authToAccount(input);
      },
      isFailed: isFailed,
    ));
  }

  void goToProfilesView({bool isFailed = false, String? message}) async {
    Get.dialog(AppDialogWithInput(
      title: 'text005'.tr,
      image: kIcSafe,
      subtitle: message ?? 'text081.profile'.tr,
      onNegativeTap: () => Get.back(),
      secondaryActionWidget: TextButton(
        onPressed: () => Get.off(() => const ForgotPwdView()),
        child: Text(
          'text083'.tr,
          style: kCaptionStyle.copyWith(
              color: kcPrimaryColor,
              fontSize: 12, fontWeight: FontWeight.w500),
        ).alignment(Alignment.topLeft),
      ),
      onPositiveTap: (input) {
        Get.back();
        authToProfileAccount(input);
      },
      isFailed: isFailed,
    ));
  }
}
