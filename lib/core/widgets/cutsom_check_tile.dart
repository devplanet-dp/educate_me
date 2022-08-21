import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';

class CustomCheckTile extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onToggle;
  final String title;

  const CustomCheckTile(
      {Key? key,
      required this.isSelected,
      required this.onToggle,
      required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onToggle,
      borderRadius: kBorderSmall,
      child: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 18,
          width: 18,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              color: kCheckBoxColor),
          child: isSelected
              ? const Icon(
                  Icons.check,
                  color: kcPrimaryColor,
            size: 12,
                ).center()
              : emptyBox(),
        ),
        hSpaceMedium,
        Text(
          title,
          style: kBodyStyle,
        )
      ].toRow(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center).paddingAll(4),
    );
  }
}
