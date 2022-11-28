import 'package:educate_me/core/shared/app_colors.dart';
import 'package:educate_me/core/shared/shared_styles.dart';
import 'package:educate_me/core/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

class QnsIndexWidget extends StatelessWidget {
  final int index;

  const QnsIndexWidget({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      getIndexName(index),
      style: kHeading3Style.copyWith(
          color: kcPrimaryColor, fontWeight: FontWeight.w800),
    ).paddingAll(12).decorated(shape: BoxShape.circle, color: Colors.white, boxShadow: [
      BoxShadow(
        color: kcTextGrey.withOpacity(.3),
        blurRadius: 15,
        offset: const Offset(0, 1), // Shadow position
      ),
    ],);
  }
}

class QnsIndexWidgetMultiple extends StatelessWidget {
  final bool isCorrect;

  const QnsIndexWidgetMultiple({Key? key, required this.isCorrect})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.check,
      color: isCorrect ? kcPrimaryColor : Colors.transparent,
    ).paddingAll(10).decorated(shape: BoxShape.circle, color: Colors.white, boxShadow: [
      BoxShadow(
        color: kcTextGrey.withOpacity(.3),
        blurRadius: 15,
        offset: const Offset(0, 1), // Shadow position
      ),
    ],);
  }
}
