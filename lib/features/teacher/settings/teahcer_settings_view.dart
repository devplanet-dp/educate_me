import 'package:educate_me/features/teacher/navigation/teacher_navigation_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';

import '../../../core/shared/shared_styles.dart';
import '../../../core/utils/device_utils.dart';
import '../../signin/components/custom_app_bar.dart';
import '../home/teacher_home_view_model.dart';

class TeacherSettingsView extends StatelessWidget {
  const TeacherSettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TeacherViewModel>.reactive(
      builder: (context, vm, child) => GestureDetector(
        onTap: () => DeviceUtils.hideKeyboard(context),
        child: ResponsiveBuilder(builder: (context, _) {
          return Scaffold(
              appBar: const PreferredSize(
                preferredSize: Size.fromHeight(kToolbarHeight),
                child: AdminAppBar(title: 'Settings'),
              ),
              body: SingleChildScrollView(
                padding: _.isTablet ? fieldPaddingTablet : fieldPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      height: 21.h,
                    ),
                  ],
                ),
              ));
        }),
      ),
      viewModelBuilder: () => TeacherViewModel(),
    );
  }
}
