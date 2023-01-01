import 'package:educate_me/features/signin/components/custom_app_bar.dart';
import 'package:educate_me/features/signup/signup_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../core/shared/app_colors.dart';
import '../../core/shared/shared_styles.dart';
import '../../core/shared/ui_helpers.dart';
import '../../core/utils/constants/app_assets.dart';
import '../../core/utils/device_utils.dart';
import '../../core/widgets/busy_button.dart';
import '../../core/widgets/text_field_widget.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SignUpViewModel>.reactive(
      builder: (context, vm, child) => GestureDetector(
        onTap: () => DeviceUtils.hideKeyboard(context),
        child: _buildResponsive(vm, context),
      ),
      viewModelBuilder: () => SignUpViewModel(),
    );
  }

  Widget _buildResponsive(SignUpViewModel vm, BuildContext context) {
    return ResponsiveBuilder(builder: (context, _) {
      if (_.isDesktop) {
        return _buildBody(vm, context);
      } else if (_.isTablet) {
        return _buildTab(vm, context);
      } else {
        return _buildBody(vm, context);
      }
    });
  }

  Widget _buildTab(SignUpViewModel vm, BuildContext context) => SafeArea(
          child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            Align(
              alignment: Alignment.bottomLeft,
              child: Image.asset(
                kImgUnionTabLeft,
                height: Get.height * .45,
                width: Get.width / 3.5,
                fit: BoxFit.fill,
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Image.asset(
                kImgUnionTabRight,
                height: Get.height * .45,
                width: Get.width / 3.5,
                fit: BoxFit.fill,
              ),
            ),
            Form(
              key: vm.formKey,
              child: Column(
                children: [
                  const CustomAppBar().paddingSymmetric(horizontal: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          vSpaceMedium,
                          Text(
                            'text013'.tr,
                            style: kHeading3Style.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                fontSize: 48),
                          ),
                          Text(
                            'text014'.tr,
                            style: kBodyStyle.copyWith(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF565656)),
                          ),
                          vSpaceMedium,
                          AppTextField(
                            controller: vm.fullNameTEC,
                            hintText: 'text070'.tr,
                            isDark: true,
                            textColor: kcPrimaryColor,
                            fillColor: kcPrimaryColor.withOpacity(.1),
                            label: '',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'text070'.tr;
                              }
                              return null;
                            },
                          ).paddingSymmetric(horizontal: kTabPaddingHorizontal),
                          vSpaceMedium,
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
                          ).paddingSymmetric(horizontal: kTabPaddingHorizontal),
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
                                  label: '')
                              .paddingSymmetric(
                                  horizontal: kTabPaddingHorizontal),
                          vSpaceMassive,
                          BoxButtonWidget(
                            buttonText: 'text015'.tr,
                            isLoading: vm.isBusy,
                            fontSize: 32,
                            onPressed: () {
                              DeviceUtils.hideKeyboard(context);
                              vm.doSignSignUp();
                            },
                          ).paddingSymmetric(
                              horizontal: kTabPaddingHorizontal * 1.2),
                          vSpaceMedium,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ));

  Widget _buildBody(SignUpViewModel vm, BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(kImgUnionPng), fit: BoxFit.cover),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Form(
            key: vm.formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomAppBar(),
                  vSpaceLarge,
                  Text(
                    'text013'.tr,
                    style: kHeading3Style.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        fontSize: 28),
                  ),
                  Text('text014'.tr,
                      style: kBodyStyle.copyWith(
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF565656))),
                  vSpaceMedium,
                  AppTextField(
                    controller: vm.fullNameTEC,
                    hintText: 'text070'.tr,
                    isDark: true,
                    textColor: kcPrimaryColor,
                    fillColor: kcPrimaryColor.withOpacity(.1),
                    label: '',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'text070'.tr;
                      }
                      return null;
                    },
                  ),
                  vSpaceMedium,
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
                  vSpaceMedium,
                  BoxButtonWidget(
                    buttonText: 'text015'.tr,
                    isLoading: vm.isBusy,
                    fontSize: 24,
                    onPressed: () {
                      DeviceUtils.hideKeyboard(context);
                      vm.doSignSignUp();
                    },
                  ).width(230).center(),
                  vSpaceMedium,
                ],
              ).paddingSymmetric(horizontal: 16),
            ),
          ),
        ),
      ),
    );
  }
}
