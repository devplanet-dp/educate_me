import 'package:educate_me/core/shared/ui_helpers.dart';
import 'package:educate_me/data/lesson.dart';
import 'package:educate_me/features/student/lesson/components/practice_question_view.dart';
import 'package:educate_me/features/student/lesson/lesson_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';

import '../../../../core/widgets/busy_button.dart';


class LessonContentPageView extends ViewModelWidget<LessonViewModel> {
  const LessonContentPageView({
    Key? key,
    required this.lesson,
    required this.levelId,
    required this.topicId,
    required this.subTopicId,
  }) : super(key: key);
  final String levelId;
  final String topicId;
  final String subTopicId;
  final LessonModel lesson;

  @override
  Widget build(BuildContext context, LessonViewModel model) {

    return Expanded(
      child: PageView(
        controller: model.barrierController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index){
          model.resetScroll();
        },
        children: List.generate(
            lesson.content?.length ?? 0,
            (index) => SingleChildScrollView(
                  child: Column(
                    children: [
                      LessonBarrierView(content: lesson.content?[index] ?? ''),
                      vSpaceMedium,
                      BoxButtonWidget(
                        radius: 8,
                        buttonText:
                            '${'text093'.tr}(${index + 1}/${lesson.content?.length})',
                        onPressed: () => model.goToNextBarrier(),
                      ),
                      vSpaceMedium,
                    ],
                  ),
                ))
          ..add(PracticeQuestionView(
              levelId: levelId,
              topicId: topicId,
              subTopicId: subTopicId,
              lesson: lesson)),
      ),
    );
  }
}
class LessonBarrierView extends StatelessWidget {
  const LessonBarrierView({Key? key, required this.content}) : super(key: key);
  final String content;

  @override
  Widget build(BuildContext context) {
    return HtmlWidget(
      content,
      webView: true,
      webViewJs: true,
    );
  }
}
