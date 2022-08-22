import 'package:educate_me/data/level.dart';
import 'package:educate_me/features/teacher/level/level_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:stacked/stacked.dart';

import '../../../core/shared/app_colors.dart';
import '../../../core/utils/device_utils.dart';
import '../question/add_qns_view.dart';

class AddLessonQns extends StatelessWidget {
  const AddLessonQns({Key? key, required this.level}) : super(key: key);
  final LevelModel level;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LevelViewModel>.reactive(
      builder: (context, vm, child) => GestureDetector(
        onTap: () => DeviceUtils.hideKeyboard(context),
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: const Text('Add Questions here'),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: kcPrimaryColor,
            child: const Icon(Iconsax.add),
            onPressed: () => Get.to(() => const AddQuestionView()),
          ),
          body: Container(),
        ),
      ),
      viewModelBuilder: () => LevelViewModel(),
    );
  }
}
