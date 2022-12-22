import 'package:auto_size_text/auto_size_text.dart';
import 'package:educate_me/data/option.dart';
import 'package:educate_me/data/question.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../../core/shared/app_colors.dart';
import '../../../../core/shared/shared_styles.dart';
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
    required this.isMultipleCorrect,
  }) : super(key: key);
  final int index;
  final bool isOptionSelected;
  final bool isCorrectOption;
  final String option;
  final bool isUserOptionCorrect;
  final int userSelectedIndex;
  final bool isMultipleCorrect;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, _) {
      var tileColor = !isOptionSelected
          ? kcOptionColor
          : (index == userSelectedIndex)
              ? isUserOptionCorrect
                  ? isMultipleCorrect
                      ? kcPrimaryColor
                      : kcCorrectAns
                  : kcIncorrectAns
              : isCorrectOption
                  ? isMultipleCorrect
                      ? kcPrimaryColor
                      : kcCorrectAns
                  : kcOptionColor;

      var indexColor = !isOptionSelected
          ? kcPrimaryColor
          : (index == userSelectedIndex)
              ? isUserOptionCorrect
                  ? isMultipleCorrect
                      ? kcPrimaryColor
                      : kcCorrectAns
                  : kcIncorrectAns
              : isCorrectOption
                  ? isMultipleCorrect
                      ? kcPrimaryColor
                      : kcCorrectAns
                  : kcPrimaryColor;

      var optionTileColor = !isOptionSelected
          ? kcPrimaryColor
          : (index == userSelectedIndex)
              ? isUserOptionCorrect
                  ? Colors.white
                  : Colors.white
              : isCorrectOption
                  ? Colors.white
                  : kcPrimaryColor;

      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          (isMultipleCorrect && isOptionSelected)
              ? QnsIndexWidgetMultiple(
                  isCorrect: isCorrectOption,
                  index: index,
                  color: indexColor,
                  isChecked: false)
              : QnsIndexWidget(
                  index: index,
                  color: indexColor,
                ),
          _.isTablet
              ? Expanded(
                  child: AutoSizeText(
                    option.trim(),
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: kBody1Style.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: _.isTablet ? 28 : 15,
                        color: optionTileColor),
                  ).paddingAll(4),
                )
              : Text(
                  option.trim(),
                  textAlign: TextAlign.center,
                  style: kBody1Style.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: _.isTablet ? 28 : 15,
                      color: optionTileColor),
                ).paddingAll(12),
        ],
      ).height(60.h).paddingAll(_.isTablet ? 16 : 8).card(
          color: tileColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: _.isTablet ? kBorderLarge : kBorderSmall));
    });
  }
}

class MultipleCheckOptionTile extends StatelessWidget {
  const MultipleCheckOptionTile({
    Key? key,
    required this.index,
    required this.isOptionSelected,
    required this.option,
    required this.state,
  }) : super(key: key);
  final int index;
  final bool isOptionSelected;
  final OptionModel option;
  final AnswerState state;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, _) {
      var isCorrectOption = option.isCorrect ?? false;
      var optionTileColor = !isOptionSelected
          ? kcOptionColor
          : (state == AnswerState.init)
              ? kcPrimaryColor
              : state == AnswerState.checkAgain
                  ? isOptionSelected
                      ? kcPrimaryColor
                      : kcOptionColor
                  : isCorrectOption
                      ? kcCorrectAns
                      : kcIncorrectAns;

      var optionTextColor = !isOptionSelected ? kcPrimaryColor : Colors.white;

      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          QnsIndexMultiple(
            index: index,
            isChecked: isOptionSelected,
            color: optionTileColor,
          ),
          _.isTablet
              ? Expanded(
                  child: Text(
                    option.option?.trim() ?? '',
                    textAlign: TextAlign.center,
                    style: kBody1Style.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: _.isTablet ? 28 : 15,
                        color: optionTextColor),
                  ).paddingAll(4),
                )
              : Text(
                  option.option?.trim() ?? '',
                  textAlign: TextAlign.center,
                  style: kBody1Style.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: _.isTablet ? 28 : 15,
                      color: optionTextColor),
                ).paddingAll(12),
        ],
      ).height(60.h).paddingAll(_.isTablet ? 16 : 8).card(
          color: optionTileColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: _.isTablet ? kBorderLarge : kBorderSmall));
    });
  }
}
