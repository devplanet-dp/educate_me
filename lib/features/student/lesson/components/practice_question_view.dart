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
          resizeToAvoidBottomInset: false,
          bottomNavigationBar: BoxButtonWidget(
              buttonText: 'text030'.tr,
              radius: 8,
              isEnabled: model.isQuizEnabled() || lesson.questions!.isEmpty,
              onPressed: () => model.onStartQuizTapped(
                  levelId: levelId,
                  topicId: topicId,
                  subTopicId: subTopicId,
                  lesson: lesson)).paddingSymmetric(
              horizontal: _.isTablet ? kTabPaddingHorizontal : 0),
          body: Column(
            children: [
              Text(
                'text094'.tr,
                style: kCaptionStyle.copyWith(fontWeight: FontWeight.w600),
              ),
              Expanded(
                child: ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (_, index) =>
                            _QnsCard(lesson.questions![index], index),
                        separatorBuilder: (_, index) => vSpaceMedium,
                        itemCount: lesson.questions?.length ?? 0)
                    .paddingSymmetric(
                        horizontal: !_.isTablet ? 0 : kTabPaddingHorizontal),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _QnsCard extends ViewModelWidget<LessonViewModel> {
  const _QnsCard(this.question, this.index, {Key? key}) : super(key: key);
  final QuestionModel question;
  final int index;

  @override
  Widget build(BuildContext context, LessonViewModel model) {
    final TextEditingController controller = TextEditingController();
    final formKey = GlobalKey<FormState>();
    return Form(
      key: formKey,
      child: ResponsiveBuilder(builder: (context, _) {
        return Column(
          children: [
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
                onDrawOpen: () {

                },
              ).paddingOnly(top: 8),
              hSpaceSmall,
              Expanded(child: Builder(builder: (context) {
                //reset answer field
                if (model.isQuizEnabled()) {
                  controller.text = model.getUserAnswer(index) ?? '';
                }

                return ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 100.h),
                  child: AppTextFieldSecondary(
                    controller: controller,
                    isEnabled: !model.isQuizEnabled(),
                    textColor: model.getButtonStyle(index)[index]['color'],
                    hintText: '       Answer',
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
                  buttonColor: model.getButtonStyle(index)[index]['color'],
                  onPressed: () {
                    ///check attempt count
                    if (!model.isAttemptExceeded(index)) {
                      if (formKey.currentState!.validate()) {
                        model.onQuestionAnswered(
                            text: controller.text,
                            index: index,
                            correctAnswer: question.options!
                                    .where((o) => o.isCorrect ?? false)
                                    .isNotEmpty
                                ? question.options!
                                        .where((o) => o.isCorrect ?? false)
                                        .first
                                        .option ??
                                    'NO ANSWER'
                                : 'NO ANSWER');
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
                visible: model.isAttemptExceeded(index),
                child: Text(
                  question.promptOne ?? '',
                  textAlign: TextAlign.center,
                  style: kBody1Style.copyWith(color: kcTextDarkGrey),
                ))
          ],
        );
      }),
    );
  }
}
