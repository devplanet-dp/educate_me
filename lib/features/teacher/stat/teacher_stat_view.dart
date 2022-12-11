import 'package:auto_size_text/auto_size_text.dart';
import 'package:educate_me/core/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../core/shared/app_colors.dart';
import '../../../core/shared/shared_styles.dart';
import '../../../core/utils/device_utils.dart';
import '../../signin/components/custom_app_bar.dart';
import '../home/teacher_home_view_model.dart';
import 'lesson_stat_view.dart';

class TeacherStatView extends StatelessWidget {
  const TeacherStatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TeacherViewModel>.reactive(
      builder: (context, vm, child) => GestureDetector(
        onTap: () => DeviceUtils.hideKeyboard(context),
        child: ResponsiveBuilder(builder: (context, _) {
          return Scaffold(
            backgroundColor: kcBg,
              appBar: const PreferredSize(
                preferredSize: Size.fromHeight(kAppToolbarHeight),
                child: AdminAppBar(title: 'Admin Statistics'),
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    height: 21.h,
                  ),
                  // AutoSizeText(
                  //   'Hey ${'Admin'}!',
                  //   maxLines: 1,
                  //   style: kHeading3Style.copyWith(
                  //       fontWeight:
                  //           _.isTablet ? FontWeight.w900 : FontWeight.w700,
                  //       fontSize: _.isTablet ? 32 : 25),
                  // ).center(),
                  // Text(
                  //   'Here are the Admin statistics!',
                  //   style: kBody1Style.copyWith(
                  //       color: kcTextGrey, fontSize: _.isTablet ? 24 : 15),
                  // ),
                  Text(
                    'Lesson Statistics',
                    style:
                        kSubheadingStyle.copyWith(fontWeight: FontWeight.w600),
                  ),
                  vSpaceMedium,
                  const Expanded(child: LessonStatView())
                ],
              ));
        }),
      ),
      viewModelBuilder: () => TeacherViewModel(),
    );
  }
}
