import 'package:auto_size_text/auto_size_text.dart';
import 'package:educate_me/core/shared/app_colors.dart';
import 'package:educate_me/core/shared/shared_styles.dart';
import 'package:educate_me/core/utils/app_utils.dart';
import 'package:educate_me/core/widgets/busy_button.dart';
import 'package:educate_me/features/signin/components/custom_app_bar.dart';
import 'package:educate_me/features/student/stats/components/stat_card.dart';
import 'package:educate_me/features/student/stats/components/answer_card.dart';
import 'package:educate_me/features/student/stats/stat_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      builder: (context, vm, child) =>
          GestureDetector(
            onTap: () => DeviceUtils.hideKeyboard(context),
            child: SafeArea(
              child: Scaffold(
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight),
                  child: SwitchUserAppBar(
                    title: 'text020'.tr,
                    onUserUpdated:()=>vm.notifyListeners(),
                  ),
                ),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    AutoSizeText(
                      controller.currentChild?.name ?? '',
                      maxLines: 1,
                      style: kHeading3Style.copyWith(
                          fontWeight: FontWeight.w700),
                    ).center(),
                    Text(
                      'text031'.tr,
                      style: kBody1Style.copyWith(color: kcTextGrey),
                    ),
                    const Spacer(),
                    const StatCardTile(),
                    const Spacer(),
                    const TotalAnswerCard(),
                    const Spacer(),
                    const Answers(),
                    const Spacer(),
                    BoxButtonWidget(
                      buttonText: 'text042'.tr, onPressed: () {}, radius: 8,),
                    Text('text041'.tr,
                      style: kLabelStyle.copyWith(color: kcTextDarkGrey),),
                    const Spacer(flex: 3,)
                  ],
                ).paddingSymmetric(horizontal: 12),
              ),
            ),
          ),
      viewModelBuilder: () => StatViewModel(),
    );
  }
}
