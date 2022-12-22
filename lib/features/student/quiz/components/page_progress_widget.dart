import 'package:educate_me/core/shared/shared_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
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
        : ResponsiveBuilder(builder: (context, _) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                height: _.isTablet ? 15 : 10,
                child: LinearProgressIndicator(
                  value: model.qnNo / model.questions.length,
                  // percent filled
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(kcPrimaryColor),
                  backgroundColor: kcPrimaryColor.withOpacity(.4),
                ),
              ),
            ).paddingSymmetric(
                horizontal: _.isTablet ? kTabPaddingHorizontal - 48 : 0);
          });
  }
}
