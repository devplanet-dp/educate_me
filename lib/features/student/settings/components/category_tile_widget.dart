import 'package:educate_me/core/shared/app_colors.dart';
import 'package:educate_me/core/shared/shared_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class CategoryTileWidget extends StatelessWidget {
  const CategoryTileWidget(
      {Key? key,
      required this.icon,
      required this.backgroundColor,
      required this.title,
      required this.onTap,  this.isBusy=false})
      : super(key: key);
  final String icon;
  final Color backgroundColor;
  final String title;
  final VoidCallback onTap;
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title.tr,style: kBody1Style.copyWith(fontWeight: FontWeight.w500),),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
          backgroundColor: backgroundColor.withOpacity(.2), child: SvgPicture.asset(icon)),
      trailing: isBusy?const CupertinoActivityIndicator(): const Icon(
        Icons.keyboard_arrow_right,
        color: kcTextDarkGrey,
      ),
    );
  }
}
