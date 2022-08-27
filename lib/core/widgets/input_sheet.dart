import 'package:educate_me/core/shared/shared_styles.dart';
import 'package:educate_me/core/utils/device_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

import '../shared/app_colors.dart';
import '../shared/ui_helpers.dart';
import 'busy_button.dart';

class InputSheetWidget extends StatelessWidget {
  const InputSheetWidget(
      {Key? key,
      required this.child,
      required this.onCancel,
      required this.onDone,
      required this.title, this.isBusy})
      : super(key: key);
  final Widget child;
  final VoidCallback onCancel;
  final VoidCallback onDone;
  final String title;
  final bool? isBusy;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>DeviceUtils.hideKeyboard(context),
      child: SingleChildScrollView(
        child: [
          vSpaceSmall,
          Text(
            title,
            style: kBodyStyle.copyWith(fontWeight: FontWeight.bold),
          ),
          vSpaceSmall,
          child,
          vSpaceMedium,
          [
            Expanded(
              child: BoxButtonWidget(
                buttonText: 'Cancel',
                onPressed: () => Get.back(),
                buttonColor: kcTextSecondary.withOpacity(.3),
              ),
            ),
            hSpaceSmall,
            Expanded(
              child: BoxButtonWidget(
                buttonText: 'Done',
                onPressed: onDone,
                isLoading: isBusy??false,
              ),
            )
          ].toRow(),
          vSpaceMedium,
        ].toColumn().paddingSymmetric(horizontal: 16).card(
            shape: RoundedRectangleBorder(borderRadius: kBorderSmall),
            color: kAltWhite,
            elevation: 2),
      ),
    );
  }
}