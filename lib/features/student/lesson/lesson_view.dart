import 'package:auto_size_text/auto_size_text.dart';
import 'package:educate_me/core/shared/app_colors.dart';
import 'package:educate_me/core/shared/shared_styles.dart';
import 'package:educate_me/core/widgets/busy_button.dart';
import 'package:educate_me/data/lesson.dart';
import 'package:educate_me/features/student/lesson/lesson_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';

import '../../../core/shared/ui_helpers.dart';
import '../../../core/widgets/image_app_bar.dart';

class LessonView extends StatelessWidget {
  const LessonView(
      {Key? key,
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
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return ViewModelBuilder<LessonViewModel>.reactive(
      builder: (context, vm, child) => Scaffold(
        extendBodyBehindAppBar: true,
        body: CustomScrollView(
          slivers: [
            ImageSliderAppBar(
              images: lesson.cover ?? '',
              title: lesson.title ?? '',
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              vSpaceMedium,
              AutoSizeText(
                'text029'.tr,
                style: kBodyStyle.copyWith(
                    color: Colors.black, fontWeight: FontWeight.w700),
              ).paddingOnly(left: 12),
              vSpaceSmall,
              Text(
                lesson.description ?? '',
                style: kBody1Style.copyWith(color: kcTextGrey),
              ).paddingSymmetric(horizontal: 12),
              vSpaceMedium,
              BoxButtonWidget(
                buttonText: 'text030'.tr,
                onPressed: () {},
                radius: 8,
              ).paddingSymmetric(horizontal: 12),
              vSpaceMedium
            ]))
          ],
        ),
      ),
      viewModelBuilder: () => LessonViewModel(),
    );
  }
}
