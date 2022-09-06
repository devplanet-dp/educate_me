import 'package:educate_me/core/shared/ui_helpers.dart';
import 'package:educate_me/data/topic.dart';
import 'package:educate_me/features/student/sub-topic/sub_topic_view.dart';
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
        child: SafeArea(
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: SwitchUserAppBar(
                title: 'text024'.tr,
                onUserUpdated:()=>vm.notifyListeners(),
              ),
            ),
            body: const _LevelSection(),
          ),
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
        separatorBuilder: (_, __) => vSpaceSmall,
        itemBuilder: (_, index) => [
              Text(
                model.levels[index].name ?? '',
                style: kSubheadingStyle.copyWith(fontWeight: FontWeight.bold),
              ).paddingOnly(left: 12),
              vSpaceSmall,
              _TopicList(model.levels[index].id ?? '')
            ].toColumn(crossAxisAlignment: CrossAxisAlignment.start));
  }
}

class _TopicList extends ViewModelWidget<TopicViewModel> {
  const _TopicList(this.levelId, {Key? key}) : super(key: key);
  final String levelId;

  @override
  Widget build(BuildContext context, TopicViewModel model) {
    return StreamBuilder<List<TopicModel>>(
        stream: model.streamLevelTopics(levelId),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            final topics = snapshot.data ?? [];
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(topics.length, (index) {
                  final t = topics[index];
                  return TopicCard(
                          url: t.cover ?? '',
                          onTap: () => Get.to(() => SubTopicView(
                                topic: t,
                                levelId: levelId,
                              )),
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
