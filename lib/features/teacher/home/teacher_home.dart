import 'package:educate_me/core/shared/app_colors.dart';
import 'package:educate_me/core/shared/shared_styles.dart';
import 'package:educate_me/core/shared/ui_helpers.dart';
import 'package:educate_me/core/widgets/tile_widget.dart';
import 'package:educate_me/features/teacher/home/teacher_home_view_model.dart';
import 'package:educate_me/features/teacher/question/add_qns_view.dart';
import 'package:educate_me/features/teacher/question/qns_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../core/utils/device_utils.dart';

class TeacherHomeView extends StatelessWidget {
  const TeacherHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TeacherViewModel>.reactive(
      builder: (context, vm, child) => GestureDetector(
        onTap: () => DeviceUtils.hideKeyboard(context),
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: Text(
                'Hi Admin 👋',
                style: kHeading3Style.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            body: SingleChildScrollView(
              padding: fieldPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  vSpaceMedium,
                  TileWidget(
                      header: Text(
                        'Start-up questions',
                        style: kBodyStyle.copyWith(
                            color: kAltWhite, fontWeight: FontWeight.w800),
                      ),
                      subHeader: 'Edit 20 start-up questions',
                      icon: Iconsax.level,
                      primaryColor: kcPrimaryColor,
                      onTap: () => Get.to(() => const AddQuestionView()),
                      isDark: false)
                ],
              ),
            ),
          ),
        ),
      ),
      viewModelBuilder: () => TeacherViewModel(),
    );
  }
}


