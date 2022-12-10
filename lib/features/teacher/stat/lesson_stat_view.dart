import 'package:educate_me/core/shared/app_colors.dart';
import 'package:educate_me/core/shared/shared_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';

import '../../../core/utils/device_utils.dart';
import '../../../data/lesson.dart';
import '../../student/topic/topic_view_model.dart';

class LessonStatView extends StatelessWidget {
  const LessonStatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TopicViewModel>.reactive(
      onModelReady: (model) {
        model.listenToLevels();
      },
      builder: (context, vm, child) => GestureDetector(
        onTap: () => DeviceUtils.hideKeyboard(context),
        child: const _LevelSection(),
      ),
      viewModelBuilder: () => TopicViewModel(),
    );
  }
}

class _LevelSection extends ViewModelWidget<TopicViewModel> {
  const _LevelSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, TopicViewModel model) {
    return SingleChildScrollView(
      padding: fieldPadding,
      child: ExpansionPanelList(
        elevation: 0,
        expandedHeaderPadding: EdgeInsets.zero,
        expansionCallback: (index, isExpanded) {
          model.levels[index].expanded = !isExpanded;
          model.notifyListeners();
        },
        children: List.generate(
            model.levels.length,
            (index) => ExpansionPanel(
                canTapOnHeader: true,
                isExpanded: model.levels[index].expanded ?? false,
                headerBuilder: (context, isOpen) => Text(
                      'Level ${model.levels[index].name ?? ''}',
                      style: kExpansionTitle,
                    ),
                body: _TopicList(model.levels[index].id ?? ''))),
      ),
    );
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
      builder: (context, vm, child) => SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: ExpansionPanelList(
          elevation: 0,
          expandedHeaderPadding: EdgeInsets.zero,
          expansionCallback: (index, isExpanded) {
            vm.topics[index].expanded = !isExpanded;
            vm.notifyListeners();
          },
          children: List.generate(
              vm.topics.length,
              (index) => ExpansionPanel(
                  canTapOnHeader: true,
                  isExpanded: vm.topics[index].expanded ?? false,
                  headerBuilder: (context, isOpen) => Text(
                        vm.topics[index].name ?? '',
                        style: kExpansionTitle.copyWith(
                            fontSize: 14.5, fontWeight: FontWeight.w400),
                      ).paddingOnly(left: 16),
                  body: _SubTopicList(
                      levelId: levelId, topicId: vm.topics[index].id ?? ''))),
        ),
      ),
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
      builder: (context, vm, child) => SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: ExpansionPanelList(
          elevation: 0,
          expandedHeaderPadding: EdgeInsets.zero,
          expansionCallback: (index, isExpanded) {
            vm.subTopics[index].expanded = !isExpanded;
            vm.notifyListeners();
          },
          children: List.generate(
              vm.subTopics.length,
              (index) => ExpansionPanel(
                  canTapOnHeader: true,
                  isExpanded: vm.subTopics[index].expanded ?? false,
                  headerBuilder: (context, isOpen) => Text(
                        vm.subTopics[index].title ?? '',
                        style: kExpansionTitle.copyWith(
                            fontSize: 13, fontWeight: FontWeight.w300),
                      ).paddingOnly(left: 24),
                  body: _LessonList(
                    levelId: levelId,
                    topicId: topicId,
                    subTopicId: vm.subTopics[index].id ?? '',
                  ))),
        ),
      ),
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
            headingTextStyle:
                kBody1Style.copyWith(color: kcTextStatColor.withOpacity(0.6)),
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
                DataCell(Text(
                  lessons[index].title ?? '',
                  style: kBodyStyle.copyWith(
                      color: kcPrimaryColor,
                      decoration: TextDecoration.underline),
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
