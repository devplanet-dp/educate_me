import 'package:auto_size_text/auto_size_text.dart';
import 'package:educate_me/core/shared/app_colors.dart';
import 'package:educate_me/core/shared/shared_styles.dart';
import 'package:educate_me/core/shared/ui_helpers.dart';
import 'package:educate_me/core/widgets/app_info.dart';
import 'package:educate_me/data/lesson.dart';
import 'package:educate_me/data/sub_topic.dart';
import 'package:educate_me/data/topic.dart';
import 'package:educate_me/features/student/topic/topic_view_model.dart';
import 'package:educate_me/features/teacher/lesson/components/lesson_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../core/utils/device_utils.dart';
import '../../../core/widgets/image_app_bar.dart';

class TopicDetailedView extends StatelessWidget {
  const TopicDetailedView(
      {Key? key, required this.topic, required this.levelId})
      : super(key: key);
  final TopicModel topic;
  final String levelId;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    return ViewModelBuilder<TopicViewModel>.reactive(
      builder: (context, vm, child) => GestureDetector(
        onTap: () => DeviceUtils.hideKeyboard(context),
        child: Scaffold(
          extendBodyBehindAppBar: true,
          body: CustomScrollView(
            slivers: [
              ImageSliderAppBar(
                images: topic.cover ?? '', title:topic.name??'',
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
    return StreamBuilder<List<SubTopicModel>>(
        stream: model.streamSubTopics(levelId: levelId, topicId: topicId),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            var list = snapshot.data ?? [];
            if (list.isEmpty) {
              return AppInfoWidget(
                      translateKey: 'text027'.tr, iconData: Iconsax.book)
                  .center();
            }
            return _SubTopicSection(
              subtopics: list,
              levelId: levelId,
              topicId: topicId,
            );
          }
          return const ShimmerView(thumbHeight: 20, thumbWidth: 80);
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
            Text(
              s.title ?? '',
              style: kBodyStyle.copyWith(fontWeight: FontWeight.bold),
            ).paddingOnly(left: 12),
            vSpaceSmall,
            AutoSizeText(
              s.description ?? '',
              maxLines: 1,
              style: kCaptionStyle.copyWith(color: kcTextDarkGrey,fontWeight: FontWeight.w400),
            ).paddingOnly(left: 12),
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
    return StreamBuilder<List<LessonModel>>(
        stream: model.streamLesson(
            topicId: topicId, levelId: levelId, subTopicId: subTopicId),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            final lessons = snapshot.data ?? [];
            if(lessons.isEmpty){
              return AppInfoWidget(translateKey: 'text028'.tr, iconData: Iconsax.book).center();
            }
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(lessons.length, (index) {
                  final t = lessons[index];
                  return LessonCard(
                          lesson: t,
                          onTap: () {},)
                      .paddingOnly(
                          left: 10,
                          right: index == lessons.length - 1 ? 10 : 0);
                }),
              ),
            );
          }
          return const ShimmerTopic();
        });
  }
}
