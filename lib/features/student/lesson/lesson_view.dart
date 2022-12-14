import 'package:educate_me/core/widgets/image_app_bar.dart';
import 'package:educate_me/data/lesson.dart';
import 'package:educate_me/features/student/lesson/components/lesson_barrier_view.dart';
import 'package:educate_me/features/student/lesson/lesson_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';

import '../../../core/shared/app_colors.dart';

class LessonView extends StatelessWidget {
  const LessonView({Key? key,
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

    return ViewModelBuilder<LessonViewModel>.reactive(
      builder: (context, vm, child) =>
          Scaffold(
              body: LessonContentPageView(
                lesson: lesson,
                levelId: levelId,
                topicId: topicId,
                subTopicId: subTopicId,
              )
          ),
      viewModelBuilder: () => LessonViewModel(),
    );
  }
}
