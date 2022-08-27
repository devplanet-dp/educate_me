import 'package:educate_me/data/topic.dart';
import 'package:educate_me/features/teacher/sub-topic/teacher_add_sub_topic_view.dart';
import 'package:educate_me/features/teacher/topic/teacher_topic_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../core/shared/app_colors.dart';
import '../../../core/utils/device_utils.dart';
import '../../../core/widgets/app_info.dart';
import '../topic/components/topic_card.dart';
import 'teacher_sub_topic_view_model.dart';

class TeacherSubTopicView extends StatelessWidget {
  const TeacherSubTopicView(
      {Key? key, required this.levelId, required this.topic})
      : super(key: key);
  final String levelId;
  final TopicModel topic;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TeacherSubTopicViewModel>.reactive(
      onModelReady: (model) {
        model.listenToTopics(levelId: levelId, topicId: topic.id ?? '');
      },
      builder: (context, vm, child) => GestureDetector(
        onTap: () => DeviceUtils.hideKeyboard(context),
        child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: Text('Add sub-topics for ${topic.name}'),
              actions: [
                IconButton(
                    onPressed: () => vm.removeTopic(
                        levelId: levelId, topicId: topic.id ?? ''),
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
                  TeacherAddSubTopicView(
                    levelId: levelId,
                    topicId: topic.id ?? '',
                  ),
                  isScrollControlled: true),
            ),
            body: vm.topics.isEmpty
                ? const AppInfoWidget(
                        translateKey: 'No sub-topics found',
                        iconData: Iconsax.message_question)
                    .center()
                : _TopicGridView(levelId, topic.id ?? '')),
      ),
      viewModelBuilder: () => TeacherSubTopicViewModel(),
    );
  }
}

class _TopicGridView extends ViewModelWidget<TeacherTopicViewModel> {
  const _TopicGridView(this.levelId, this.topicId, {Key? key})
      : super(key: key);
  final String levelId;
  final String topicId;

  @override
  Widget build(BuildContext context, TeacherTopicViewModel model) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      children: List.generate(model.topics.length, (index) {
        var t = model.topics[index];
        return TopicCard(
          onTap: () => Get.to(() => TeacherSubTopicView(
                levelId: levelId,
                topic: t,
              )),
          url: t.cover ?? '',
          title: t.name ?? '', onEditTap: () {  },
        );
      }),
    );
  }
}
