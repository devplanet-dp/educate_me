import 'package:educate_me/core/shared/shared_styles.dart';
import 'package:educate_me/core/shared/ui_helpers.dart';
import 'package:educate_me/core/utils/constants/app_assets.dart';
import 'package:educate_me/features/student/drawing/drawing_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../core/shared/app_colors.dart';
import '../../../core/widgets/busy_button.dart';
import 'custom_drawing.dart';

class DrawQnsView extends StatelessWidget {
  const DrawQnsView({Key? key, required this.question, required this.qid})
      : super(key: key);
  final String question;
  final String qid;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DrawingViewModel>.reactive(
      builder: (context, vm, child) => ResponsiveBuilder(builder: (context, _) {
        return Dialog(
          elevation: 0,
          insetPadding: EdgeInsets.symmetric(
              horizontal: _.isTablet ? kTabPaddingHorizontal * .8 : 16),
          backgroundColor: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                question,
                textAlign: TextAlign.center,
                style: kBodyStyle.copyWith(fontSize: _.isTablet?24:16),
              )
                  .center()
                  .paddingAll(16)
                  .card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              _.isTablet ? kBorderMedium : kBorderSmall),
                      clipBehavior: Clip.antiAlias)
                  .width(_.isTablet ? Get.width * .45 : Get.width),
              vSpaceMedium,
              Draw(
                qid: qid,
              ).card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                      borderRadius: _.isTablet ? kBorderLarge : kBorderSmall),
                  clipBehavior: Clip.antiAlias),
            ],
          ),
        );
      }),
      viewModelBuilder: () => DrawingViewModel(),
    );
  }
}

class DisableDraw extends StatelessWidget {
  const DisableDraw({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, _) {
      return Dialog(
        elevation: 0,
        insetPadding: EdgeInsets.symmetric(
            horizontal: _.isTablet ? kTabPaddingHorizontal : 24),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: kBorderMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              kIcBrush,
              fit: BoxFit.contain,
              height: _.isTablet ? 180 : 88.h,
              width: _.isTablet ? 180 : 88.h,
            ),
            vSpaceSmall,
            Text(
              'Sorry!',
              style: kHeading3Style.copyWith(
                  fontWeight: FontWeight.w700, fontSize: _.isTablet ? 48 : 25),
            ),
            vSpaceSmall,
            Text(
              'text092'.tr,
              textAlign: TextAlign.center,
              style: kCaptionStyle.copyWith(
                  color: kcTextGrey, fontSize: _.isTablet ? 20 : 15),
            ),
            vSpaceSmall,
            BoxButtonWidget(
                    buttonText: 'text079'.tr,
                    radius: 8,
                    onPressed: () => Get.back())
                .paddingSymmetric(horizontal: _.isTablet ? 130 : 48),
            vSpaceSmall
          ],
        ).paddingAll(16),
      );
    });
  }
}
