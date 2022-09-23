import 'package:educate_me/core/widgets/image_app_bar.dart';
import 'package:educate_me/data/lesson.dart';
import 'package:educate_me/features/student/lesson/components/lesson_barrier_view.dart';
import 'package:educate_me/features/student/lesson/lesson_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';

class LessonView extends StatelessWidget {
  const LessonView(
      {Key? key,
      required this.lesson,
      required this.levelId,
      required this.topicId,
      required this.subTopicId})
      : super(key: key);
  final LessonModel lesson;
  final String levelId;
  final String topicId;
  final String subTopicId;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return ViewModelBuilder<LessonViewModel>.reactive(
      builder: (context, vm, child) => Scaffold(
        extendBodyBehindAppBar: true,
        body: NestedScrollView(
          controller: vm.scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              ImageSliderAppBar(
                  images: lesson.cover ?? '', title: lesson.title ?? '')
            ];
          },
          body: Expanded(
              child: LessonContentPageView(
            lesson: lesson,
            levelId: levelId,
            topicId: topicId,
            subTopicId: subTopicId,
          ).paddingSymmetric(horizontal: 16, vertical: 16)),
        ),
      ),
      viewModelBuilder: () => LessonViewModel(),
    );
  }
}
