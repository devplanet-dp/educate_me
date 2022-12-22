import 'package:educate_me/core/shared/app_colors.dart';
import 'package:educate_me/core/shared/shared_styles.dart';
import 'package:educate_me/core/shared/ui_helpers.dart';
import 'package:educate_me/core/utils/constants/app_assets.dart';
import 'package:educate_me/features/student/stats/stat_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

class StatCardTile extends ViewModelWidget<StatViewModel> {
  const StatCardTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, StatViewModel model) {
    return ResponsiveBuilder(builder: (context, _) {
      return [
        Image.asset(
          kIcAchievement,
          fit: BoxFit.contain,
          height: _.isTablet ? 160 : 111.h,
          width: _.isTablet ? 180 : 79.w,
        ),
        hSpaceSmall,
        Expanded(
          child: [
            Text(
              'Level1',
              style: kBodyStyle.copyWith(
                fontSize: _.isTablet?24:16,
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
            vSpaceSmall,
            Text(
              'Congratulations! You’re now on Intermediate level',
              style: kBody1Style.copyWith(color: Colors.white,fontSize: _.isTablet?17.5:15),
            ),
            vSpaceSmall,
            _buildUserProgress(_.isTablet),
            vSpaceSmall,
          ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),
        )
      ].toRow().paddingAll(16).decorated(
        boxShadow: [
          const BoxShadow(
            color: kcPrimaryColor,
            blurRadius: 9,
            offset: Offset(0, 1), // Shadow position
          ),
        ],
        color: kcCardBgColor,
        image: const DecorationImage(
            image: AssetImage(kImgCard), fit: BoxFit.cover),
      ).clipRRect(all: 10);
    });
  }

  Widget _buildUserProgress(bool isTab) => [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height:isTab?15: 10,
              child: LinearProgressIndicator(
                value: 0.45, // percent filled
                valueColor: const AlwaysStoppedAnimation<Color>(kcAccent),
                backgroundColor: kcAccent.withOpacity(.4),
              ),
            ),
          ),
        ),
        hSpaceSmall,
        Text(
          '45%',
          style: kBodyStyle.copyWith(color: Colors.white),
        )
      ].toRow();
}
