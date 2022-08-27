import 'package:auto_size_text/auto_size_text.dart';
import 'package:educate_me/core/shared/app_colors.dart';
import 'package:educate_me/core/shared/shared_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TileWidget extends StatelessWidget {
  final Widget header;
  final String subHeader;
  final Widget icon;
  final Color primaryColor;
  final VoidCallback onTap;
  final bool isDark;

  const TileWidget(
      {Key? key,
      required this.header,
      required this.subHeader,
      required this.icon,
      required this.primaryColor,
      required this.onTap,
      required this.isDark})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 120.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  blurRadius: 20,
                  color: isDark ? Colors.white24 : Colors.black12,
                  offset: const Offset(0.0, 4.0))
            ],
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: const [0.1, 0.5, 0.7, 0.9],
              colors: [
                primaryColor.withOpacity(0.6),
                primaryColor.withOpacity(0.7),
                primaryColor.withOpacity(0.8),
                primaryColor.withOpacity(0.9),
              ],
            )),
        child: Stack(
          children: [
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                decoration:
                    const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: Center(
                  child: icon,
                ),
              ),
            ),
            Positioned(top: 20, left: 10, child: header),
            Positioned(
              bottom: 10,
              left: 10,
              child: AutoSizeText(
                subHeader,
                maxLines: 2,
                textAlign: TextAlign.start,
                style: kBody2Style.copyWith(
                    fontWeight: FontWeight.w600, color: kcTextSecondary),
              ),
            )
          ],
        ),
      ),
    );
  }
}
