import 'package:educate_me/features/student/quiz/quiz_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';

import '../../../../core/shared/app_colors.dart';
import '../../../../core/shared/shared_styles.dart';

class QuizResultsWidget extends ViewModelWidget<QuizViewModel> {
  const QuizResultsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, QuizViewModel model) {
    return Text.rich(TextSpan(
        text: 'text054'.tr,
        style: kBodyStyle.copyWith(
            color: Colors.black, fontWeight: FontWeight.w500),
        children: [
          TextSpan(
              text:
                  ' ${model.noCorrectAns()}/${model.questions.length}',
              style: kBodyStyle.copyWith(
                  color: kcPrimaryColor, fontWeight: FontWeight.w500))
        ]));
  }
}
