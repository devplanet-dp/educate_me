import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../../core/shared/app_colors.dart';
import '../../../../core/shared/shared_styles.dart';
import '../../../../core/shared/ui_helpers.dart';
import '../quiz_view_model.dart';

class PageNavigationWidget extends ViewModelWidget<QuizViewModel> {
  const PageNavigationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, QuizViewModel model) {
    return model.questions.isEmpty
        ? emptyBox()
        : [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: model.isFirstPage()?IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Iconsax.arrow_circle_left,
                    size: 26,
                    color:Colors.transparent,
                  ))
:              IconButton(
                  onPressed: () => model.goToPrvQn(),
                  icon: const Icon(
                    Iconsax.arrow_circle_left,
                    size: 26,
                    color: Colors.black,
                  )),
            ),
            Text.rich(TextSpan(
                text: 'Question:',
                style: kBodyStyle.copyWith(
                    color: Colors.black, fontWeight: FontWeight.w600),
                children: [
                  TextSpan(
                      text: ' ${model.qnNo}/${model.questions.length}',
                      style: kBodyStyle.copyWith(
                          color: kcPrimaryColor, fontWeight: FontWeight.w600))
                ])),
            //show when answered
            (model.isLastQn() || !model.allowNextPage)
                ? IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Iconsax.arrow_circle_right,
                      size: 26,
                      color: Colors.transparent,
                    ))
                : IconButton(
                    onPressed: (){

                      model.goToNextQn();

                    },
                    icon: const Icon(
                      Iconsax.arrow_circle_right,
                      size: 26,
                      color: Colors.black,
                    )),
          ].toRow(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center);
  }
}
