import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:educate_me/core/utils/constants/app_assets.dart';

import '../shared/app_colors.dart';
import '../shared/shared_styles.dart';

class ImageUploadCard extends StatelessWidget {
  final File? images;
  final VoidCallback onBrowseTap;
  final VoidCallback onClearTap;

  const ImageUploadCard(
      {Key? key,
      this.images,
      required this.onBrowseTap,
      required this.onClearTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80.h,
      width: 80.w,
      child: images == null
          ? _AddImageButton(
              onTap: onBrowseTap,
            )
          : _FileImage(
              images: images,
              onClear: onClearTap,
            ),
    );
  }
}

class _FileImage extends StatelessWidget {
  const _FileImage({
    Key? key,
    required this.images,
    required this.onClear,
  }) : super(key: key);

  final File? images;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.file(
            images!,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
            top: 4,
            right: 4,
            child: InkWell(
              onTap: onClear,
              child: SvgPicture.asset(kIcClose),
            )),
      ],
    ).card(
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: kBorderMedium));
  }
}

class _AddImageButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddImageButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: kBorderMedium,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: kBorderMedium,
          color: kCheckBoxColor.withOpacity(.4),
        ),
        child: SvgPicture.asset(kIcPlus).center(),
      ),
    );
  }
}
