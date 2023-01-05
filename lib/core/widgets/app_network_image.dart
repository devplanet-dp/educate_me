import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:progressive_image/progressive_image.dart';

import 'package:shimmer/shimmer.dart';import 'package:styled_widget/styled_widget.dart';

import '../shared/app_colors.dart';
import 'app_logo.dart';

class AppNetworkImage extends StatelessWidget {
  final String path;
  final double? thumbHeight;
  final double? thumbWidth;
  final BoxFit? fit;

  const AppNetworkImage(
      {Key? key,
      required this.path,
      this.thumbHeight,
      this.thumbWidth,
      this.fit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProgressiveImage(
        placeholder: const NetworkImage('https://i.imgur.com/7XL923M.jpg'),
        thumbnail: const NetworkImage('https://i.imgur.com/7XL923M.jpg'),
        image: CachedNetworkImageProvider("path"),
        fit: fit ?? BoxFit.cover,
        width: thumbWidth!,
        height: thumbHeight!);

    // return CachedNetworkImage(
    //   imageUrl: path,
    //   height: thumbHeight,
    //   width: thumbWidth,
    //   fit: fit ?? BoxFit.cover,
    //   errorWidget: (_, __, ___) =>
    //       const AppLogoWidget()
    //           .decorated(color: kcPrimaryColor.withOpacity(.3)),
    //   placeholder: (_, __) =>
    //       Shimmer.fromColors(
    //           baseColor: kcStroke.withOpacity(.6),
    //           highlightColor: kcStroke.withOpacity(.4),
    //           child: Container(
    //             height: thumbHeight,
    //             width: thumbWidth,
    //             color: kcPrimaryColor.withOpacity(.4),
    //           )),
    // );
  }
}
