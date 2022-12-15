import 'package:educate_me/core/shared/ui_helpers.dart';
import 'package:educate_me/features/signup/components/add_child_widget.dart';
import 'package:educate_me/features/signup/components/child_controller_widget.dart';
import 'package:educate_me/features/signup/signup_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
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

  Widget _buildTab(SignUpViewModel vm, BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: Image.asset(kImgUnionTabLeft,
                height: Get.height * .45,
                width: Get.width / 3.5,
                fit: BoxFit.fill),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Image.asset(kImgUnionTabRight,
                height: Get.height * .45,
                width: Get.width / 3.5,
                fit: BoxFit.fill),
          ),
          Column(
            children: [
              const CustomAppBar().paddingSymmetric(horizontal: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      vSpaceMedium,
                      Text(
                        isAddAccount ? 'text010.2'.tr : 'text010'.tr,
                        textAlign: TextAlign.center,
                        style: kHeading3Style.copyWith(
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                            fontSize: 60),
                      ),
                      Text(
                        isAddAccount ? 'text011.2'.tr : 'text011'.tr,
                        textAlign: TextAlign.center,
                        style: kBodyStyle.copyWith(
                            fontSize: 22, fontWeight: FontWeight.w600,color: const Color(0xFF565656)),
                      ),
                      vSpaceMassive,
                      const ChildControllerWidget(),
                      vSpaceMedium,
                      AddChildWidget(
                        isAddAccount: isAddAccount,
                      ),
                    ],
                  ).paddingSymmetric(horizontal: kTabPaddingHorizontal),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBody(SignUpViewModel vm, BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(kImgUnionPng2), fit: BoxFit.cover),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              const CustomAppBar().paddingSymmetric(horizontal: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      vSpaceLarge,
                      Text(
                        isAddAccount ? 'text010.2'.tr : 'text010'.tr,
                        style: kHeading3Style.copyWith(
                            fontWeight: FontWeight.w700, color: Colors.black),
                      ),
                      Text(
                        isAddAccount ? 'text011.2'.tr: 'text011'.tr,
                        style: kBodyStyle.copyWith(
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF565656)),
                      ).paddingOnly(right: 48),
                      vSpaceMassive,
                      const ChildControllerWidget(),
                      AddChildWidget(
                        isAddAccount: isAddAccount,
                      ),
                    ],
                  ).paddingSymmetric(horizontal: 24),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
