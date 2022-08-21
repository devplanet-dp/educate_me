
import 'package:educate_me/core/utils/constants/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:the_apple_sign_in/apple_sign_in_button.dart' as apple;

import '../../core/shared/app_colors.dart';
import '../../core/shared/shared_styles.dart';
import '../../core/shared/ui_helpers.dart';
import '../../core/utils/cache_controller.dart';
import '../../core/utils/device_utils.dart';
import '../../core/widgets/background_overlay.dart';
import '../../core/widgets/brand_bg_widget.dart';
import '../../core/widgets/busy_button.dart';
import '../../core/widgets/rich_text.dart';
import '../../core/widgets/text_field_widget.dart';
import 'components/fgt_pwd_button.dart';
import 'components/google_button.dart';
import 'components/or_separator.dart';
import 'signin_view_model.dart';

class SignInView extends StatelessWidget {
  const SignInView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SignInViewModel>.reactive(
      onModelReady: (model) {
        model.checkAppleSignAvailable();
      },
      builder: (context, vm, child) => GestureDetector(
        onTap: () => DeviceUtils.hideKeyboard(context),
        child: SafeArea(
          child: Scaffold(
            body: Stack(
              children: [
                const BrandBgWidget(imgName: kImgLogin),
                const Align(
                  alignment: Alignment.bottomCenter,
                  child: BackgroundOverlayWidget(
                    isDark: true,
                  ),
                ),
                _buildBody(vm, context),
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => SignInViewModel(),
    );
  }

  SingleChildScrollView _buildBody(SignInViewModel vm, BuildContext context) {
    return SingleChildScrollView(
      padding: fieldPadding,
      child: Form(
        key: vm.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            vSpaceLarge,
            Text(
              'text002'.tr,
              style: kHeading3Style.copyWith(fontWeight: FontWeight.w600,color: kAltWhite),
            ),
            vSpaceSmall,
            vSpaceMedium,
            AppTextField(
              controller: vm.usernameTEC,
              hintText: 'text004'.tr,
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
            vSpaceMedium,
            AppTextField(
                controller: vm.passwordTEC,
                hintText: 'text006'.tr,
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
            vSpaceSmall,
            const Align(
              alignment: Alignment.topRight,
              child: ForgotPwdButton(),
            ),
            vSpaceMedium,
            BoxButtonWidget(
              buttonText: 'text002'.tr,
              isLoading: vm.isBusy,
              onPressed: () {
                DeviceUtils.hideKeyboard(context);
                vm.doSignIn();
              },
            ),
            vSpaceMedium,
            RichTextWidget(
              isLight: false,
                    firstTxt: 'text008', secondTxt: 'text009', onTap: () {})
                .center(),
            vSpaceMedium,
            const OrSeperator(
              isDark: true,
            ),
            if (vm.isAppleSignAvailable)
              apple.AppleSignInButton(
                  onPressed: () => vm.doAppleSignIn(),
                  cornerRadius: 8,
                  style: apple.ButtonStyle.black)
            else
              emptyBox(),
            vSpaceSmall,
            GoogleSignInButton(
              onTap: () => vm.doSGoogleSignIn(),
              isBusy: vm.busy(vm.googleSignIn),
            ),
            vSpaceMedium
          ],
        ),
      ),
    );
  }
}
