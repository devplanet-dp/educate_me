import 'package:educate_me/core/shared/app_colors.dart';
import 'package:educate_me/core/shared/shared_styles.dart';
import 'package:educate_me/core/shared/ui_helpers.dart';
import 'package:educate_me/core/utils/constants/app_assets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../core/utils/device_utils.dart';
import '../../../data/lesson.dart';
import '../../signin/components/custom_app_bar.dart';
import '../../student/topic/topic_view_model.dart';
import '../level/teacher_qns_view.dart';

class LessonStatView extends StatelessWidget {
  const LessonStatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TopicViewModel>.reactive(
      onModelReady: (model) {
        model.listenToLevels();
      },
      builder: (context, vm, child) => Scaffold(
        backgroundColor: kcBg,
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(kAppToolbarHeight),
          child: AdminAppBar(title: 'Admin Statistics'),
        ),
        body: GestureDetector(
            onTap: () => DeviceUtils.hideKeyboard(context),
            child: const _LevelSection().paddingOnly(top: 18)),
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
            itemCount: model.levels.length,
            shrinkWrap: true,
            separatorBuilder: (_, __) => vSpaceSmall,
            itemBuilder: (_, index) => ExpansionTile(
                    trailing: emptyBox(),
                    onExpansionChanged: (isExpanded) {
                      model.levels[index].expanded = isExpanded;
                      model.notifyListeners();
                    },
                    title: _ExpandHeader(
                        expanded: model.levels[index].expanded,
                        paddingLeft: 0,
                        hasDivider: false,
                        title: 'Level ${model.levels[index].name ?? ''}',
                        style: kExpansionTitle),
                    children: [_TopicList(model.levels[index].id ?? '')])
                .paddingSymmetric(horizontal: 8)
                .decorated(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(10))))
        .paddingSymmetric(horizontal: 16);
  }
}

class _TrailingIcon extends StatelessWidget {
  const _TrailingIcon({Key? key, this.expanded}) : super(key: key);
  final bool? expanded;

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
        quarterTurns: expanded ?? false ? 3 : 0,
        child: SvgPicture.asset(kIcCollapsed));
  }
}

class _ExpandHeader extends StatelessWidget {
  const _ExpandHeader(
      {Key? key,
      required this.title,
      required this.paddingLeft,
      required this.style,
      this.hasDivider = true,
      this.expanded})
      : super(key: key);
  final String title;
  final TextStyle style;
  final double paddingLeft;
  final bool? expanded;
  final bool? hasDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: paddingLeft),
              child: Text(
                title,
                style: style,
              ),
            ),
            const Expanded(child: SizedBox()),
            _TrailingIcon(
              expanded: expanded,
            )
          ],
        ),
      ],
    ).paddingSymmetric(vertical: 12);
  }
}

class _TopicList extends StatelessWidget {
  const _TopicList(this.levelId, {Key? key}) : super(key: key);
  final String levelId;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TopicViewModel>.reactive(
      onModelReady: (model) {
        model.listenToTopics(levelId);
      },
      builder: (context, vm, child) => ListView.builder(
          itemCount: vm.topics.length,
          shrinkWrap: true,
          itemBuilder: (_, index) => ExpansionTile(
                  trailing: emptyBox(),
                  onExpansionChanged: (isExpanded) {
                    vm.topics[index].expanded = isExpanded;
                    vm.notifyListeners();
                  },
                  title: _ExpandHeader(
                      expanded: vm.topics[index].expanded,
                      paddingLeft: 0,
                      hasDivider: vm.topics[index].expanded,
                      title: vm.topics[index].name ?? '',
                      style: kExpansionTitle.copyWith(
                          fontSize: 14.5, fontWeight: FontWeight.w400)),
                  children: [
                    _SubTopicList(
                      levelId: levelId,
                      topicId: vm.topics[index].id ?? '',
                    )
                  ]).paddingOnly(left: 8)),
      viewModelBuilder: () => TopicViewModel(),
    );
  }
}

class _SubTopicList extends StatelessWidget {
  const _SubTopicList({Key? key, required this.levelId, required this.topicId})
      : super(key: key);
  final String levelId;
  final String topicId;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TopicViewModel>.reactive(
      onModelReady: (model) {
        model.listenToSubTopics(levelId: levelId, topicId: topicId);
      },
      builder: (context, vm, child) => ListView.builder(
          itemCount: vm.subTopics.length,
          shrinkWrap: true,
          itemBuilder: (_, index) => ExpansionTile(
                  trailing: emptyBox(),
                  onExpansionChanged: (isExpanded) {
                    vm.subTopics[index].expanded = isExpanded;
                    vm.notifyListeners();
                  },
                  title: _ExpandHeader(
                      expanded: vm.subTopics[index].expanded,
                      paddingLeft: 0,
                      title: vm.subTopics[index].title ?? '',
                      style: kExpansionTitle.copyWith(
                          fontSize: 13, fontWeight: FontWeight.w300)),
                  children: [
                    _LessonList(
                      levelId: levelId,
                      topicId: topicId,
                      subTopicId: vm.subTopics[index].id ?? '',
                    )
                  ]).paddingOnly(left: 8)),
      viewModelBuilder: () => TopicViewModel(),
    );
  }
}

class _LessonList extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return ViewModelBuilder<TopicViewModel>.reactive(
      onModelReady: (model) {
        model.listenToLessons(
            levelId: levelId, topicId: topicId, subTopicId: subTopicId);
      },
      builder: (context, vm, child) => _buildLessonDataRow(vm.lessons, vm),
      viewModelBuilder: () => TopicViewModel(),
    );
  }

  Widget _buildLessonDataRow(List<LessonModel> lessons, TopicViewModel model) =>
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: fieldPadding,
        child: DataTable(
            dataRowHeight: 32,
            headingTextStyle: kBody1Style.copyWith(
                color: kcTextStatColor.withOpacity(0.6), fontSize: 12),
            border: TableBorder(
                horizontalInside:
                    BorderSide(color: Colors.black.withOpacity(.1))),
            columns: const [
              DataColumn(label: Text('')),
              DataColumn(label: Text('Question')),
              DataColumn(label: Text('Attempts')),
              DataColumn(label: Text('Pass %')),
              DataColumn(label: Text('Draw %')),
              DataColumn(label: Text('Draw tool status')),
            ],
            rows: List.generate(lessons.length, (index) {
              var l = lessons[index];
              var attempts = (l.failCount! + l.passCount!);
              var passPercentage =
                  (attempts == 0 ? 0 : (l.passCount! / attempts) * 100)
                      .toStringAsFixed(1);
              var draw = l.drawingToolUsed?.length ?? 0;

              var drawEnabled = l.drawToolEnabled ?? false;

              return DataRow(cells: [
                DataCell(InkWell(
                  onTap: () => Get.to(() => TeacherQnsView(
                        topicId: topicId,
                        levelId: levelId,
                        subTopicId: subTopicId,
                        isFromStatsView: true,
                        lessonId: lessons[index],
                      )),
                  child: Text(
                    lessons[index].title ?? '',
                    style: kBodyStyle.copyWith(
                        color: kcPrimaryColor,
                        decoration: TextDecoration.underline),
                  ),
                )),
                DataCell(_buildNoQuestion(
                    model: model,
                    levelId: levelId,
                    topicId: topicId,
                    subTopicId: subTopicId,
                    lessonId: lessons[index].id ?? '')),
                DataCell(Text(
                  '$attempts',
                  style: kBody1Style.copyWith(color: const Color(0xFFD00E31)),
                )),
                DataCell(Text(
                  passPercentage,
                  style: kBody1Style.copyWith(color: const Color(0xFF0ED082)),
                )),
                DataCell(Text(
                  '$draw',
                  style: kBody1Style.copyWith(color: const Color(0xFFB055E9)),
                )),
                DataCell(model.busy(l.id)
                    ? const Center(
                        child: CupertinoActivityIndicator(),
                      )
                    : MaterialButton(
                        onPressed: () => model.updateDrawingToolCount(
                            lesson: l.id,
                            levelId: levelId,
                            topicId: topicId,
                            subTopicId: subTopicId,
                            enable: !drawEnabled),
                        elevation: 0,
                        color: drawEnabled ? Colors.red : Colors.greenAccent,
                        child: Text(drawEnabled ? 'De-activate' : 'Activate'),
                      ).paddingAll(4)),
              ]);
            })),
      );

  Widget _buildNoQuestion(
          {required TopicViewModel model,
          required levelId,
          required topicId,
          required subTopicId,
          required lessonId}) =>
      FutureBuilder<int>(
          future: model.getQuestions(
              levelId: levelId,
              topicId: topicId,
              subTopicId: subTopicId,
              lessonId: lessonId),
          builder: (_, snapshot) => Text(
                '${snapshot.data ?? 0}',
                style: kBody1Style.copyWith(color: const Color(0xFF120ED0)),
              ));
}
