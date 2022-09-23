import 'package:educate_me/core/shared/shared_styles.dart';
import 'package:educate_me/core/widgets/app_info.dart';
import 'package:educate_me/core/widgets/busy_overlay.dart';
import 'package:educate_me/features/teacher/level/teacher_level_view_model.dart';
import 'package:educate_me/features/teacher/question/import_qns_view.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../core/shared/app_colors.dart';
import '../../../core/utils/device_utils.dart';
import '../question/add_qns_view.dart';

class TeacherQnsView extends StatelessWidget {
  const TeacherQnsView(
      {Key? key,
      required this.levelId,
      this.topicId,
      this.subTopicId,
      this.lessonId,
      this.isStartUp = false})
      : super(key: key);
  final String levelId;
  final String? topicId;
  final String? subTopicId;
  final String? lessonId;
  final bool isStartUp;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TeacherLevelViewModel>.reactive(
      onModelReady: (model) {
        if (isStartUp) {
          model.listenToStartUpQns(levelId);
        } else {
          model.listenToQns(
              levelId: levelId,
              subTopicId: subTopicId,
              lessonId: lessonId,
              topiId: topicId);
        }
      },
      builder: (context, vm, child) => GestureDetector(
        onTap: () => DeviceUtils.hideKeyboard(context),
        child: BusyOverlay(
          show: vm.isBusy,
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: const Text('Add Questions here'),
              actions: [
                IconButton(
                    onPressed: () => isStartUp
                        ? vm.removeLevel(levelId)
                        : vm.removeLesson(
                            levelId: levelId,
                            topic: topicId,
                            subTopic: subTopicId,
                            lessonId: lessonId),
                    icon: const Icon(
                      Iconsax.trash,
                      color: kErrorRed,
                    ))
              ],
            ),
            floatingActionButton: FabCircularMenu(
              ringColor: kcPrimaryColor,
              fabOpenIcon: const Icon(Iconsax.add),
              animationDuration: const Duration(milliseconds: 300),
              children: [
                ActionChip(
                  label: const Text('Create'),
                  onPressed: () => Get.to(() => AddQuestionView(
                    topicId: topicId,
                    lessonId: lessonId,
                    levelId: levelId,
                    subTopicId: subTopicId,
                    isStartUp: isStartUp,
                  )),
                ),
                ActionChip(
                  label: const Text('Import practice'),
                  onPressed: () => Get.to(() => ImportQnsView(
                      levelId: levelId,
                      topicId: topicId,
                      subTopicId: subTopicId,
                      lessonId: lessonId,isPractice: true,)),
                ),
                ActionChip(
                  label: const Text('Import'),
                  onPressed: () => Get.to(() => ImportQnsView(
                      levelId: levelId,
                      topicId: topicId,
                      subTopicId: subTopicId,
                      lessonId: lessonId)),
                ),
                const SizedBox(),
              ],
            ),
            body: vm.questions.isEmpty
                ? const AppInfoWidget(
                        translateKey: 'No questions found',
                        iconData: Iconsax.message_question)
                    .center()
                : _QuestionsGrid(
                    levelId: levelId,
                    topicId: topicId,
                    subTopicId: subTopicId,
                    lessonId: lessonId,
                    isStartUp: isStartUp,
                  ),
          ),
        ),
      ),
      viewModelBuilder: () => TeacherLevelViewModel(),
    );
  }
}

class _QuestionsGrid extends ViewModelWidget<TeacherLevelViewModel> {
  const _QuestionsGrid({
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
    return GridView.count(
      crossAxisCount: 5,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      children: List.generate(model.questions.length, (index) {
        return InkWell(
          borderRadius: kBorderLarge,
          onTap: () => Get.to(() => AddQuestionView(
                question: model.questions[index],
                lessonId: lessonId,
                topicId: topicId,
                subTopicId: subTopicId,
                levelId: levelId,
                isStartUp: isStartUp,
              )),
          child: Text(
            '${index + 1}',
            style: kBodyStyle.copyWith(
                color: kcCorrectAns, fontWeight: FontWeight.bold),
          ).center(),
        ).card(shape: const CircleBorder(), color: kAltWhite, elevation: 2);
      }),
    ).paddingSymmetric(horizontal: 12);
  }
}
