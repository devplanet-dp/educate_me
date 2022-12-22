import 'package:educate_me/core/shared/app_colors.dart';
import 'package:educate_me/core/shared/shared_styles.dart';
import 'package:educate_me/core/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:styled_widget/styled_widget.dart';

class QnsIndexWidget extends StatelessWidget {
  final int index;
  final Color color;

  const QnsIndexWidget({Key? key, required this.index, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, _) {
      return Text(
        getIndexName(index),
        style: kHeading3Style.copyWith(
            color: color,
            fontWeight: FontWeight.w800,
            fontSize: _.isTablet ? 28 : 18),
      ).paddingAll(_.isTablet ? 20 : 12).decorated(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: kcTextGrey.withOpacity(.3),
            blurRadius: 15,
            offset: const Offset(0, 1), // Shadow position
          ),
        ],
      ).paddingOnly(left: 8);
    });
  }
}

class QnsIndexWidgetMultiple extends StatelessWidget {
  final bool isCorrect;
  final int index;
  final Color color;
  final bool isChecked;

  const QnsIndexWidgetMultiple(
      {Key? key,
      required this.isCorrect,
      required this.index,
      required this.color,
      required this.isChecked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isChecked
        ? ResponsiveBuilder(builder: (context, _) {
            return Icon(
              Icons.check,
              color: color,
              size: 24,
            ).paddingAll(10).decorated(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: kcTextGrey.withOpacity(.3),
                  blurRadius: 15,
                  offset: const Offset(0, 1), // Shadow position
                ),
              ],
            );
          })
        : QnsIndexWidget(
            index: index,
            color: color,
          );
  }
}

class QnsIndexMultiple extends StatelessWidget {
  final int index;
  final Color color;
  final bool isChecked;

  const QnsIndexMultiple(
      {Key? key,
      required this.index,
      required this.color,
      required this.isChecked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, _) {
      return Icon(
        Icons.check,
        color: isChecked ? color : Colors.transparent,
        size: _.isTablet ? 32 : 24,
      )
          .paddingAll(_.isTablet ? 18 : 10)
          .decorated(shape: BoxShape.circle, color: Colors.white, boxShadow: [
        BoxShadow(
          color: kcTextGrey.withOpacity(.3),
          blurRadius: 15,
          offset: const Offset(0, 1), // Shadow position
        ),
      ]);
    });
  }
}
