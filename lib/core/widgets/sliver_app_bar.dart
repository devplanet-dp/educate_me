import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../core/utils/constants/app_assets.dart';
import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';

class CustomSliverAppBar extends StatelessWidget {
  final String title;

  final bool showLeading;
  final Widget? action;

  final bool isDark;
  final bool showAppIcon;

  const CustomSliverAppBar(
      {Key? key,
      required this.title,
      required this.isDark,
      this.showLeading = true,
      this.action,
      this.showAppIcon = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 70,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(color: isDark ? kAltWhite : kAltBg),
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            // will be 10 by default if not provided
            sigmaX: 10,
            sigmaY: 10,
          ),
          child: FlexibleSpaceBar(
            titlePadding: EdgeInsets.zero,
            centerTitle: showAppIcon,
            title: showAppIcon
                ? Image.asset(
                    kImgLogo,
                    height: 48,
                    width: 48,
                  )
                : Row(
                    children: [
                      showLeading
                          ? GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Icon(
                                Icons.chevron_left,
                                color: isDark ? kAltWhite : kAltBg,
                              ),
                            )
                          : hSpaceSmall,
                      Text(
                        title,
                        style: kBodyStyle.copyWith(
                            color: isDark ? kAltWhite : kAltBg,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
          ),
        ),
      ),
      pinned: true,
      floating: false,
      snap: false,
      actions: [action ?? emptyBox()],
    );
  }
}
