import 'package:educate_me/core/shared/shared_styles.dart';
import 'package:educate_me/core/shared/ui_helpers.dart';
import 'package:educate_me/core/widgets/busy_button.dart';
import 'package:educate_me/core/widgets/text_field_widget.dart';
import 'package:educate_me/features/student/navigation/navigation_view_model.dart';
import 'package:educate_me/features/student/navigation/navigation_view_model.dart';
import 'package:educate_me/features/student/support/support_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        child: Scaffold(
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
                const Spacer(),
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
                vSpaceSmall,
                AppTextFieldSecondary(
                    controller: vm.emailTEC,
                    isEmail: true,
                    hintText: 'text004'.tr,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'text004'.tr;
                      }
                      return null;
                    },
                    label: 'text003'.tr),
                vSpaceSmall,
                AppTextFieldSecondary(
                    controller: vm.messageTEC,
                    minLine: 3,
                    hintText: 'text068'.tr,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'text068'.tr;
                      }
                      return null;
                    },
                    label: 'text067'.tr),
                const Spacer(
                  flex: 4,
                ),
                BoxButtonWidget(
                    buttonText: 'text072'.tr,
                    radius: 8,
                    isLoading: vm.isBusy,
                    onPressed: () => vm.onSendPressed()),
                const Spacer(),
              ],
            ).paddingSymmetric(horizontal: 16),
          ),
        ),
      ),
      viewModelBuilder: () => NavigationViewModel(),
    );
  }
}
