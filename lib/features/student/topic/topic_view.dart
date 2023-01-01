import 'package:educate_me/core/shared/app_colors.dart';
import 'package:educate_me/core/shared/ui_helpers.dart';
import 'package:educate_me/data/level.dart';
import 'package:educate_me/data/topic.dart';
import 'package:educate_me/features/student/topic/topic_view_model.dart';
import 'package:educate_me/features/teacher/topic/components/topic_card.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
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
      builder: (context, vm, child) => GestureDetector(
        onTap: () => DeviceUtils.hideKeyboard(context),
        child: Scaffold(
          backgroundColor: kcBg,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kAppToolbarHeight),
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
    return FirestoreListView<LevelModel>(
      query: model.levelQuery(),
      shrinkWrap: true,
      itemBuilder: (context, snapshot) {
        LevelModel level = snapshot.data();

        return [
          ResponsiveBuilder(builder: (context, _) {
            return Text(
              'Level ${level.name ?? ''}',
              style: kSubheadingStyle.copyWith(fontWeight: FontWeight.w600),
            ).paddingOnly(left: _.isTablet ? 32 : 12);
          }),
          vSpaceSmall,
          _TopicList(
            level: level,
            isLocked: model.isLevelLocked(level.id ?? ''),
            isCompleted: false,
          ),
          vSpaceMedium
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start);
      },
    ).paddingOnly(top: 16);

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
    return ResponsiveBuilder(
      builder: (context,_) {
        return FirestoreListView<TopicModel>(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            query: model.levelTopicsQuery(level.id??''),
            physics: const BouncingScrollPhysics(),
            itemBuilder: (_, snapshot) {
              final t = snapshot.data();
              return TopicCard(
                  isLocked: isLocked,
                  isCompleted: isCompleted,
                  url: t.cover ?? '',
                  onTap: () =>
                      model.goToSubtopic(level: level, topic: t),
                  title: t.name ?? '')
                  .paddingOnly(
                  right: _.isTablet
                      ? 12
                      : 10);
            }).paddingOnly(left:_.isTablet?22: 10).height(120);
      }
    );
  }
}
