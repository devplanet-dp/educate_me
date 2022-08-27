import 'package:educate_me/data/level.dart';
import 'package:educate_me/features/teacher/lesson/teacher_lesson_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../core/shared/app_colors.dart';
import '../../../core/utils/device_utils.dart';
import '../../../core/widgets/app_info.dart';
import '../../../core/widgets/busy_overlay.dart';
import '../question/add_qns_view.dart';

class TeacherLessonView extends StatelessWidget {
  const TeacherLessonView({Key? key, required this.level}) : super(key: key);
  final LevelModel level;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TeacherLessonViewModel>.reactive(
      builder: (context, vm, child) => GestureDetector(
        onTap: () => DeviceUtils.hideKeyboard(context),
        child: BusyOverlay(
          show: vm.isBusy,
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              title:  Text('Add Lessons for ${level.name}'),
              actions: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Iconsax.trash,
                      color: kErrorRed,
                    ))
              ],
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: kcPrimaryColor,
              child: const Icon(Iconsax.add),
              onPressed: () => Get.to(() => AddQuestionView(
                id: level.id ?? '',
              )),
            ),
            body:

            const AppInfoWidget(
                translateKey: 'No lessons found',
                iconData: Iconsax.message_question)
                .center()
          ),
        ),
      ),
      viewModelBuilder: () => TeacherLessonViewModel(),
    );
  }
}
