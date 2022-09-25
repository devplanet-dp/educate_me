import 'package:auto_size_text/auto_size_text.dart';
import 'package:educate_me/core/shared/app_colors.dart';
import 'package:educate_me/core/shared/shared_styles.dart';
import 'package:educate_me/core/shared/ui_helpers.dart';
import 'package:educate_me/core/utils/constants/app_assets.dart';
import 'package:educate_me/features/student/stats/stat_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

class TotalAnswerCard extends ViewModelWidget<StatViewModel> {
  const TotalAnswerCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, StatViewModel model) {
    return ListTile(
      title: Text(
        'text032'.tr,
        style: kBody1Style.copyWith(color: kcTextDarkGrey),
      ),
      leading: SvgPicture.asset(kIcAsk),
      subtitle: Text(
        '${model.controller.currentChild?.stats?.totalAnswered ?? 0}',
        style: kHeading3Style.copyWith(
            color: Colors.black, fontWeight: FontWeight.bold),
      ),
    ).decorated(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: kcTextGrey.withOpacity(.2),
          blurRadius: 9,
          offset: const Offset(0, 1), // Shadow position
        ),
      ],
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
    return [
      vSpaceSmall,
      SvgPicture.asset(image),
      vSpaceSmall,
      AutoSizeText(
        title.tr,
        textAlign: TextAlign.center,
        maxLines: 1,
        style: kBody1Style.copyWith(color: kcTextDarkGrey),
      ),
      vSpaceSmall,
      Text(
        '$amount',
        style: kHeading3Style.copyWith(
            color: Colors.black, fontWeight: FontWeight.bold),
      )
    ]
        .toColumn(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min).paddingSymmetric(horizontal: 26.w,vertical: 10)
        .decorated(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: kcTextGrey.withOpacity(.2),
          blurRadius: 9,
          offset: const Offset(0, 1), // Shadow position
        ),
      ],
    );
  }
}
