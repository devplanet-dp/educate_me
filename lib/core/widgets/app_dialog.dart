import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';
import '../../../core/shared/ui_helpers.dart';

import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import 'busy_button.dart';

class AppDialog extends StatelessWidget {
  final String title;
  final String desc;
  final VoidCallback? onNegativeTap;
  final VoidCallback? onPositiveTap;

  const AppDialog(
      {Key? key,
      required this.title,
      required this.desc,
      this.onNegativeTap,
      this.onPositiveTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: [
        _buldDialogHeader(),
        vSpaceMedium,
        _buildDialogContent(),
        vSpaceMedium,
        _buildDialogController(),
        vSpaceMedium,
      ]
          .toColumn(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min)
          .card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: kBorderMedium,
              ),
              elevation: 4),
    );
  }

  Widget _buildDialogController() {
    return [
      BoxButtonWidget(
          buttonText: 'text030'.tr,
          onPressed: () {
            Get.back();
          }),
      hSpaceMedium,
      BoxButtonWidget(
          buttonText: 'text031'.tr,
          onPressed: () {
            Get.back();
          }),
    ].toRow(
        crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center);
  }

  Text _buildDialogContent() {
    return Text(
      desc,
      style: kBodyStyle,
      textAlign: TextAlign.center,
    );
  }

  Container _buldDialogHeader() {
    return Container(
      decoration: const BoxDecoration(color: kcPrimaryColor),
      child: [
        const Expanded(child: SizedBox()),
        Text(
          title,
          style: kBodyStyle.copyWith(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
        const Expanded(child: SizedBox()),
        GestureDetector(
          onTap: () => Get.back(),
          child: const Icon(
            Icons.clear,
            color: Colors.white,
          ),
        )
      ]
          .toRow(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center)
          .paddingAll(8),
    );
  }
}
