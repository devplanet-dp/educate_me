import 'package:educate_me/data/level.dart';
import 'package:educate_me/features/teacher/sub-topic/teacher_sub_topic_view.dart';
import 'package:educate_me/features/teacher/topic/components/topic_card.dart';
import 'package:educate_me/features/teacher/topic/teacher_add_topic_view.dart';
import 'package:educate_me/features/teacher/topic/teacher_topic_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../core/shared/app_colors.dart';
import '../../../core/utils/device_utils.dart';
import '../../../core/widgets/app_info.dart';
import '../../../core/widgets/busy_overlay.dart';

class TeacherTopicView extends StatelessWidget {
  const TeacherTopicView({Key? key, required this.level}) : super(key: key);
  final LevelModel level;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TeacherTopicViewModel>.reactive(
      onModelReady: (model){
        model.listenToTopics(level.id??'');
      },
      builder: (context, vm, child) => GestureDetector(
        onTap: () => DeviceUtils.hideKeyboard(context),
        child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: Text('Add topics for ${level.name}'),
              actions: [
                IconButton(
                    onPressed: () => vm.removeLevel(level.id ?? ''),
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
                  TeacherAddTopicView(
                    levelId: level.id ?? '',
                  ),
                  isScrollControlled: true),
            ),
            body: vm.topics.isEmpty
                ? const AppInfoWidget(
                        translateKey: 'No topics found',
                        iconData: Iconsax.message_question)
                    .center()
                :  _TopicGridView(level.id??'')),
      ),
      viewModelBuilder: () => TeacherTopicViewModel(),
    );
  }
}

class _TopicGridView extends ViewModelWidget<TeacherTopicViewModel> {
  const _TopicGridView(this.levelId, {Key? key}) : super(key: key);
  final String levelId;

  @override
  Widget build(BuildContext context, TeacherTopicViewModel model) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      children: List.generate(model.topics.length, (index) {
        var t = model.topics[index];
        return TopicCard(
            topic: t,
            onTap: () => Get.to(() => TeacherSubTopicView(
                  levelId: levelId,
                  topic: t,
                )));
      }),
    ).paddingSymmetric(horizontal: 12);
  }
}