import 'package:educate_me/features/signup/components/child_controller_widget.dart';
import 'package:educate_me/features/signup/signup_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';

import '../../core/shared/app_colors.dart';
import '../../core/shared/shared_styles.dart';
import '../../core/shared/ui_helpers.dart';
import '../../core/utils/device_utils.dart';
import '../../core/widgets/busy_button.dart';
import '../../core/widgets/text_field_widget.dart';
import '../signin/components/app_bg.dart';
import '../signin/components/custom_app_bar.dart';

class CreateAccountView extends StatelessWidget {
  const CreateAccountView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SignUpViewModel>.reactive(
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
            'text010'.tr,
            style: kHeading3Style.copyWith(
                fontWeight: FontWeight.w600, color: Colors.black),
          ),
          Text(
            'text011'.tr,
          ),
          const Spacer(),
          const ChildControllerWidget(),
          const Spacer(),
          BoxButtonWidget(
            buttonText: 'text015'.tr,
            isLoading: vm.isBusy,
            onPressed: () {
              DeviceUtils.hideKeyboard(context);
              vm.doSignIn();
            },
          ),
          const Spacer(flex: 2,)
        ],
      ).paddingSymmetric(horizontal: 16),
    );
  }

}
