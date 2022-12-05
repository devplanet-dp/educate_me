import 'package:educate_me/core/shared/app_colors.dart';
import 'package:educate_me/core/shared/shared_styles.dart';
import 'package:educate_me/core/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../core/utils/constants/app_assets.dart';
import '../signin/components/custom_app_bar.dart';
import '../student/navigation/navigation_view_model.dart';

class AboutView extends StatelessWidget {
  const AboutView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NavigationViewModel>.reactive(
      builder: (context, vm, child) => Scaffold(
        backgroundColor: kcBg,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: SwitchUserAppBar(
            title: 'text051'.tr,
            onUserUpdated: () {
              vm.initChildAccountDetails();
            },
          ),
        ),
        body: ResponsiveBuilder(builder: (context, _) {
          return SingleChildScrollView(
            padding: _.isTablet ? fieldPaddingTablet : fieldPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                vSpaceMedium,
                Image.asset(
                  kImgAbout,
                  height: 108.h,
                  width: 110.w,
                ).center(),
                vSpaceMedium,
                Text(
                  'text076'.tr,
                  style: kBodyStyle.copyWith(
                      fontSize: _.isTablet ? 18 : 16,
                      color: kcTextAbout,
                      fontWeight:
                          _.isTablet ? FontWeight.w600 : FontWeight.w400),
                ),
                vSpaceMedium,
              ],
            ),
          );
        }),
      ),
      viewModelBuilder: () => NavigationViewModel(),
    );
  }
}
