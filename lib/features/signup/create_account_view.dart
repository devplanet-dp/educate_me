import 'package:educate_me/core/shared/ui_helpers.dart';
import 'package:educate_me/features/signup/components/add_child_widget.dart';
import 'package:educate_me/features/signup/components/child_controller_widget.dart';
import 'package:educate_me/features/signup/signup_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';

import '../../core/shared/shared_styles.dart';
import '../../core/utils/device_utils.dart';
import '../../core/widgets/busy_button.dart';
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
            bottomNavigationBar:  BoxButtonWidget(
              buttonText: 'text016'.tr,
              isLoading: vm.isBusy,
              onPressed: () =>vm.addUsers(),
            ).paddingSymmetric(horizontal: 16,vertical: 8),
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomAppBar(),
          vSpaceMedium,
          Text(
            'text010'.tr,
            style: kHeading3Style.copyWith(
                fontWeight: FontWeight.w600, color: Colors.black),
          ),
          Text(
            'text011'.tr,
          ),
          vSpaceMedium,
          const ChildControllerWidget(),
          const AddChildWidget(),
        ],
      ).paddingSymmetric(horizontal: 16),
    );
  }
}
