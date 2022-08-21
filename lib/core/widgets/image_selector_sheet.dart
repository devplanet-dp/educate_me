import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';
import '../../../core/shared/ui_helpers.dart';
import 'package:educate_me/core/utils/constants/app_assets.dart';

import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';

class ImageSelectorSheet extends StatelessWidget {
  const ImageSelectorSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return [
      ListTile(
        leading: SvgPicture.asset(kIcGallery),
        title: Text(
          'text036'.tr,
          style: kBodyStyle.copyWith(
              color: Colors.white, fontWeight: FontWeight.w700),
        ),
        onTap: () {
          Get.back(result: false);
        },
      ).card(
          color: kcPrimaryColor,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(borderRadius: kBorderSmall)),
      vSpaceSmall,
      ListTile(
        shape: RoundedRectangleBorder(borderRadius: kBorderSmall),
        leading: SvgPicture.asset(kIcCamera),
        title: Text('text037'.tr,
            style: kBodyStyle.copyWith(
                color: Colors.white, fontWeight: FontWeight.w700)),
        onTap: () {
          Get.back(result: true);
        },
      ).card(
          color: kcPrimaryColor,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(borderRadius: kBorderSmall)),
    ]
        .toColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min)
        .paddingAll(16)
        .card(
            color: Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: kBorderMedium));
  }
}
