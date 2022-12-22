import 'package:educate_me/core/shared/app_colors.dart';
import 'package:educate_me/core/shared/shared_styles.dart';
import 'package:educate_me/core/shared/ui_helpers.dart';
import 'package:educate_me/core/utils/app_utils.dart';
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
import 'package:responsive_builder/responsive_builder.dart';
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
        child: ResponsiveBuilder(builder: (context, _) {
          return WillPopScope(
            onWillPop: ()async{
              if(vm.quizController.isQuizCompleted){
                vm.goToPage(vm.questions.length+1);
                vm.quizController.isQuizCompleted=false;
                return false;
              }
              return true;
            },
            child: Scaffold(
              backgroundColor: kcBgQuiz,
              bottomNavigationBar: !vm.isLastPage() || vm.questions.isEmpty
                  ? emptyBox()
                  : Container(
                      child: BoxButtonWidget(
                        radius:_.isTablet?18: 8,
                        isLoading: vm.isBusy,
                        buttonText: 'text055'.tr,
                        onPressed: () => vm.finishExam(
                            lesson: lesson,
                            levelId: levelId,
                            topicId: topicId,
                            subTopicId: subTopicId),
                      ).paddingSymmetric(
                          horizontal: _.isTablet ? kTabPaddingHorizontal : 16,
                          vertical: 8),
                    ),
              appBar: AppBar(
                centerTitle: true,
                iconTheme: IconThemeData(size: _.isTablet ? 32 : 24),
                title: Text(
                  '${lesson.title} - ${vm.isLastPage()?'Results':'Quiz'}',
                  style: kSubheadingStyle.copyWith(
                      fontSize: _.isTablet ? 28 : 20,
                      fontWeight: _.isTablet ? FontWeight.w600 : FontWeight.w500),
                ),
              ),
              body: vm.isBusy
                  ? const ShimmerQuiz()
                  : vm.questions.isEmpty
                      ? AppInfoWidget(
                              translateKey: 'text053'.tr,
                              iconData: Iconsax.book_1)
                          .center()
                      : Column(
                          children: [
                            vSpaceMedium,
                            vm.isLastPage()
                                ? emptyBox()
                                : const PageProgressWidget()
                                    .paddingSymmetric(horizontal: 16),
                            const SizedBox(
                              height: 5,
                            ),
                            vm.quizController.isQuizCompleted
                                ? emptyBox()
                                : vm.isLastPage()
                                    ? const QuizResultsWidget()
                                    : const PageNavigationWidget(),
                            Expanded(
                                child: PageView(
                              pageSnapping: true,
                              physics: vm.allowNextPage
                                  ? const ClampingScrollPhysics()
                                  : const NeverScrollableScrollPhysics(),
                              controller: vm.pageController,
                              onPageChanged: (index) {
                                vm.onPageChanged(index + 1);

                                if (!vm.isLastPage()) {
                                  vm.selectedQn = vm.questions[index];
                                  vm.setAllowNextPage(index < vm.ans.length);
                                }
                                vm.setPreviousCheckedValues();
                              },
                              children: List.generate(
                                  vm.questions.length,
                                  (index) => QuestionCard(
                                        levelId: levelId,
                                        topicId: topicId,
                                        subTopicId: subTopicId,
                                        lessonId: lesson.id ?? '',
                                        drawEnabled:
                                            lesson.drawToolEnabled ?? false,
                                      ))
                                ..add(QuizCompletePage(
                                  levelId: levelId,
                                  topicId: topicId,
                                  subTopicId: subTopicId,
                                  lessonId: lesson.id ?? '',
                                  drawEnabled: false,
                                )),
                            ))
                          ],
                        ),
            ),
          );
        }),
      ),
      viewModelBuilder: () => QuizViewModel(),
    );
  }
}
