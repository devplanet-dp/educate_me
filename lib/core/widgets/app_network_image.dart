import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:styled_widget/styled_widget.dart';

import '../shared/app_colors.dart';
import 'app_logo.dart';

class AppNetworkImage extends StatelessWidget {
  final String path;
  final double? thumbHeight;
  final double? thumbWidth;

  const AppNetworkImage(
      {Key? key, required this.path, this.thumbHeight, this.thumbWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: path,
      height: thumbHeight,
      width: thumbWidth,
      fit: BoxFit.cover,
      errorWidget: (_, __, ___) => const AppLogoWidget()
          .decorated(color: kcPrimaryColor.withOpacity(.3)),
      placeholder: (_, __) => Shimmer.fromColors(
          baseColor: kcStroke.withOpacity(.6),
          highlightColor: kcStroke.withOpacity(.4),
          child: Container(
            height: thumbHeight,
            width: thumbWidth,
            color: kcPrimaryColor.withOpacity(.4),
          )),
    );
  }
}
