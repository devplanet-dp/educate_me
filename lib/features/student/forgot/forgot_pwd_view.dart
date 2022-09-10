import 'package:educate_me/core/shared/shared_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../core/utils/device_utils.dart';
import '../../../core/widgets/busy_button.dart';
import '../../../core/widgets/text_field_widget.dart';
import '../../signin/signin_view_model.dart';

class ForgotPwdView extends StatelessWidget {
  const ForgotPwdView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SignInViewModel>.reactive(
      builder: (context, vm, child) => GestureDetector(
        onTap: () => DeviceUtils.hideKeyboard(context),
        child: Scaffold(
          bottomNavigationBar: BoxButtonWidget(
            buttonText: 'text084'.tr,
            isLoading: vm.isBusy,
            radius: 8,
            onPressed: () => vm.resetPassword(),
          )
              .paddingSymmetric(horizontal: 16, vertical: 12)
              .card(elevation: 7, color: Colors.white),
          appBar: AppBar(
            automaticallyImplyLeading: true,
            centerTitle: true,
            title: Text('text083'.tr),
          ),
          body: Form(
            key: vm.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                Text(
                  'text085'.tr,
                  style: kBodyStyle,
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                AppTextFieldSecondary(
                  controller: vm.emailTEC,
                  hintText: 'text004'.tr,
                  isEmail: true,
                  label: 'text003'.tr,
                  validator: (value) {
                    if (!GetUtils.isEmail(value!)) {
                      return 'text004'.tr;
                    }
                    return null;
                  },
                ),
                const Spacer(
                  flex: 5,
                )
              ],
            ).paddingSymmetric(horizontal: 16),
          ),
        ),
      ),
      viewModelBuilder: () => SignInViewModel(),
    );
  }
}
