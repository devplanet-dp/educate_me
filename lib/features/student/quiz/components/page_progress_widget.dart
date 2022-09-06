import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../../core/shared/app_colors.dart';
import '../../../../core/shared/ui_helpers.dart';
import '../quiz_view_model.dart';

class PageProgressWidget extends ViewModelWidget<QuizViewModel> {
  const PageProgressWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, QuizViewModel model) {
    return model.questions.isEmpty
        ? emptyBox()
        : ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        height: 10,
        child: LinearProgressIndicator(
          value: model.qnNo / model.questions.length,
          // percent filled
          valueColor: const AlwaysStoppedAnimation<Color>(kcPrimaryColor),
          backgroundColor: kcPrimaryColor.withOpacity(.4),
        ),
      ),
    );
  }
}
