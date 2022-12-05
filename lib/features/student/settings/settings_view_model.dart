import 'package:educate_me/core/shared/app_colors.dart';
import 'package:educate_me/core/shared/shared_styles.dart';
import 'package:educate_me/core/utils/app_utils.dart';
import 'package:educate_me/core/utils/constants/app_assets.dart';
import 'package:educate_me/core/widgets/app_dialog.dart';
import 'package:educate_me/features/student/account/account_view.dart';
import 'package:educate_me/features/student/forgot/forgot_pwd_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../data/services/auth_service.dart';
import '../../../locator.dart';

class SettingViewModel extends BaseViewModel {
  final _authService = locator<AuthenticationService>();
  final _dialogService = locator<DialogService>();
  final accountAuthBusy = false;

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
      return showErrorMessage(message: result.errorMessage );
    }
  }

  void goToAccountView() async {
    Get.dialog(AppDialogWithInput(
      title: 'text005'.tr,
      image: kIcSafe,
      subtitle: 'text081'.tr,
      onNegativeTap: () => Get.back(),
      secondaryActionWidget: TextButton(
        onPressed: () =>Get.off(()=>const ForgotPwdView()),
        child: Text(
          'text083'.tr,
          style: kCaptionStyle.copyWith(
            color: kcPrimaryColor,
              fontSize: 18, fontWeight: FontWeight.w500),
        ).alignment(Alignment.topLeft),
      ),
      onPositiveTap: (input) {
        authToAccount(input);
      },
    ));
  }
}
