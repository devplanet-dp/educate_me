import 'package:educate_me/core/shared/shared_styles.dart';
import 'package:educate_me/core/shared/ui_helpers.dart';
import 'package:educate_me/core/widgets/busy_button.dart';
import 'package:educate_me/core/widgets/text_field_widget.dart';
import 'package:educate_me/features/student/navigation/navigation_view_model.dart';
import 'package:educate_me/features/student/navigation/navigation_view_model.dart';
import 'package:educate_me/features/student/support/support_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';

import '../../../core/utils/device_utils.dart';
import '../../signin/components/custom_app_bar.dart';

class SupportView extends StatelessWidget {
  const SupportView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NavigationViewModel>.reactive(
      builder: (context, vm, child) => GestureDetector(
        onTap: () => DeviceUtils.hideKeyboard(context),
        child: SafeArea(
          top: false,
          child: ResponsiveBuilder(
            builder: (context,_) {
              return Scaffold(
                bottomNavigationBar:  BoxButtonWidget(
                    buttonText: 'text072'.tr,
                    radius: 8,
                    isLoading: vm.isBusy,
                    onPressed: () => vm.onSendPressed()).paddingOnly(left:_.isTablet?kTabPaddingHorizontal: 16,right:_.isTablet?kTabPaddingHorizontal: 16,bottom: 24),
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight),
                  child: SwitchUserAppBar(
                    title: 'text048'.tr,
                    onUserUpdated: (){
                      vm.initChildAccountDetails();
                    },
                  ),
                ),
                body: Form(
                  key: vm.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 22.h,),
                      AppTextFieldSecondary(
                          controller: vm.nameTEC,
                          hintText: 'text070'.tr,
                          fillColor: Colors.white,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'text070'.tr;
                            }
                            return null;
                          },
                          label: 'text071'.tr),
                      vSpaceMedium,
                      AppTextFieldSecondary(
                          controller: vm.emailTEC,
                          isEmail: true,
                          hintText: 'text004.hint'.tr,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'text004.hint'.tr;
                            }
                            return null;
                          },
                          label: 'text003'.tr),
                      vSpaceMedium,
                      AppTextFieldSecondary(
                          controller: vm.messageTEC,
                          minLine: 5,
                          hintText: 'text068.hint'.tr,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'text068.hint'.tr;
                            }
                            return null;
                          },
                          label: 'text067'.tr),
                    ],
                  ).paddingSymmetric(horizontal:_.isTablet?kTabPaddingHorizontal: 16),
                ),
              );
            }
          ),
        ),
      ),
      viewModelBuilder: () => NavigationViewModel(),
    );
  }
}
