import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';

class ProfileWidget extends StatelessWidget {
  final bool isDark;
  final String url;
  final double radius;
  final VoidCallback onTap;
  final String name;
  final double padding;

  const ProfileWidget(
      {Key? key,
      required this.isDark,
      required this.url,
      required this.radius,
      required this.onTap,
      required this.name,
      required this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: kcPrimaryColor, width: 4)),
      child: InkWell(
        onTap: onTap,
        child: CircleAvatar(
          maxRadius: radius,
          backgroundImage:
              url.isNotEmpty ? CachedNetworkImageProvider(url) : null,
          backgroundColor: isDark ? Colors.black26 : kAltWhite,
          child: url.isEmpty ? _buildLetter(context) : emptyBox(),
        ),
      ),
    );
  }

  Widget _buildLetter(BuildContext context) => Text(
        name[0].toUpperCase(),
        style: kHeadlineStyle.copyWith(color: kcPrimaryColor),
      );
}
