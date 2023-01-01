import 'package:educate_me/core/shared/app_colors.dart';
import 'package:educate_me/core/shared/shared_styles.dart';
import 'package:educate_me/core/shared/ui_helpers.dart';
import 'package:educate_me/core/utils/constants/app_assets.dart';
import 'package:educate_me/features/student/stats/stat_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

class TotalAnswerCard extends ViewModelWidget<StatViewModel> {
  const TotalAnswerCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, StatViewModel model) {
    return ResponsiveBuilder(
      builder: (context,_) {
        return Row(
          children: [
            SvgPicture.asset(
              kIcAsk,
              width: 32,
              height: 32,
            ).paddingAll(16),
            Expanded(
              child: [
                Text(
                  'text032'.tr,

                  style: kBody1Style.copyWith(color: kcTextDarkGrey,fontSize: _.isTablet ? 18 : 15,
                    fontWeight: FontWeight.w500,),
                ),
                Text(
                  '${model.controller.currentChild?.stats?.totalAnswered ?? 0}',
                  style: kHeading3Style.copyWith(
                      color: Colors.black, fontWeight: FontWeight.bold),
                )
              ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),
            )
          ],
        ).paddingSymmetric(vertical: 12).decorated(
          color: Colors.white,
          borderRadius: kBorderSmall,
          boxShadow: [
            BoxShadow(
              color: kcTextGrey.withOpacity(.2),
              blurRadius: 9,
              offset: const Offset(0, 1), // Shadow position
            ),
          ],
        );
      }
    );
  }
}

class Answers extends ViewModelWidget<StatViewModel> {
  const Answers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, StatViewModel model) {
    return [
      Expanded(
        child: _AnswerCard(
            title: 'text033'.tr,
            image: kIcCorrect,
            amount: model.controller.currentChild?.stats?.totalCorrect ?? 0),
      ),
      hSpaceSmall,
      Expanded(
        child: _AnswerCard(
            title: 'text036'.tr,
            image: kIcWrong,
            amount: model.controller.currentChild?.stats?.totalIncorrect ?? 0),
      ),
    ].toRow();
  }
}

class _AnswerCard extends StatelessWidget {
  const _AnswerCard(
      {Key? key,
      required this.title,
      required this.image,
      required this.amount})
      : super(key: key);
  final String title;
  final String image;
  final int amount;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, _) {
      return [
        vSpaceSmall,
        SvgPicture.asset(
          image,
          width: _.isTablet ? 37 : 25.w,
          height: _.isTablet ? 57 : 39.h,
        ),
        vSpaceMedium,
        Text(
          title.tr,
          textAlign: TextAlign.center,
          maxLines: 1,
          style: kBody1Style.copyWith(
              color: kcTextDarkGrey,
              fontWeight: FontWeight.w500,
              fontSize: _.isTablet ? 18 : 15),
        ),
        vSpaceSmall,
        Text(
          '$amount',
          style: kHeading3Style.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w900,
              fontSize: _.isTablet ? 25 : 20.sp),
        )
      ]
          .toColumn(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min)
          .paddingSymmetric(horizontal: 26.w, vertical: 10)
          .decorated(
        color: Colors.white,
        borderRadius: kBorderSmall,
        boxShadow: [
          BoxShadow(
            color: kcTextGrey.withOpacity(.2),
            blurRadius: 9,
            offset: const Offset(0, 1), // Shadow position
          ),
        ],
      );
    });
  }
}
