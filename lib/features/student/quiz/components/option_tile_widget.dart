import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../../core/shared/app_colors.dart';
import '../../../../core/shared/shared_styles.dart';
import '../../../../core/shared/ui_helpers.dart';
import '../../../teacher/question/components/qns_index_widget.dart';

class OptionTileWidget extends StatelessWidget {
  const OptionTileWidget({
    Key? key,
    required this.index,
    required this.isOptionSelected,
    required this.isCorrectOption,
    required this.option,
    required this.isUserOptionCorrect,
    required this.userSelectedIndex,
  }) : super(key: key);
  final int index;
  final bool isOptionSelected;
  final bool isCorrectOption;
  final String option;
  final bool isUserOptionCorrect;
  final int userSelectedIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        QnsIndexWidget(index: index),
        hSpaceSmall,
        Text(
          option.trim(),
          textAlign: TextAlign.center,
          style: kBody1Style.copyWith(
            fontWeight: FontWeight.w800,
              color: !isOptionSelected
                  ? kcPrimaryColor
                  : (index == userSelectedIndex)
                      ? isUserOptionCorrect
                          ? Colors.white
                          : Colors.white
                      : isCorrectOption
                          ? Colors.white
                          : kcPrimaryColor),
        ),
      ],
    ).paddingAll(8).card(
        color: !isOptionSelected
            ? kcPrimaryColor.withOpacity(.2)
            : (index == userSelectedIndex)
                ? isUserOptionCorrect
                    ? kcCorrectAns
                    : kcIncorrectAns
                : isCorrectOption
                    ? kcCorrectAns
                    : kcPrimaryColor.withOpacity(.2),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: kBorderSmall));
  }
}
