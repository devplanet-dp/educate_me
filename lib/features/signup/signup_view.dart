import 'package:educate_me/features/signin/components/custom_app_bar.dart';
import 'package:educate_me/features/signup/signup_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';

import '../../core/shared/app_colors.dart';
import '../../core/shared/shared_styles.dart';
import '../../core/shared/ui_helpers.dart';
import '../../core/utils/constants/app_assets.dart';
import '../../core/utils/device_utils.dart';
import '../../core/widgets/busy_button.dart';
import '../../core/widgets/text_field_widget.dart';
import '../signin/components/app_bg.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SignUpViewModel>.reactive(
      builder: (context, vm, child) => GestureDetector(
        onTap: () => DeviceUtils.hideKeyboard(context),
        child: SafeArea(
          child: Container(
            decoration:  const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(kImgUnionPng), fit: BoxFit.cover),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: _buildBody(vm, context),
            ),
          ),
        ),
      ),
      viewModelBuilder: () => SignUpViewModel(),
    );
  }
  Widget _buildBody(SignUpViewModel vm, BuildContext context) {
    return Form(
      key: vm.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomAppBar(),
          const Spacer(),
          Text(
            'text013'.tr,
            style: kHeading3Style.copyWith(
                fontWeight: FontWeight.w600, color: Colors.black),
          ),
          Text(
            'text014'.tr,
          ),
          const Spacer(flex: 2,),
          AppTextField(
            controller: vm.emailTEC,
            hintText: 'text003'.tr,
            isEmail: true,
            isDark: true,
            textColor: kcPrimaryColor,
            fillColor: kcPrimaryColor.withOpacity(.1),
            label: '',
            validator: (value) {
              if (!GetUtils.isEmail(value!)) {
                return 'text004.error'.tr;
              }
              return null;
            },
          ),
          vSpaceMedium,
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
            buttonText: 'text015'.tr,
            isLoading: vm.isBusy,
            onPressed: () {
              DeviceUtils.hideKeyboard(context);
              vm.doSignSignUp();
            },
          ),
          const Spacer(flex: 2,)
        ],
      ).paddingSymmetric(horizontal: 16),
    );
  }

}
