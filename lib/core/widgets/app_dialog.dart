import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';
import '../../../core/shared/ui_helpers.dart';

import '../shared/shared_styles.dart';
import 'busy_button.dart';

class AppDialog extends StatelessWidget {
  final String title;
  final String image;
  final VoidCallback? onNegativeTap;
  final VoidCallback? onPositiveTap;

  const AppDialog(
      {Key? key,
      required this.title,
      required this.image,
      this.onNegativeTap,
      this.onPositiveTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          vSpaceMedium,
          _buildDialogContent(),
          vSpaceMedium,
          _buildDialogController(),
          vSpaceMedium,
        ],
      )
          .card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: kBorderSmall,
              ),
              elevation: 4),
    );
  }

  Widget _buildDialogController() {
    return [
      BoxButtonWidget(
          buttonText: 'text043'.tr,
          radius: 8,
          onPressed: () {
            Get.back();
          }),
      hSpaceMedium,
      BoxButtonWidget(
          buttonText: 'text045'.tr,
          radius: 8,
          onPressed: () {
            Get.back();
          }),
    ].toRow(
        crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center);
  }

  Widget _buildHeader() {
    return SvgPicture.asset(image);
  }

  _buildDialogContent() =>Text(title,style: kBody1Style.copyWith(fontWeight: FontWeight.bold),);
}
