import 'package:auto_size_text/auto_size_text.dart';
import 'package:educate_me/core/shared/app_colors.dart';
import 'package:educate_me/core/shared/shared_styles.dart';
import 'package:educate_me/core/shared/ui_helpers.dart';
import 'package:educate_me/data/lesson.dart';
import 'package:educate_me/features/teacher/topic/components/completed_overlay_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../../core/widgets/app_network_image.dart';

class LessonCard extends StatelessWidget {
  const LessonCard(
      {Key? key,
      required this.lesson,
      required this.onTap,
      this.isCompleted = false})
      : super(key: key);
  final LessonModel lesson;
  final VoidCallback onTap;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    final h = 120.h;
    final w = 165.w;
    return InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Positioned.fill(
                  child: AppNetworkImage(
                    path: lesson.cover ?? '',
                    thumbHeight: h,
                    thumbWidth: w,
                  ),
                ),
                Positioned(
                    bottom: 8,
                    left: 8,
                    child: Text(
                      lesson.title ?? '',
                      style: kCaptionStyle.copyWith(color: kAltWhite),
                    ).paddingAll(8).decorated(
                        color: kAltBg.withOpacity(.4),
                        borderRadius: kBorderSmall)),
                isCompleted ? const CompletedOverlayWidget() : emptyBox(),
              ],
            ).height(h).width(w),
            vSpaceSmall,
            AutoSizeText(
              lesson.description ?? '',
              maxLines: 2,
              style: kBody2Style.copyWith(color: kcTextGrey),
            ).width(w),
            vSpaceSmall
          ],
        ));
  }
}
