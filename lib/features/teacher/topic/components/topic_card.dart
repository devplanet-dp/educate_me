import 'package:educate_me/core/shared/app_colors.dart';
import 'package:educate_me/core/shared/shared_styles.dart';
import 'package:educate_me/core/widgets/app_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../../core/widgets/app_network_image.dart';

class TopicCard extends StatelessWidget {
  const TopicCard(
      {Key? key,
      required this.url,
      required this.onTap,
      required this.title,
      required this.onEditTap})
      : super(key: key);
  final String url;
  final String title;
  final VoidCallback onTap;
  final VoidCallback onEditTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: kBorderSmall,
      child: Stack(
        children: [
          Positioned.fill(
            child: AppNetworkImage(
              path: url,
              thumbHeight: 97.h,
              thumbWidth: 165.w,
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
          Positioned(
              right: 0,
              top: 0,
              child: AppIconWidget(
                iconData: Iconsax.edit,
                bgColor: kAltWhite,
                iconColor: kAltBg,
                onTap: onEditTap,
              ))
        ],
      ),
    ).card(
        shape: RoundedRectangleBorder(borderRadius: kBorderSmall),
        elevation: 0,
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias);
  }
}
