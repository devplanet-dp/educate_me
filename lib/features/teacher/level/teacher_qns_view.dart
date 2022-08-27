import 'package:educate_me/core/shared/shared_styles.dart';
import 'package:educate_me/core/widgets/app_info.dart';
import 'package:educate_me/core/widgets/busy_overlay.dart';
import 'package:educate_me/data/level.dart';
import 'package:educate_me/features/teacher/level/level_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../core/shared/app_colors.dart';
import '../../../core/utils/device_utils.dart';
import '../question/add_qns_view.dart';

class TeacherQnsView extends StatelessWidget {
  const TeacherQnsView({Key? key, required this.level}) : super(key: key);
  final LevelModel level;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LevelViewModel>.reactive(
      onModelReady: (model) {
        model.listenToQns(level.id ?? '');
      },
      builder: (context, vm, child) => GestureDetector(
        onTap: () => DeviceUtils.hideKeyboard(context),
        child: BusyOverlay(
          show: vm.isBusy,
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: const Text('Add Questions here'),
              actions: [
                IconButton(
                    onPressed: () => vm.removeLevel(level.id ?? ''),
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

            vm.questions.isEmpty
                ? const AppInfoWidget(
                        translateKey: 'No questions found',
                        iconData: Iconsax.message_question)
                    .center()
                : _QuestionsGrid(level.id ?? ''),
          ),
        ),
      ),
      viewModelBuilder: () => LevelViewModel(),
    );
  }
}

class _QuestionsGrid extends ViewModelWidget<LevelViewModel> {
  const _QuestionsGrid(this.levelId, {Key? key}) : super(key: key);
  final String levelId;

  @override
  Widget build(BuildContext context, LevelViewModel model) {
    return GridView.count(
      crossAxisCount: 5,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      children: List.generate(model.questions.length, (index) {
        return InkWell(
          borderRadius: kBorderLarge,
          onTap: () => Get.to(() => AddQuestionView(
                id: levelId,
                question: model.questions[index],
              )),
          child: Text(
            '${index + 1}',
            style: kBodyStyle.copyWith(
                color: kcCorrectAns, fontWeight: FontWeight.bold),
          ).center(),
        ).card(shape: const CircleBorder(), color: kAltWhite, elevation: 2);
      }),
    ).paddingSymmetric(horizontal: 12);
  }
}
