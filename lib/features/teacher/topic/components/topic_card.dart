import 'package:educate_me/core/shared/app_colors.dart';
import 'package:educate_me/core/shared/shared_styles.dart';
import 'package:educate_me/core/widgets/app_network_image.dart';
import 'package:educate_me/data/topic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

class TopicCard extends StatelessWidget {
  const TopicCard({Key? key, required this.topic, required this.onTap})
      : super(key: key);
  final TopicModel topic;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: kBorderSmall,
      child: Stack(
        children: [
          Positioned.fill(
            child: AppNetworkImage(
              path: topic.cover ?? '',
              thumbHeight: 97.h,
              thumbWidth: 165.w,
            ),
          ),
          Positioned(
              bottom: 8,
              left: 8,
              child: Text(
                topic.name ?? '',
                style: kCaptionStyle.copyWith(color: kAltWhite),
              ).paddingAll(8).decorated(
                  color: kAltBg.withOpacity(.4), borderRadius: kBorderSmall))
        ],
      ),
    ).card(
        shape: RoundedRectangleBorder(borderRadius: kBorderSmall),
        elevation: 0,
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias);
  }
}
