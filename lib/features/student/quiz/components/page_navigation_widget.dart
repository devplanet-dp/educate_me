import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:responsive_builder/responsive_builder.dart';
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
        : ResponsiveBuilder(
          builder: (context,_) {
            return [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: model.isFirstPage()?IconButton(
                      onPressed: () {},
                      icon:  Icon(
                        Iconsax.arrow_circle_left,
                        size:_.isTablet?32: 26,
                        color:Colors.transparent,
                      ))
:              IconButton(
                      onPressed: () => model.goToPrvQn(),
                      icon:  Icon(
                        Iconsax.arrow_circle_left,
                        size:_.isTablet?32: 26,
                        color: Colors.black,
                      )),
                ),
                Text.rich(TextSpan(
                    text: 'Question:',
                    style: kBodyStyle.copyWith(
                        color: Colors.black, fontWeight: FontWeight.w600,fontSize: _.isTablet?24:16),
                    children: [
                      TextSpan(
                          text: ' ${model.qnNo}/${model.questions.length}',
                          style: kBodyStyle.copyWith(
                              color: kcPrimaryColor, fontWeight: FontWeight.w600,fontSize: _.isTablet?24:16))
                    ])),
                //show when answered
                (model.isLastQn() || !model.allowNextPage)
                    ? IconButton(
                        onPressed: () {},
                        icon:  Icon(
                          Iconsax.arrow_circle_right,
                          size:_.isTablet?32: 26,
                          color: Colors.transparent,
                        ))
                    : IconButton(
                        onPressed: (){

                          model.goToNextQn();

                        },
                        icon:  Icon(
                          Iconsax.arrow_circle_right,
                          size:_.isTablet?32: 26,
                          color: Colors.black,
                        )),
              ].toRow(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center);
          }
        );
  }
}
