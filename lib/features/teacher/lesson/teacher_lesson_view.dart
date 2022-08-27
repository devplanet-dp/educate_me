import 'package:educate_me/data/sub_topic.dart';
import 'package:educate_me/features/teacher/lesson/teacher_add_lesson_view.dart';
import 'package:educate_me/features/teacher/lesson/teacher_lesson_view_model.dart';
import 'package:educate_me/features/teacher/level/teacher_qns_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../core/shared/app_colors.dart';
import '../../../core/utils/device_utils.dart';
import '../../../core/widgets/app_info.dart';
import '../../../core/widgets/busy_overlay.dart';
import '../topic/components/topic_card.dart';

class TeacherLessonView extends StatelessWidget {
  const TeacherLessonView(
      {Key? key,
      required this.levelId,
      required this.topicId,
      required this.subTopic})
      : super(key: key);
  final String levelId;
  final String topicId;
  final SubTopicModel subTopic;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TeacherLessonViewModel>.reactive(
      onModelReady: (model) {
        model.listenToLessons(
            levelId: levelId, topicId: topicId, subTopicId: subTopic.id);
      },
      builder: (context, vm, child) => GestureDetector(
        onTap: () => DeviceUtils.hideKeyboard(context),
        child: BusyOverlay(
          show: vm.isBusy,
          child: Scaffold(
              appBar: AppBar(
                elevation: 0,
                title: Text('Add Lessons for ${subTopic.title}'),
                actions: [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Iconsax.trash,
                        color: kErrorRed,
                      ))
                ],
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: kcPrimaryColor,
                child: const Icon(Iconsax.add),
                onPressed: () => Get.bottomSheet(
                    TeacherAddLessonView(
                      topicId: topicId,
                      subTopicId: subTopic.id ?? '',
                      levelId: levelId,
                    ),
                    isScrollControlled: true),
              ),
              body: vm.lessons.isEmpty
                  ? const AppInfoWidget(
                          translateKey: 'No lessons found',
                          iconData: Iconsax.message_question)
                      .center()
                  : _LessonGridView(
                      levelId,
                      topicId,
                      subTopic.id ?? '',
                    )),
        ),
      ),
      viewModelBuilder: () => TeacherLessonViewModel(),
    );
  }
}

class _LessonGridView extends ViewModelWidget<TeacherLessonViewModel> {
  const _LessonGridView(this.levelId, this.topicId, this.subTopicId, {Key? key})
      : super(key: key);
  final String levelId;
  final String topicId;
  final String subTopicId;

  @override
  Widget build(BuildContext context, TeacherLessonViewModel model) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      children: List.generate(model.lessons.length, (index) {
        var t = model.lessons[index];
        return TopicCard(
          onTap: () => Get.to(() => TeacherQnsView(
                topicId: topicId,
                levelId: levelId,
                subTopicId: subTopicId,
                lessonId: t.id ?? '',
              )),
          url: t.cover ?? '',
          title: t.title ?? '',
          onEditTap: () => Get.bottomSheet(
              TeacherAddLessonView(
                levelId: levelId,
                topicId: topicId,
                subTopicId: subTopicId,
                lesson: t,
              ),
              isScrollControlled: true),
        );
      }),
    ).paddingSymmetric(horizontal: 12);
  }
}
