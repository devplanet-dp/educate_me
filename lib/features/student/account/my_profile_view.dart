import 'package:educate_me/core/shared/shared_styles.dart';
import 'package:educate_me/core/shared/ui_helpers.dart';
import 'package:educate_me/features/student/navigation/navigation_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../core/shared/app_colors.dart';
import '../../../core/utils/device_utils.dart';
import '../../../core/widgets/text_field_widget.dart';
import '../../../core/widgets/two_row_button.dart';
import '../navigation/navigation_view_model.dart';

class MyProfileView extends StatelessWidget {
  const MyProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NavigationViewModel>.reactive(
      onModelReady: (model) {
        model.setProfiles();
      },
      builder: (context, vm, child) => GestureDetector(
        onTap: () => DeviceUtils.hideKeyboard(context),
        child: ResponsiveBuilder(builder: (context, _) {
          return WillPopScope(
              child: Scaffold(
                backgroundColor: kcBg,
                bottomNavigationBar: TwoRowButton(
                  onPositiveTap: () => vm.updateMyProfiles(),
                  onNegativeTap: () => Get.offAll(() => const NavigationView(
                        initialIndex: 2,
                      )),
                  negativeText: 'text043'.tr,
                  positiveText: 'text065'.tr,
                  isBusy: vm.isBusy,
                ).paddingSymmetric(
                    horizontal: _.isTablet ? kTabPaddingHorizontal : 0),
                appBar: AppBar(
                  elevation: 0,
                  automaticallyImplyLeading: true,
                  backgroundColor: Colors.white,
                  title: Text(
                    'text104'.tr,
                    style: kSubheadingStyle.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: _.isTablet ? 32 : 20),
                  ),
                  centerTitle: true,
                ),
                body: const ChildProfilesWidget(),
              ),
              onWillPop: () async {
                Get.offAll(() => const NavigationView(
                      initialIndex: 2,
                    ));
                return true;
              });
        }),
      ),
      viewModelBuilder: () => NavigationViewModel(),
    );
  }
}

class ChildProfilesWidget extends ViewModelWidget<NavigationViewModel> {
  const ChildProfilesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, NavigationViewModel model) {
    return ResponsiveBuilder(builder: (context, _) {
      return Form(
        key: model.formKey,
        child: ListView.separated(
          itemCount: model.childCount.length,
          shrinkWrap: true,
          separatorBuilder: (_, __) => vSpaceMedium,
          itemBuilder: (_, index) => _inputFields(model, index)
              .paddingSymmetric(
                  horizontal: _.isTablet ? kTabPaddingHorizontal : 16),
        ),
      );
    });
  }

  Widget _inputFields(NavigationViewModel model, int index) =>
      Builder(builder: (context) {
        var controller = model.childCount[index];
        return [
          AppTextField(
            controller: controller.nameTEC,
            hintText: 'Profile name - ${index + 1}',
            label: '',
            validator: (value) {
              if (value!.isEmpty) {
                return 'Enter profile name';
              } else if (!GetUtils.isAlphabetOnly(value)) {
                return 'You cannot have a number in the name';
              }
              return null;
            },
          ),
          AppTextField(
              controller: controller.ageTEC,
              hintText: 'Profile age - ${index + 1}',
              isNumber: true,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter age';
                }
                return null;
              },
              label: ''),
        ].toColumn();
      });
}
