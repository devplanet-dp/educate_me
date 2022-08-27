import 'package:educate_me/core/shared/ui_helpers.dart';
import 'package:educate_me/core/widgets/input_sheet.dart';
import 'package:educate_me/core/widgets/text_field_widget.dart';
import 'package:educate_me/features/teacher/level/teacher_level_view_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../../data/level.dart';

class AddLevelSheet extends StatelessWidget {
  const AddLevelSheet({Key? key, this.level}) : super(key: key);
  final LevelModel? level;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TeacherLevelViewModel>.reactive(
      onModelReady: (model){
        if(level!=null) {
          model.setInitData(level!);
        }
      },
      builder: (context, vm, child) => InputSheetWidget(
        isBusy: vm.isBusy,
        onCancel: () {},
        onDone: () => vm.addLevel(level),
        title: 'Add level',
        child: Form(
          key: vm.formKey,
          child: [
            vSpaceMedium,
            AppTextField(
              controller: vm.orderTEC,
              hintText: 'Level order',
              label: 'Order',
              maxLength: 3,
              isNumber: true,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter the order';
                }
                return null;
              },
            ),
            vSpaceSmall,
            AppTextField(
              controller: vm.nameTEC,
              hintText: 'Level name',
              label: 'Name',
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter the name';
                }
                return null;
              },
            ),
          ].toColumn(),
        ),
      ),
      viewModelBuilder: () => TeacherLevelViewModel(),
    );
  }
}
