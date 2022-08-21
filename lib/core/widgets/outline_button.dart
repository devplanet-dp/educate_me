import 'package:flutter/material.dart';

import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';

class LineButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color color;
  final Color textColor;
  final Color borderColor;

  const LineButton({
    Key? key,
    required this.text,
    required this.onTap,
    this.color = Colors.white,
    this.textColor = kcTextPrimary,
    this.borderColor = kcStroke,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onTap,
      padding: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      disabledColor: kcAccent,
      height: 55,
      shape: RoundedRectangleBorder(
        borderRadius: kBorderSmall,
      ),
      child: Container(
        decoration: BoxDecoration(
            color: color,
            borderRadius: kBorderSmall,
            boxShadow: shadow,
            border: Border.all(
              color: borderColor,width: 2
            )),
        child: Padding(
          padding: fieldPaddingAll,
          child: Center(
            child: Text(
              text,
              style: kBodyStyle.copyWith(
                  fontWeight: FontWeight.w700, color: textColor),
            ),
          ),
        ),
      ),
    );
  }
}
