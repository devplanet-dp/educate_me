import 'package:educate_me/core/shared/app_colors.dart';
import 'package:educate_me/core/shared/shared_styles.dart';
import 'package:educate_me/core/shared/ui_helpers.dart';
import 'package:educate_me/features/student/quiz/quiz_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../core/utils/device_utils.dart';

class QuizView extends StatelessWidget {
  const QuizView(
      {Key? key,
      required this.levelId,
      required this.topicId,
      required this.subTopicId,
      required this.lessonId})
      : super(key: key);
  final String levelId;
  final String topicId;
  final String subTopicId;
  final String lessonId;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<QuizViewModel>.reactive(
      onModelReady: (model) {
        model.getQuestions(
            levelId: levelId,
            topicId: topicId,
            subTopicId: subTopicId,
            lessonId: lessonId);
      },
      builder: (context, vm, child) => GestureDetector(
        onTap: () => DeviceUtils.hideKeyboard(context),
        child: Scaffold(
          appBar: AppBar(
            title: Text('Level 1: Quize'),
          ),
          body: vm.isBusy
              ? const ShimmerQuiz()
              : Column(
                  children: [
                    vSpaceMedium,
                    const QnsProgressBar().paddingSymmetric(horizontal: 16),
                    vSpaceMedium,
                    const QnNavigationWidget(),
                    vSpaceMedium,
                    Expanded(
                        child: PageView(
                      controller: vm.pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      onPageChanged: (index) =>
                          vm.selectedQn = vm.questions[index],
                      children: List.generate(
                          vm.questions.length, (index) => const QuestionCard()),
                    ))
                  ],
                ),
        ),
      ),
      viewModelBuilder: () => QuizViewModel(),
    );
  }
}

class QnNavigationWidget extends ViewModelWidget<QuizViewModel> {
  const QnNavigationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, QuizViewModel model) {
    return [
      IconButton(
          onPressed: () => model.goToPrvQn(),
          icon: const Icon(Iconsax.arrow_circle_left)),
      Text.rich(TextSpan(
          text: 'Question:',
          style: kBodyStyle.copyWith(
              color: Colors.black, fontWeight: FontWeight.w500),
          children: [
            TextSpan(
                text: ' ${model.qnNo}/${model.questions.length}',
                style: kBodyStyle.copyWith(
                    color: kcPrimaryColor, fontWeight: FontWeight.w500))
          ])),
      IconButton(
          onPressed: () => model.goToNextQn(),
          icon: const Icon(Iconsax.arrow_circle_right)),
    ].toRow(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center);
  }
}

class QuestionCard extends ViewModelWidget<QuizViewModel> {
  const QuestionCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, QuizViewModel model) {
    return Column(
      children: [_buildQuestion(model.selectedQn?.question ?? '')],
    );
  }

  Widget _buildQuestion(String qns) => Text(qns).decorated().width(Get.width);
}

class QnsProgressBar extends ViewModelWidget<QuizViewModel> {
  const QnsProgressBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, QuizViewModel model) {
    return ClipRRect(
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
