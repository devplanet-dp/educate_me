import 'package:educate_me/features/signin/components/app_bg.dart';
import 'package:educate_me/features/signin/components/create_account_text.dart';
import 'package:educate_me/features/signin/components/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../core/shared/app_colors.dart';
import '../../core/shared/shared_styles.dart';
import '../../core/shared/ui_helpers.dart';
import '../../core/utils/device_utils.dart';
import '../../core/widgets/busy_button.dart';
import '../../core/widgets/text_field_widget.dart';
import 'components/fgt_pwd_button.dart';
import 'signin_view_model.dart';

class SignInView extends StatelessWidget {
  const SignInView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SignInViewModel>.reactive(
      builder: (context, vm, child) => GestureDetector(
        onTap: () => DeviceUtils.hideKeyboard(context),
        child: SafeArea(
          child: Scaffold(
            body: Stack(
              children: [
                const AppBgWidget(),
                _buildBody(vm, context),
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => SignInViewModel(),
    );
  }

  Widget _buildBody(SignInViewModel vm, BuildContext context) {
    return Form(
      key: vm.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          Text(
            'text002'.tr,
            style: kHeading3Style.copyWith(
                fontWeight: FontWeight.w600, color: Colors.black),
          ),
          Text(
            'text012'.tr,
          ),
          const Spacer(flex: 2,),
          AppTextField(
            controller: vm.usernameTEC,
            hintText: 'text003'.tr,
            isEmail: true,
            isDark: true,
            textColor: kcPrimaryColor,
            fillColor: kcPrimaryColor.withOpacity(.1),
            borderColor: kcStroke,
            label: '',
            validator: (value) {
              if (!GetUtils.isEmail(value!)) {
                return 'text004.error'.tr;
              }
              return null;
            },
          ),
          AppTextField(
              controller: vm.passwordTEC,
              hintText: 'text005'.tr,
              isPassword: vm.isObscure,
              isDark: true,
              fillColor: kcPrimaryColor.withOpacity(.1),
              borderColor: kcStroke,
              suffix: InkWell(
                onTap: () => vm.toggleObscure(),
                child: Icon(
                  vm.isObscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: kcPrimaryColor,
                  size: 18,
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'text006.error'.tr;
                }
                return null;
              },
              label: ''),
          const Spacer(),
          BoxButtonWidget(
            buttonText: 'text009'.tr,
            isLoading: vm.isBusy,
            onPressed: () {
              DeviceUtils.hideKeyboard(context);
              vm.doSignIn();
            },
          ),
          vSpaceMedium,
          const ForgotPwdButton().center(),
          vSpaceTiny,
          const CreateAccountText().center(),
          const Spacer(flex: 2,)
        ],
      ).paddingSymmetric(horizontal: 16),
    );
  }
}
