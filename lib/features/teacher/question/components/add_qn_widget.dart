import 'package:educate_me/data/question.dart';
import 'package:educate_me/features/teacher/question/components/qns_index_widget.dart';
import 'package:educate_me/features/teacher/question/qns_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../../core/shared/app_colors.dart';
import '../../../../core/shared/shared_styles.dart';
import '../../../../core/shared/ui_helpers.dart';

class AddQnWidget extends ViewModelWidget<QnsViewModel> {
  final Question qns;

  const AddQnWidget(this.qns, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, QnsViewModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        QnsIndexWidget(index: qns.index),
        hSpaceSmall,
        Text(
          qns.qns.isEmpty ? 'Add answer here' : qns.qns,
          style: kBody1Style,
        ),
      ],
    ).paddingAll(4).card(
        color: qns.qns.isEmpty
            ? kcPrimaryColor.withOpacity(.2)
            : qns.isCorrect
                ? kcCorrectAns
                : kcIncorrectAns,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: kBorderSmall));
  }
}
