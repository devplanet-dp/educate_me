import 'package:educate_me/core/shared/shared_styles.dart';
import 'package:educate_me/core/shared/ui_helpers.dart';
import 'package:educate_me/core/utils/device_utils.dart';
import 'package:educate_me/core/widgets/busy_button.dart';
import 'package:educate_me/core/widgets/text_field_widget.dart';
import 'package:educate_me/data/lesson.dart';
import 'package:educate_me/data/question.dart';
import 'package:educate_me/features/student/lesson/lesson_view_model.dart';
import 'package:educate_me/features/student/quiz/components/draw_brush_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../../core/shared/app_colors.dart';

class PracticeQuestionView extends ViewModelWidget<LessonViewModel> {
  const PracticeQuestionView(
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
  Widget build(BuildContext context, LessonViewModel model) {
    return GestureDetector(
      onTap: () => DeviceUtils.hideKeyboard(context),
      child: ResponsiveBuilder(builder: (context, _) {
        return Scaffold(
          backgroundColor: kcBg,
          resizeToAvoidBottomInset: false,
          bottomNavigationBar: BoxButtonWidget(
              buttonText: 'text030'.tr,
              radius: _.isTablet ? 17 : 8,
              fontSize: _.isTablet ? 24 : 14,
              isEnabled: model.isQuizEnabled(-1) || lesson.questions!.isEmpty,
              onPressed: () => model.onStartQuizTapped(
                  levelId: levelId,
                  topicId: topicId,
                  subTopicId: subTopicId,
                  lesson: lesson)).paddingOnly(
              top: 16,
              left: _.isTablet ? kTabPaddingHorizontal * 1.2 : 16,
              bottom: 16,
              right: _.isTablet ? kTabPaddingHorizontal * 1.2 : 16),
          body: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (_, index) =>
                      _QnsCard(lesson.questions![index], index),
                  separatorBuilder: (_, index) => vSpaceMedium,
                  itemCount: lesson.questions?.length ?? 0)
              .paddingSymmetric(
                  horizontal: !_.isTablet ? 16 : kTabPaddingHorizontal,
                  vertical: 16),
        );
      }),
    );
  }
}

class _QnsCard extends ViewModelWidget<LessonViewModel> {
  _QnsCard(this.question, this.index, {Key? key}) : super(key: key);
  final QuestionModel question;
  final int index;
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context, LessonViewModel model) {
    final formKey = GlobalKey<FormState>();
    controller.text = model.getUserAnswerState(index) == AnswerState.checkAgain
        ? ''
        : model.getUserAnswer(index) ?? '';

    return Form(
      key: formKey,
      child: ResponsiveBuilder(builder: (context, _) {
        return Column(
          children: [
            vSpaceSmall,
            Text(
              'text094'.tr,
              textAlign: TextAlign.center,
              style: kCaptionStyle.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: _.isTablet ? 28 : 18),
            ),
            vSpaceMedium,
            Text(
              question.question ?? '',
              textAlign: TextAlign.center,
              style: kBodyStyle.copyWith(
                  fontWeight: FontWeight.w500, fontSize: _.isTablet ? 24 : 16),
            ).paddingAll(8).decorated(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: kcTextGrey.withOpacity(.2),
                  blurRadius: 9,
                  offset: const Offset(0, 1), // Shadow position
                ),
              ],
            ).width(Get.width),
            vSpaceMedium,
            [
              DrawBrushWidget(
                qns: question.question ?? '',
                enableDraw: true,
                qid: question.id ?? '',
                onDrawOpen: () {},
              ),
              hSpaceSmall,
              Expanded(child: Builder(builder: (context) {
                //reset answer field

                return ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 100.h),
                  child: AppTextFieldSecondary(
                    controller: controller,
                    isEnabled:
                        model.getUserAnswerState(index) == AnswerState.tryAgain
                            ? false
                            : !model.isQuizEnabled(index),
                    textColor: model.getButtonStyle(index)[index]['color'],
                    hintText: '        Answer',
                    align: TextAlign.center,
                    label: '',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter an answer';
                      }
                      return null;
                    },
                  ),
                );
              })),
              hSpaceSmall,
              Builder(builder: (context) {
                return Expanded(
                    child: BoxButtonWidget(
                  buttonText:
                      (model.getButtonStyle(index)[index]['text'] as String).tr,
                  radius: 8,
                  fontSize: _.isTablet ? 20 : 14,
                  buttonColor: model.getButtonStyle(index)[index]['color'],
                  onPressed: () {
                    //when try again clear the input
                    if (model.getUserAnswerState(index) ==
                        AnswerState.tryAgain) {
                      controller.text = '';
                      model.onRetryQuestion(index);
                      return;
                    }

                    ///check attempt count
                    if (!model.isAttemptExceeded(index)) {
                      if (formKey.currentState!.validate()) {
                        model.onQuestionAnswered(
                            text: controller.text,
                            index: index,
                            correctAnswer: question.options!
                                .where((o) => o.isCorrect ?? false)
                                .map((e) =>
                                    e.option?.trim().toLowerCase() ??
                                    'NO-ANSWER')
                                .toList());
                      }
                    }
                  },
                ));
              })
            ].toRow(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start),

            ///prompt text visible only when attempt count exceeds
            Visibility(
                visible: model.isAttemptExceeded(index) &&
                    model.getUserAnswerState(index) != AnswerState.correct,
                child: Text(
                  question.promptOne ?? '',
                  textAlign: TextAlign.center,
                  style: kBody1Style.copyWith(color: kcTextDarkGrey),
                )),
            Visibility(
                visible: model.getUserAnswerState(index) == AnswerState.correct,
                child: Text(
                  'text107'.tr,
                  textAlign: TextAlign.center,
                  style: kBody1Style.copyWith(color: kcTextDarkGrey),
                ))
          ],
        );
      }),
    );
  }
}
