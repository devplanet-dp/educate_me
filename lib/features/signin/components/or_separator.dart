import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../core/shared/app_colors.dart';

class OrSeperator extends StatelessWidget {
  final bool isDark;

  const OrSeperator({Key? key, this.isDark = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
            child: Divider(
          color: isDark ? kcPrimaryColor : Colors.black,
          thickness: 1.2,
        )),
        Text(
          'or',
          style: TextStyle(color: isDark ? kcPrimaryColor : Colors.black),
        ).padding(horizontal: 24),
        Expanded(
            child: Divider(
                color: isDark ? kcPrimaryColor : Colors.black, thickness: 1.2)),
      ],
    ).padding(horizontal: 16);
  }
}
