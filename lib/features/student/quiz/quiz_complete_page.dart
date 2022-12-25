import 'package:educate_me/core/shared/app_colors.dart';
import 'package:educate_me/core/shared/shared_styles.dart';
import 'package:educate_me/data/controllers/quiz_controller.dart';
import 'package:educate_me/features/student/quiz/quiz_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

class QuizCompletePage extends ViewModelWidget<QuizViewModel> {
  const QuizCompletePage(
      {Key? key,
      required this.levelId,
      required this.topicId,
      required this.subTopicId,
      required this.lessonId,
      required this.drawEnabled})
      : super(key: key);
  final String levelId;
  final String topicId;
  final String subTopicId;
  final String lessonId;
  final bool drawEnabled;

  @override
  Widget build(BuildContext context, QuizViewModel model) {
    return ResponsiveBuilder(builder: (context, _) {
      return GridView.count(
        crossAxisCount: 4,
        shrinkWrap: true,
        crossAxisSpacing: 8,
        mainAxisSpacing: 16,
        childAspectRatio:_.isTablet?1.5 :1.2,
        children: List.generate(
            model.ans.length,
            (index) => InkWell(
                  onTap: () {
                    model.selectedQn = model.questions[index];
                    model.goToPage(index);
                  },
                  child: Text(
                    '${model.ans[index].qIndex}',
                    style: kSubheadingStyle.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: _.isTablet?32:20,
                        color: model.ans[index].isCorrect
                            ? kcCorrectAns
                            : kcIncorrectAns),
                  ).center().decorated(boxShadow: [
                    BoxShadow(
                      color: kcTextGrey.withOpacity(0.2),
                      spreadRadius: 4,
                      blurRadius: 4,
                      offset: const Offset(2, 3), // changes position of shadow
                    ),
                  ], color: Colors.white, shape: BoxShape.circle),
                )),
      )
          .paddingAll(_.isTablet?8:16)
          .paddingSymmetric(horizontal: _.isTablet ? Get.width*0.32 : 0)
          .center();
    });
  }
}
