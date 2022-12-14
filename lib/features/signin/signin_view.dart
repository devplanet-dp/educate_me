import 'package:educate_me/features/signin/components/create_account_text.dart';
import 'package:educate_me/features/signin/components/custom_app_bar.dart';
import 'package:educate_me/features/welcome/welcome_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
import 'components/fgt_pwd_button.dart';
import 'signin_view_model.dart';

class SignInView extends StatelessWidget {
  const SignInView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SignInViewModel>.reactive(
      builder: (context, vm, child) => GestureDetector(
        onTap: () => DeviceUtils.hideKeyboard(context),
        child: _buildResponsive(vm, context),
      ),
      viewModelBuilder: () => SignInViewModel(),
    );
  }

  Widget _buildResponsive(SignInViewModel vm, BuildContext context) {
    return ResponsiveBuilder(builder: (context, _) {
      if (_.isDesktop) {
        return _buildDesktop(vm, context);
      } else if (_.isTablet) {
        return _buildTab(vm, context);
      } else {
        return _buildBody(vm, context);
      }
    });
  }

  Widget _buildTab(SignInViewModel vm, BuildContext context) => SafeArea(
        child: KeyboardVisibilityBuilder(builder: (context, isVisible) {
          return Scaffold(
            backgroundColor: Colors.white,
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Spacer(),
                            Text(
                              'text002'.tr,
                              textAlign: TextAlign.center,
                              style: kHeading3Style.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black,
                                  fontSize: 60),
                            ),
                            Text(
                              'text012'.tr,
                              style: kBodyStyle.copyWith(
                                  fontSize: 22, fontWeight: FontWeight.w600),
                            ),
                            const Spacer(
                              flex: 2,
                            ),
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
                              fontSize: 32,
                              onPressed: () {
                                DeviceUtils.hideKeyboard(context);
                                vm.doSignIn();
                              },
                            ).paddingSymmetric(horizontal: Get.width * .1),
                            isVisible ? emptyBox() : const Spacer(),
                            isVisible
                                ? emptyBox()
                                : const ForgotPwdButton().center(),
                            isVisible
                                ? emptyBox()
                                : const CreateAccountText().center(),
                            isVisible
                                ? emptyBox()
                                : const Spacer(
                                    flex: 2,
                                  )
                          ],
                        ).paddingSymmetric(horizontal: kTabPaddingHorizontal),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      );

  Widget _buildDesktop(SignInViewModel vm, BuildContext context) => SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(kImgUnionPng), fit: BoxFit.cover),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Form(
              key: vm.formKey,
              child: Row(
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                      const Spacer(
                        flex: 2,
                      ),
                    ],
                  )),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Spacer(),
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
                          vm.doSignIn();
                        },
                      ),
                      const Spacer(),
                    ],
                  ).paddingSymmetric(horizontal: 8.w))
                ],
              ),
            ),
          ),
        ),
      );

  Widget _buildBody(SignInViewModel vm, BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(kImgUnionPng), fit: BoxFit.cover),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: KeyboardVisibilityBuilder(builder: (context, isVisible) {
            return Form(
              key: vm.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomAppBar(
                    onBack: () => Get.offAll(() => const WelcomeView()),
                  ),
                  const Spacer(),
                  Text(
                    'text002'.tr,
                    style: kHeading3Style.copyWith(
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                        fontSize: 28),
                  ),
                  Text('text012'.tr,
                      style: kBodyStyle.copyWith(
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF565656))),
                  const Spacer(
                    flex: 2,
                  ),
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
                  ).width(230).center(),
                  isVisible ? emptyBox() : const Spacer(),
                  isVisible ? emptyBox() : const ForgotPwdButton().center(),
                  isVisible ? emptyBox() : const CreateAccountText().center(),
                  isVisible
                      ? emptyBox()
                      : const Spacer(
                          flex: 2,
                        )
                ],
              ).paddingSymmetric(horizontal: 16),
            );
          }),
        ),
      ),
    );
  }
}
