import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../core/shared/app_colors.dart';
import '../../../core/shared/shared_styles.dart';
import '../../../core/utils/device_utils.dart';
import '../../../core/widgets/app_info.dart';
import '../../../core/widgets/busy_overlay.dart';
import '../question/import_qns_view.dart';
import 'teacher_level_view_model.dart';

class LevelPracticeQnsView extends StatelessWidget {
  const LevelPracticeQnsView(
      {Key? key,
      required this.levelId,
      this.topicId,
      this.subTopicId,
      this.lessonId})
      : super(key: key);
  final String levelId;
  final String? topicId;
  final String? subTopicId;
  final String? lessonId;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TeacherLevelViewModel>.reactive(
      onModelReady: (model) {
        model.getPracticeQuestion(
            levelId: levelId,
            topicId: topicId,
            subTopicId: subTopicId,
            lessonId: lessonId);
      },
      builder: (context, vm, child) => GestureDetector(
        onTap: () => DeviceUtils.hideKeyboard(context),
        child: BusyOverlay(
          show: vm.isBusy,
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: const Text('Add Questions here'),
            ),
            body: vm.practiceQns.isEmpty
                ? const AppInfoWidget(
                        translateKey: 'No practice questions found',
                        iconData: Iconsax.message_question)
                    .center()
                : QuestionsGridPractice(
                    levelId: levelId,
                    topicId: topicId,
                    subTopicId: subTopicId,
                    lessonId: lessonId,
                    isStartUp: false,
                  ),
          ),
        ),
      ),
      viewModelBuilder: () => TeacherLevelViewModel(),
    );
  }
}

class QuestionsGridPractice extends ViewModelWidget<TeacherLevelViewModel> {
  const QuestionsGridPractice({
    Key? key,
    required this.levelId,
    this.topicId,
    this.subTopicId,
    this.lessonId,
    required this.isStartUp,
  }) : super(key: key);
  final String levelId;
  final String? topicId;
  final String? subTopicId;
  final String? lessonId;
  final bool isStartUp;

  @override
  Widget build(BuildContext context, TeacherLevelViewModel model) {
    return ResponsiveBuilder(builder: (context, _) {
      return GridView.count(
        crossAxisCount: _.isDesktop ? 8 : 5,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: _.isDesktop ? 2 : 1,
        children: List.generate(model.practiceQns.length, (index) {
          return InkWell(
            borderRadius: kBorderLarge,
            onTap: () async {
              var result = await Get.to(() => ImportQnsView(
                    levelId: levelId,
                    topicId: topicId,
                    subTopicId: subTopicId,
                    lessonId: lessonId,
                    isPractice: true,
                  ));
              model.getPracticeQuestion(
                  levelId: levelId,
                  topicId: topicId,
                  subTopicId: subTopicId,
                  lessonId: lessonId);
            },
            child: Text(
              '${index + 1}',
              style: kBodyStyle.copyWith(
                  color: kcCorrectAns, fontWeight: FontWeight.bold),
            ).center(),
          ).card(shape: const CircleBorder(), color: kAltWhite, elevation: 2);
        }),
      ).paddingSymmetric(horizontal: 12);
    });
  }
}
