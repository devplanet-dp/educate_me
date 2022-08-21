
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../shared/shared_styles.dart';
import '../shared/ui_helpers.dart';

class ThumbnailWidget extends StatelessWidget {
  const ThumbnailWidget({
    Key? key,
    required this.thumbnail,
    required this.thumbHeight,
    required this.thumbWidth,
    required this.onTapped,
    this.videoUrl,
    this.overLay = const SizedBox.shrink(),
    this.fileName,
  }) : super(key: key);

  final String thumbnail;
  final double thumbHeight;
  final double thumbWidth;
  final VoidCallback onTapped;
  final Widget overLay;
  final String? videoUrl;
  final String? fileName;

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kRadiusMedium),
      ),
      child: CachedNetworkImage(
        imageUrl: thumbnail,
        imageBuilder: (context, imageProvider) =>
            Container(
              height: thumbHeight,
              width: thumbWidth,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
        fit: BoxFit.cover,
        placeholder: (context, url) =>
            ShimmerView(
                thumbHeight: thumbHeight, thumbWidth: thumbWidth),
        errorWidget: (context, url, error) =>
            SizedBox(
                height: thumbHeight,
                width: thumbWidth,
                child: const Center(child: Icon(Icons.error))),
      ),
    );
  }
}
