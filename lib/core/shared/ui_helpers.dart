import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:styled_widget/styled_widget.dart';
import 'app_colors.dart';

const Widget hSpaceTiny = SizedBox(width: 5.0);
const Widget hSpaceSmall = SizedBox(width: 10.0);
const Widget hSpaceMedium = SizedBox(width: 25.0);

const Widget vSpaceTiny = SizedBox(height: 5.0);
const Widget vSpaceSmall = SizedBox(height: 10.0);
const Widget vSpaceMedium = SizedBox(height: 25.0);
const Widget vSpaceLarge = SizedBox(height: 80.0);
const Widget vSpaceMassive = SizedBox(height: 120.0);

Widget spacedDivider = Column(
  children: const <Widget>[
    vSpaceMedium,
    Divider(color: Colors.blueGrey, height: 5.0),
    vSpaceMedium,
  ],
);

Widget verticalSpace(double height) => SizedBox(height: height);

extension CustomContext on BuildContext {
  double screenHeight({double percent = 1}) =>
      MediaQuery.of(this).size.height * percent;

  double screenWidth({double percent = 1}) =>
      MediaQuery.of(this).size.width * percent;
}

Widget emptyBox() => const SizedBox.shrink();

AppBar noTitleAppBar({bool isLight = true, bool leading = true}) {
  return AppBar(
    automaticallyImplyLeading: leading,
    backgroundColor: Colors.transparent,
    iconTheme: IconThemeData(color: isLight ? kcPrimaryColor : kAltWhite),
    elevation: 0,
  );
}

class ShimmerWidget extends StatelessWidget {
  final bool isCircle;
  final double? radius;

  const ShimmerWidget({
    Key? key,
    required this.isCircle,
    this.radius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: kcStroke,
        highlightColor: kAltBg,
        child: isCircle
            ? CircleAvatar(
                radius: radius ?? 30,
                backgroundColor: kcStroke,
              )
            : const SizedBox(
                height: 20,
                width: 50,
              ));
  }
}

class ShimmerView extends StatelessWidget {
  const ShimmerView({
    Key? key,
    required this.thumbHeight,
    required this.thumbWidth,
  }) : super(key: key);

  final double thumbHeight;
  final double thumbWidth;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
            baseColor: kcStroke,
            highlightColor: kcStroke.withOpacity(0.2),
            child: Container(
              height: thumbHeight,
              width: thumbWidth,
              color: kcStroke,
            ))
        .decorated(
            borderRadius: const BorderRadius.all(Radius.circular(12)))
        .padding(all: 8);
  }
}
// Screen Size helpers

double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;

double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;

double screenHeightPercentage(BuildContext context, {double percentage = 1}) =>
    screenHeight(context) * percentage;

double screenWidthPercentage(BuildContext context, {double percentage = 1}) =>
    screenWidth(context) * percentage;
