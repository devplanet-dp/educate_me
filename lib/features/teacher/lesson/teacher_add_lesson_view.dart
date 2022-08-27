import 'package:educate_me/features/teacher/lesson/teacher_lesson_view_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../core/utils/device_utils.dart';

class TeacherAddLessonView extends StatelessWidget {
  const TeacherAddLessonView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TeacherLessonViewModel>.reactive(
      builder: (context, vm, child) => GestureDetector(
        onTap: () => DeviceUtils.hideKeyboard(context),
        child: Container(),
      ),
      viewModelBuilder: () => TeacherLessonViewModel(),
    );
  }
}
