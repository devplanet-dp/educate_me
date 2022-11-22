import 'package:educate_me/core/shared/app_colors.dart';
import 'package:educate_me/core/shared/ui_helpers.dart';
import 'package:educate_me/data/level.dart';
import 'package:educate_me/data/topic.dart';
import 'package:educate_me/features/student/topic/topic_view_model.dart';
import 'package:educate_me/features/teacher/topic/components/topic_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../core/shared/shared_styles.dart';
import '../../../core/utils/device_utils.dart';
import '../../signin/components/custom_app_bar.dart';

class TopicView extends StatelessWidget {
  const TopicView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TopicViewModel>.reactive(
      onModelReady: (model) {
        model.listenToLevels();
      },
      builder: (context, vm, child) => GestureDetector(
        onTap: () => DeviceUtils.hideKeyboard(context),
        child: Scaffold(
          backgroundColor: kcBg,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: SwitchUserAppBar(
              title: 'text024'.tr,
              onUserUpdated: () => vm.notifyListeners(),
            ),
          ),
          body: const _LevelSection(),
        ),
      ),
      viewModelBuilder: () => TopicViewModel(),
    );
  }
}

class _LevelSection extends ViewModelWidget<TopicViewModel> {
  const _LevelSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, TopicViewModel model) {
    return ListView.separated(
        shrinkWrap: true,
        itemCount: model.levels.length,
        separatorBuilder: (_, __) => vSpaceMedium,
        itemBuilder: (_, index) => [
              Text(
                'Level ${model.levels[index].name ?? ''}',
                style: kSubheadingStyle.copyWith(fontWeight: FontWeight.bold),
              ).paddingOnly(left: 12),
              vSpaceSmall,
              _TopicList(
                level: model.levels[index],
                isLocked: model.isLevelLocked(model.levels[index].id??''),
                isCompleted: false,
              )
            ].toColumn(crossAxisAlignment: CrossAxisAlignment.start));
  }
}

class _TopicList extends ViewModelWidget<TopicViewModel> {
  const _TopicList(
      {Key? key,
      required this.level,
      this.isLocked = false,
      this.isCompleted = false})
      : super(key: key);
  final LevelModel level;
  final bool isLocked;
  final bool isCompleted;

  @override
  Widget build(BuildContext context, TopicViewModel model) {
    return StreamBuilder<List<TopicModel>>(
        stream: model.streamLevelTopics(level.id ?? ''),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            final topics = snapshot.data ?? [];
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(topics.length, (index) {
                  final t = topics[index];
                  return TopicCard(
                          isLocked: isLocked,
                          isCompleted: isCompleted,
                          url: t.cover ?? '',
                          onTap: () =>
                              model.goToSubtopic(level: level, topic: t),
                          title: t.name ?? '')
                      .paddingOnly(
                          left: 10, right: index == topics.length - 1 ? 10 : 0);
                }),
              ),
            );
          }
          return const ShimmerTopic();
        });
  }
}
