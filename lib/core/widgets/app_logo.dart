import 'package:educate_me/core/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class AppLogoWidget extends StatelessWidget {
  final double radius;
  final double elevation;

  const AppLogoWidget({Key? key, this.radius = 4, this.elevation = 1})
      : super(key: key);

  @override
  Widget build(BuildContext _) {
    return const Icon(
      Iconsax.image,
      color: kcPrimaryColor,
    );
  }
}
