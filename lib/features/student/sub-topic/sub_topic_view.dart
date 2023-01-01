import 'package:auto_size_text/auto_size_text.dart';
import 'package:educate_me/core/shared/app_colors.dart';
import 'package:educate_me/core/shared/shared_styles.dart';
import 'package:educate_me/core/shared/ui_helpers.dart';
import 'package:educate_me/data/lesson.dart';
import 'package:educate_me/data/sub_topic.dart';
import 'package:educate_me/data/topic.dart';
import 'package:educate_me/features/student/topic/topic_view_model.dart';
import 'package:educate_me/features/teacher/lesson/components/lesson_card.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../core/utils/device_utils.dart';
import '../../../core/widgets/image_app_bar.dart';

class SubTopicView extends StatelessWidget {
  const SubTopicView({Key? key, required this.topic, required this.levelId})
      : super(key: key);
  final TopicModel topic;
  final String levelId;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    return ViewModelBuilder<TopicViewModel>.reactive(
      onModelReady: (model) {},
      builder: (context, vm, child) => GestureDetector(
        onTap: () => DeviceUtils.hideKeyboard(context),
        child: Scaffold(
          backgroundColor: kcBg,
          extendBodyBehindAppBar: true,
          body: CustomScrollView(
            slivers: [
              ImageSliderAppBar(
                images: topic.cover ?? '',
                title:
                    'Level ${vm.quizController.currentLevel?.name} - ${topic.name}',
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
                vSpaceMedium,
                _SubTopicList(levelId: levelId, topicId: topic.id ?? '')
              ]))
            ],
          ),
        ),
      ),
      viewModelBuilder: () => TopicViewModel(),
    );
  }
}

class _SubTopicList extends ViewModelWidget<TopicViewModel> {
  const _SubTopicList({Key? key, required this.levelId, required this.topicId})
      : super(key: key);
  final String levelId;
  final String topicId;

  @override
  Widget build(BuildContext context, TopicViewModel model) {
    return FirestoreListView<SubTopicModel>(
        query: model.querySubTopics(levelId: levelId, topicId: topicId),
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemBuilder: (_, snapshot) {
          var s = snapshot.data();

          return [
            ResponsiveBuilder(builder: (context, _) {
              return Text(
                s.title ?? '',
                style: kBodyStyle.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: _.isTablet ? 24 : 16.sp,
                ),
              ).paddingOnly(left: _.isTablet ? 32 : 12);
            }),
            AutoSizeText(
              s.description ?? '',
              maxLines: 1,
              style: kCaptionStyle.copyWith(
                  color: kcTextDarkGrey,
                  fontWeight: FontWeight.w400,
                  fontSize: _.isTablet ? 16 : 13),
            ).paddingOnly(left: _.isTablet ? 32 : 12),
            vSpaceSmall,
            _LessonList(
                levelId: levelId, topicId: topicId, subTopicId: s.id ?? ''),
            vSpaceSmall,
          ].toColumn(crossAxisAlignment: CrossAxisAlignment.start);
        });
  }
}

class _SubTopicSection extends StatelessWidget {
  const _SubTopicSection(
      {Key? key,
      required this.subtopics,
      required this.levelId,
      required this.topicId})
      : super(key: key);
  final List<SubTopicModel> subtopics;
  final String levelId;
  final String topicId;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemCount: subtopics.length,
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (_, index) => vSpaceMedium,
        itemBuilder: (_, index) {
          var s = subtopics[index];
          return [
            ResponsiveBuilder(builder: (context, _) {
              return Text(
                s.title ?? '',
                style: kBodyStyle.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: _.isTablet ? 24 : 16.sp,
                ),
              ).paddingOnly(left: _.isTablet ? 32 : 12);
            }),
            AutoSizeText(
              s.description ?? '',
              maxLines: 1,
              style: kCaptionStyle.copyWith(
                  color: kcTextDarkGrey,
                  fontWeight: FontWeight.w400,
                  fontSize: _.isTablet ? 16 : 13),
            ).paddingOnly(left: _.isTablet ? 32 : 12),
            vSpaceSmall,
            _LessonList(
                levelId: levelId, topicId: topicId, subTopicId: s.id ?? ''),
            vSpaceSmall,
          ].toColumn(crossAxisAlignment: CrossAxisAlignment.start);
        });
  }
}

class _LessonList extends ViewModelWidget<TopicViewModel> {
  const _LessonList(
      {Key? key,
      required this.levelId,
      required this.topicId,
      required this.subTopicId})
      : super(key: key);
  final String levelId;
  final String topicId;
  final String subTopicId;

  @override
  Widget build(BuildContext context, TopicViewModel model) {
    return FirestoreListView<LessonModel>(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        query: model.queryLesson(
            levelId: levelId, topicId: topicId, subTopicId: subTopicId),
        itemBuilder: (_, snapshot) {
          final t = snapshot.data();
          return ResponsiveBuilder(builder: (context, _) {
            return LessonCard(
              lesson: t,
              isCompleted: model.isLessonCompleted(t.id ?? ''),
              onTap: () => model.goToLessonView(
                  currentLesson: t,
                  levelId: levelId,
                  topicId: topicId,
                  subTopicId: subTopicId),
            ).paddingOnly(right: _.isTablet ? 32 : 10);
          });
        }).paddingOnly(left: 16).height(180);
  }
}
