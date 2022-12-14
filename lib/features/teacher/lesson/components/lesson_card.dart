import 'package:auto_size_text/auto_size_text.dart';
import 'package:educate_me/core/shared/app_colors.dart';
import 'package:educate_me/core/shared/shared_styles.dart';
import 'package:educate_me/core/shared/ui_helpers.dart';
import 'package:educate_me/data/lesson.dart';
import 'package:educate_me/features/teacher/topic/components/completed_overlay_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
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

    return ResponsiveBuilder(
      builder: (context,_) {
        final h = _.isTablet?100.h:96.h;
        final w = _.isTablet?45.w: 136.w;
        return InkWell(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8)),
                        child: AppNetworkImage(
                          path: lesson.cover ?? '',
                          thumbHeight: h,
                          thumbWidth: w,
                        ),
                      ),
                    ),
                    isCompleted ? const CompletedOverlayWidget() : emptyBox(),
                  ],
                ).height(h).width(w),
                vSpaceSmall,
                AutoSizeText(
                  lesson.title ?? '',
                  maxLines: 1,
                  style: kBody2Style.copyWith(
                      color: Colors.black,
                      fontSize:_.isTablet?12: 10.sp,
                      fontWeight: FontWeight.w600),
                ).paddingSymmetric(horizontal: 12),
                AutoSizeText(
                  '${lesson.description?.trim() ?? ''}\n',
                  maxLines: 2,
                  style: kBody2Style.copyWith(color: kcTextGrey),
                ).paddingSymmetric(horizontal: 12),
                vSpaceSmall
              ],
            )).decorated(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          boxShadow: [
            BoxShadow(
              color: kcTextGrey.withOpacity(.09),
              blurRadius: 9,
              offset: const Offset(0, 1), // Shadow position
            ),
          ],
        ).width(w);
      }
    );
  }
}
