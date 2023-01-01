import 'package:educate_me/data/level.dart';
import 'package:educate_me/features/teacher/sub-topic/teacher_sub_topic_view.dart';
import 'package:educate_me/features/teacher/topic/components/topic_card.dart';
import 'package:educate_me/features/teacher/topic/teacher_add_topic_view.dart';
import 'package:educate_me/features/teacher/topic/teacher_topic_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../core/shared/app_colors.dart';
import '../../../core/shared/ui_helpers.dart';
import '../../../core/utils/device_utils.dart';
import '../../../core/widgets/app_info.dart';

class TeacherTopicView extends StatelessWidget {
  const TeacherTopicView({Key? key, required this.level}) : super(key: key);
  final LevelModel level;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TeacherTopicViewModel>.reactive(
      onModelReady: (model) {
        model.listenToTopics(level.id ?? '');
      },
      builder: (context, vm, child) => GestureDetector(
        onTap: () => DeviceUtils.hideKeyboard(context),
        child: Scaffold(
            backgroundColor: kcBg,
            appBar: AppBar(
              elevation: 0,
              title: Text('Add topics for Level ${level.name}'),
              actions: [
                (vm.multiSelect && vm.selectedQnsIds.isNotEmpty)
                    ? IconButton(
                        onPressed: () => vm.removeTopics(
                              levelId: level.id,
                            ),
                        icon: const Icon(
                          Iconsax.trash,
                          color: kErrorRed,
                        ))
                    : emptyBox(),
                IconButton(
                    onPressed: () => vm.toggleMultiSelect(),
                    icon: Icon(
                      vm.multiSelect ? Iconsax.edit5 : Iconsax.edit,
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
                : _TopicGridView(level.id ?? '')),
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
    return ResponsiveBuilder(builder: (context, _) {
      return GridView.count(
        crossAxisCount: _.isDesktop ? 4 : 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: _.isDesktop ? 3 : 1,
        children: List.generate(model.topics.length, (index) {
          var t = model.topics[index];
          return Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: TopicCard(
                  url: t.cover ?? '',
                  title: t.name ?? '',
                  onTap: () => model.multiSelect
                      ? model.onQnsSelectedForDelete(t.id ?? '')
                      : Get.to(() => TeacherSubTopicView(
                            levelId: levelId,
                            topic: t,
                          )),
                  onEditTap: () => Get.bottomSheet(
                      TeacherAddTopicView(
                        levelId: levelId,
                        topic: t,
                      ),
                      isScrollControlled: true),
                ),
              ),
              Visibility(
                  visible: model.isLessonSelected(t.id ?? ''),
                  child: const Icon(
                    Icons.check,
                    size: 32,
                  )
                      .paddingAll(8)
                      .decorated(shape: BoxShape.circle, color: kcBg)),
            ],
          );
        }),
      ).paddingSymmetric(horizontal: 12);
    });
  }
}
