import 'package:educate_me/core/shared/shared_styles.dart';
import 'package:educate_me/core/widgets/app_info.dart';
import 'package:educate_me/core/widgets/busy_button.dart';
import 'package:educate_me/core/widgets/busy_overlay.dart';
import 'package:educate_me/data/lesson.dart';
import 'package:educate_me/features/teacher/level/teacher_level_view_model.dart';
import 'package:educate_me/features/teacher/question/import_qns_view.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:responsive_builder/responsive_builder.dart';
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
  final LessonModel? lessonId;
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
              lessonId: lessonId?.id??'',
              topiId: topicId);
        }
      },
      builder: (context, vm, child) => GestureDetector(
        onTap: () => DeviceUtils.hideKeyboard(context),
        child: BusyOverlay(
          show: vm.isBusy,
          child: Scaffold(
            backgroundColor: kcBg,
            appBar: AppBar(
              elevation: 0,
              title: const Text('Add Questions here'),
              actions: [
                IconButton(
                    onPressed: () => vm.toggleMultiSelect(),
                    icon: Icon(
                      vm.multiSelect ? Iconsax.edit5 : Iconsax.edit,
                      color: kErrorRed,
                    )),
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
                    )),
              ],
            ),
            bottomNavigationBar:
                (vm.multiSelect && vm.selectedQnsIds.isNotEmpty)
                    ? BoxButtonWidget(
                        buttonText: 'Delete Questions',
                        onPressed: () => vm.removeQuestions(
                            levelId: levelId,
                            topicId: topicId,
                            subTopicId: subTopicId,
                            lessonId: lessonId)).paddingAll(16)
                    : const SizedBox(),
            floatingActionButton: FabCircularMenu(
              ringColor: kcPrimaryColor,
              fabOpenIcon: const Icon(Iconsax.add),
              animationDuration: const Duration(milliseconds: 300),
              children: [
                ActionChip(
                  label: const Text('Create'),
                  onPressed: () => Get.to(() => AddQuestionView(
                        topicId: topicId,
                        lessonId: lessonId?.id??'',
                        levelId: levelId,
                        subTopicId: subTopicId,
                        isStartUp: isStartUp,
                      )),
                ),
                ActionChip(
                  label:  Text(lessonId?.raw==null? 'Import practice':'Edit practice'),
                  onPressed: () => Get.to(() => ImportQnsView(
                        levelId: levelId,
                        topicId: topicId,
                        subTopicId: subTopicId,
                        lessonId: lessonId?.id??'',
                        isPractice: true,
                      )),
                ),
                ActionChip(
                  label: const Text('Import'),
                  onPressed: () => Get.to(() => ImportQnsView(
                      levelId: levelId,
                      topicId: topicId,
                      subTopicId: subTopicId,
                      lessonId: lessonId?.id??'')),
                ),
                const SizedBox(),
              ],
            ),
            body: vm.questions.isEmpty
                ? const AppInfoWidget(
                        translateKey: 'No questions found',
                        iconData: Iconsax.message_question)
                    .center()
                : QuestionsGrid(
                    levelId: levelId,
                    topicId: topicId,
                    subTopicId: subTopicId,
                    lessonId: lessonId?.id??'',
                    isStartUp: isStartUp,
                  ),
          ),
        ),
      ),
      viewModelBuilder: () => TeacherLevelViewModel(),
    );
  }
}

class QuestionsGrid extends ViewModelWidget<TeacherLevelViewModel> {
  const QuestionsGrid({
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
      //sort question by index

      return GridView.count(
        crossAxisCount: _.isDesktop ? 8 : 5,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: _.isDesktop ? 2 : 1,
        children: List.generate(model.questions.length, (index) {
          var q = model.questions[index];
          return InkWell(
            borderRadius: kBorderLarge,
            onTap: () => model.multiSelect
                ? model.onQnsSelectedForDelete(q.id ?? '')
                : Get.to(() => AddQuestionView(
                      question: model.questions[index],
                      lessonId: lessonId,
                      topicId: topicId,
                      subTopicId: subTopicId,
                      levelId: levelId,
                      isStartUp: isStartUp,
                    )),
            child: model.isQnSelected(q.id ?? '')
                ? const Icon(
                    Icons.check,
                    color: kAltWhite,
                    size: 32,
                  )
                : Text(
                    '${index + 1}',
                    style: kBodyStyle.copyWith(
                        color: kcCorrectAns, fontWeight: FontWeight.bold),
                  ).center(),
          ).card(
              shape: const CircleBorder(),
              color:
                  model.isQnSelected(q.id ?? '') ? kcPrimaryColor : kAltWhite,
              elevation: 2);
        }),
      ).paddingSymmetric(horizontal: 12);
    });
  }
}
