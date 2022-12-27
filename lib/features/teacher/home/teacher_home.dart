import 'package:educate_me/core/shared/app_colors.dart';
import 'package:educate_me/core/shared/shared_styles.dart';
import 'package:educate_me/core/widgets/app_info.dart';
import 'package:educate_me/core/widgets/loading_anim.dart';
import 'package:educate_me/core/widgets/tile_widget.dart';
import 'package:educate_me/features/teacher/home/components/add_level_sheet.dart';
import 'package:educate_me/features/teacher/home/teacher_home_view_model.dart';
import 'package:educate_me/features/teacher/level/teacher_qns_view.dart';
import 'package:educate_me/features/teacher/topic/teacher_topic_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../core/shared/ui_helpers.dart';
import '../../../core/utils/device_utils.dart';
import '../../signin/components/custom_app_bar.dart';

class TeacherHomeView extends StatelessWidget {
  const TeacherHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TeacherViewModel>.reactive(
      onModelReady: (model) {
        model.listenToLevels();
      },
      builder: (context, vm, child) => GestureDetector(
        onTap: () => DeviceUtils.hideKeyboard(context),
        child: Scaffold(
          backgroundColor: kcBg,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kAppToolbarHeight),
            child: AdminAppBar(
              title: 'Topics',
              actions: [
                (vm.multiSelect && vm.selectedQnsIds.isNotEmpty)
                    ? IconButton(
                        onPressed: () => vm.removeLevels(),
                        icon: const Icon(
                          Iconsax.trash,
                          color: kErrorRed,
                        ))
                    : emptyBox(),
                IconButton(
                    onPressed: () => vm.toggleMultiSelect(),
                    icon: Icon(
                      vm.multiSelect ? Iconsax.edit5 : Iconsax.edit,
                      color: kErrorRed,
                    ))
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: kcPrimaryColor,
            child: const Icon(Iconsax.add),
            onPressed: () => Get.bottomSheet(const AddLevelSheet(),
                isScrollControlled: true),
          ),
          body: vm.levels.isEmpty
              ? const AppInfoWidget(
                      translateKey: 'No Levels added yet',
                      iconData: Iconsax.book)
                  .center()
              : vm.isBusy
                  ? const LoadingAnim()
                  : const _LevelGrid(),
        ),
      ),
      viewModelBuilder: () => TeacherViewModel(),
    );
  }
}

class _LevelGrid extends ViewModelWidget<TeacherViewModel> {
  const _LevelGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, TeacherViewModel model) {
    return ResponsiveBuilder(builder: (context, _) {
      return GridView.count(
        crossAxisCount: _.isDesktop ? 4 : 3,
        crossAxisSpacing: 8,
        childAspectRatio: _.isDesktop ? 3 : 1,
        mainAxisSpacing: 8,
        children: List.generate(model.levels.length, (index) {
          var l = model.levels[index];
          return Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: TileWidget(
                    header: Text(
                      '${l.order}',
                      style: kHeading3Style.copyWith(
                          fontWeight: FontWeight.bold, color: kAltWhite),
                    ),
                    subHeader: l.name ?? '',
                    icon: IconButton(
                      icon: const Icon(Iconsax.edit),
                      onPressed: () => Get.bottomSheet(
                          AddLevelSheet(
                            level: l,
                          ),
                          isScrollControlled: true),
                    ),
                    primaryColor: kcPrimaryColor.withOpacity(.5),
                    onTap: () => model.multiSelect
                        ? model.onQnsSelectedForDelete(l.id ?? '')
                        : model.levels[index].order != 0
                            ? Get.to(() => TeacherTopicView(
                                  level: model.levels[index],
                                ))
                            : Get.to(() => TeacherQnsView(
                                  levelId: model.levels[index].id ?? '',
                                  isStartUp: true,
                                )),
                    isDark: false),
              ),
              Visibility(
                  visible: model.isLessonSelected(l.id ?? ''),
                  child: const Icon(
                    Icons.check,
                    size: 32,
                  )
                      .paddingAll(8)
                      .decorated(shape: BoxShape.circle, color: kcBg)),
            ],
          );
        }),
      ).paddingSymmetric(horizontal: 12, vertical: 16);
    });
  }
}
