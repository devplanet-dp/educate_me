import 'package:educate_me/core/shared/ui_helpers.dart';
import 'package:educate_me/features/signup/components/add_child_widget.dart';
import 'package:educate_me/features/signup/components/child_controller_widget.dart';
import 'package:educate_me/features/signup/signup_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';

import '../../core/shared/shared_styles.dart';
import '../../core/utils/constants/app_assets.dart';
import '../../core/utils/device_utils.dart';
import '../signin/components/custom_app_bar.dart';

class CreateAccountView extends StatelessWidget {
  const CreateAccountView({Key? key, this.isAddAccount = false})
      : super(key: key);
  final bool isAddAccount;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SignUpViewModel>.reactive(
      builder: (context, vm, child) => GestureDetector(
        onTap: () => DeviceUtils.hideKeyboard(context),
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(kImgUnionPng2), fit: BoxFit.cover),
          ),
          child: SafeArea(
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomAppBar(),
          vSpaceMedium,
          Text(
            isAddAccount ? 'text010.2'.tr : 'text010'.tr,
            style: kHeading3Style.copyWith(
                fontWeight: FontWeight.w600, color: Colors.black),
          ),
          Text(
            isAddAccount? 'text011.2'.tr: 'text011'.tr,
          ),
          vSpaceMedium,
          const ChildControllerWidget(),
           AddChildWidget(isAddAccount: isAddAccount,),
        ],
      ).paddingSymmetric(horizontal: 16),
    );
  }
}
