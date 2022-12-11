import 'package:educate_me/core/shared/app_colors.dart';
import 'package:educate_me/core/shared/shared_styles.dart';
import 'package:educate_me/core/shared/ui_helpers.dart';
import 'package:educate_me/core/widgets/app_icon.dart';
import 'package:educate_me/features/teacher/topic/components/completed_overlay_widget.dart';
import 'package:educate_me/features/teacher/topic/components/locked_overlay_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../../core/widgets/app_network_image.dart';

class TopicCard extends StatelessWidget {
  const TopicCard(
      {Key? key,
      required this.url,
      required this.onTap,
      required this.title,
      this.onEditTap,
      this.isLocked = false,
      this.isCompleted = false})
      : super(key: key);
  final String url;
  final String title;
  final VoidCallback onTap;
  final VoidCallback? onEditTap;
  final bool isCompleted;
  final bool isLocked;

  @override
  Widget build(BuildContext context) {

    return ResponsiveBuilder(
      builder: (context,_) {
        final h =_.isTablet?120.h: 120.h;
        final w =_.isTablet?55.w: 165.w;
        return InkWell(
          onTap: isLocked?(){}: onTap,
          borderRadius: kBorderSmall,
          child: Stack(
            children: [
              Positioned.fill(
                child: AppNetworkImage(
                  path: url,
                  thumbHeight: h,
                  thumbWidth: w,
                ),
              ),
              Positioned(
                  bottom: 8,
                  left: 8,
                  child: Text(
                    title,
                    style: kCaptionStyle.copyWith(color: kAltWhite),
                  ).paddingAll(8).decorated(
                      color: kAltBg.withOpacity(.4), borderRadius: kBorderSmall)),
              onEditTap == null
                  ? emptyBox()
                  : Positioned(
                      right: 0,
                      top: 0,
                      child: AppIconWidget(
                        iconData: Iconsax.edit,
                        bgColor: kAltWhite,
                        iconColor: kAltBg,
                        onTap: onEditTap!,
                      )),
              isLocked ? const LockedOverlayWidget() : emptyBox(),
              isCompleted ? const CompletedOverlayWidget() : emptyBox()
            ],
          ),
        )
            .card(
                shape: RoundedRectangleBorder(borderRadius: kBorderSmall),
                elevation: 0,
                color: Colors.transparent,
                clipBehavior: Clip.antiAlias)
            .height(h)
            .width(w);
      }
    );
  }
}
