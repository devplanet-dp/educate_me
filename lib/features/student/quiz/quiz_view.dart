import 'package:educate_me/core/shared/ui_helpers.dart';
import 'package:educate_me/core/widgets/app_info.dart';
import 'package:educate_me/core/widgets/busy_button.dart';
import 'package:educate_me/data/lesson.dart';
import 'package:educate_me/features/student/quiz/components/page_navigation_widget.dart';
import 'package:educate_me/features/student/quiz/components/page_progress_widget.dart';
import 'package:educate_me/features/student/quiz/components/quiz_result_widget.dart';
import 'package:educate_me/features/student/quiz/quiz_complete_page.dart';
import 'package:educate_me/features/student/quiz/quiz_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../core/utils/device_utils.dart';
import 'components/quetion_card.dart';

class QuizView extends StatelessWidget {
  const QuizView(
      {Key? key,
      required this.levelId,
      required this.topicId,
      required this.subTopicId,
      required this.lesson})
      : super(key: key);
  final String levelId;
  final String topicId;
  final String subTopicId;
  final LessonModel lesson;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<QuizViewModel>.reactive(
      onModelReady: (model) {
        model.getQuestions(
            levelId: levelId,
            topicId: topicId,
            subTopicId: subTopicId,
            lessonId: lesson.id ?? '');
      },
      builder: (context, vm, child) => GestureDetector(
        onTap: () => DeviceUtils.hideKeyboard(context),
        child: Scaffold(
          bottomNavigationBar: !vm.isLastPage()
              ? emptyBox()
              : Container(
                  child: BoxButtonWidget(
                    radius: 8,
                    isLoading: vm.isBusy,
                    buttonText: 'text055'.tr,
                    onPressed: () => vm.finishExam(lesson: lesson),
                  ).paddingSymmetric(horizontal: 16, vertical: 8),
                ),
          appBar: AppBar(
            title: Text(
                '${vm.quizController.currentLevel?.name}: ${vm.quizController.currentTopicName}'),
          ),
          body: vm.isBusy
              ? const ShimmerQuiz()
              : Column(
                  children: [
                    vSpaceMedium,
                    vm.isLastPage()
                        ? emptyBox()
                        : const PageProgressWidget()
                            .paddingSymmetric(horizontal: 16),
                    vSpaceMedium,
                    vm.isLastPage()
                        ? const QuizResultsWidget()
                        : const PageNavigationWidget(),
                    vSpaceMedium,
                    vm.questions.isEmpty
                        ? AppInfoWidget(
                                translateKey: 'text053'.tr,
                                iconData: Iconsax.book_1)
                            .center()
                        : Expanded(
                            child: PageView(
                            controller: vm.pageController,
                            physics: const NeverScrollableScrollPhysics(),
                            onPageChanged: (index) {
                              if(!vm.isLastPage()) {
                                vm.selectedQn = vm.questions[index];
                              }
                            },
                            children: List.generate(vm.questions.length,
                                (index) => const QuestionCard())
                              ..add(const QuizCompletePage()),
                          ))
                  ],
                ),
        ),
      ),
      viewModelBuilder: () => QuizViewModel(),
    );
  }
}
