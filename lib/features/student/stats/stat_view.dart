import 'package:auto_size_text/auto_size_text.dart';
import 'package:educate_me/core/shared/app_colors.dart';
import 'package:educate_me/core/shared/shared_styles.dart';
import 'package:educate_me/core/shared/ui_helpers.dart';
import 'package:educate_me/core/widgets/busy_button.dart';
import 'package:educate_me/features/signin/components/custom_app_bar.dart';
import 'package:educate_me/features/student/stats/components/answer_card.dart';
import 'package:educate_me/features/student/stats/components/stat_card.dart';
import 'package:educate_me/features/student/stats/stat_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../core/utils/app_controller.dart';
import '../../../core/utils/device_utils.dart';

class StatView extends StatelessWidget {
  const StatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppController controller = Get.find<AppController>();

    return ViewModelBuilder<StatViewModel>.reactive(
      builder: (context, vm, child) => GestureDetector(
        onTap: () => DeviceUtils.hideKeyboard(context),
        child: ResponsiveBuilder(
          builder: (context,_) {
            return Scaffold(
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight),
                  child: SwitchUserAppBar(
                    title: 'text020'.tr,
                    onUserUpdated: () => vm.notifyListeners(),
                  ),
                ),
                body: SingleChildScrollView(
                  padding: _.isTablet?fieldPaddingTablet: fieldPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        height: 21.h,
                      ),
                      AutoSizeText(
                        'Hey ${controller.currentChild?.name ?? ''}!',
                        maxLines: 1,
                        style: kHeading3Style.copyWith(fontWeight:_.isTablet?FontWeight.w900: FontWeight.w700,fontSize:_.isTablet?32:25 ),
                      ).center(),
                      Text(
                        'text031'.tr,
                        style: kBody1Style.copyWith(color: kcTextGrey,fontSize: _.isTablet?24:15),
                      ),
                      vSpaceMedium,
                      const StatCardTile(),
                      vSpaceMedium,
                      const TotalAnswerCard(),
                      vSpaceMedium,
                      const Answers(),
                      vSpaceMedium,
                      BoxButtonWidget(
                        buttonText: 'text042'.tr,
                        isLoading: vm.isBusy,
                        onPressed: () => vm.retest(),
                        radius: 8,
                      ),
                      const SizedBox(height: 5,),
                      Text(
                        'text041'.tr,
                        textAlign: TextAlign.center,
                        style: kLabelStyle.copyWith(
                            color: kcTextDarkGrey,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.italic,
                            fontSize: _.isTablet?14: 10.sp),
                      ),
                      vSpaceMedium
                    ],
                  ),
                ));
          }
        ),
      ),
      viewModelBuilder: () => StatViewModel(),
    );
  }
}
