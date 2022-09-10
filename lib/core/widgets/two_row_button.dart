import 'package:educate_me/core/widgets/busy_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

import '../shared/app_colors.dart';
import '../shared/ui_helpers.dart';

class TwoRowButton extends StatelessWidget {
  const TwoRowButton(
      {Key? key,
      required this.onPositiveTap,
      required this.onNegativeTap,
      required this.negativeText,
      required this.positiveText,
      required this.isBusy})
      : super(key: key);
  final VoidCallback onPositiveTap;
  final VoidCallback onNegativeTap;
  final String negativeText;
  final String positiveText;
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    return [
      Expanded(
        child: BoxButtonWidget(
            buttonText: negativeText,
            radius: 8,
            buttonColor: kButtonDisabledColor,
            textColor: kcTextDarkGrey,
            onPressed: onNegativeTap),
      ),
      hSpaceSmall,
      Expanded(
        child: BoxButtonWidget(
            isLoading: isBusy,
            buttonText: positiveText,
            radius: 8,
            onPressed: onPositiveTap),
      ),
    ].toRow().paddingSymmetric(horizontal: 16, vertical: 12);
  }
}
