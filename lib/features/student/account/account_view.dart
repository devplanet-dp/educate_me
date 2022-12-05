import 'package:educate_me/core/shared/shared_styles.dart';
import 'package:educate_me/core/widgets/two_row_button.dart';
import 'package:educate_me/features/student/navigation/navigation_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';

import '../../../core/shared/ui_helpers.dart';
import '../../../core/utils/device_utils.dart';
import '../../../core/widgets/text_field_widget.dart';
import '../../signin/components/custom_app_bar.dart';

class AccountView extends StatelessWidget {
  const AccountView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NavigationViewModel>.reactive(
      onModelReady: (model){
        model.initChildAccountDetails();
      },
      builder: (context, vm, child) => GestureDetector(
        onTap: () => DeviceUtils.hideKeyboard(context),
        child: ResponsiveBuilder(
          builder: (context,_) {
            return Scaffold(
              bottomNavigationBar: TwoRowButton(
                onPositiveTap: () =>vm.updateChildAccountDetails(),
                onNegativeTap: () => Get.back(),
                negativeText: 'text043'.tr,
                positiveText: 'text065'.tr,
                isBusy: vm.isBusy,
              ).paddingSymmetric(horizontal: _.isTablet?kTabPaddingHorizontal:0),
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight),
                child: SwitchUserAppBar(
                  title: 'text046'.tr,
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
                        controller: vm.ownerTECT,
                        hintText: 'text102'.tr,
                        fillColor: Colors.white,
                        isEnabled: false,
                        label: 'text102'.tr),
                    vSpaceMedium,
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
                        controller: vm.ageTEC,
                        isEmail: true,
                        isEnabled: true,
                        hintText: 'text077'.tr,
                        label: 'text077'.tr),
                    vSpaceSmall,
                    const Spacer(
                      flex: 7,
                    ),
                  ],
                ).paddingSymmetric(horizontal:_.isTablet?kTabPaddingHorizontal: 16),
              ),
            );
          }
        ),
      ),
      viewModelBuilder: () => NavigationViewModel(),
    );
  }
}
