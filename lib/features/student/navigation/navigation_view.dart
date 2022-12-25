import 'dart:ffi';

import 'package:animations/animations.dart';
import 'package:educate_me/core/shared/shared_styles.dart';
import 'package:educate_me/core/shared/ui_helpers.dart';
import 'package:educate_me/core/utils/constants/app_assets.dart';
import 'package:educate_me/features/student/settings/settings_view.dart';
import 'package:educate_me/features/student/stats/stat_view.dart';
import 'package:educate_me/features/student/topic/topic_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';

import '../../../core/shared/app_colors.dart';
import 'navigation_view_model.dart';

class NavigationView extends StatelessWidget {
  const NavigationView({Key? key, this.initialIndex}) : super(key: key);
  final int? initialIndex;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NavigationViewModel>.reactive(
      onModelReady: (model) {
        model.initAppUsers();
        if (initialIndex != null) {
          model.setIndex(initialIndex ?? 0);
        }
      },
      builder: (context, model, child) => Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: PageTransitionSwitcher(
          duration: const Duration(milliseconds: 300),
          reverse: model.reverse,
          transitionBuilder: (
            Widget child,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              child: child,
            );
          },
          child: model.isBusy
              ? const Center(
                  child: CupertinoActivityIndicator(),
                )
              : getViewForIndex(model.currentIndex),
        ),
        bottomNavigationBar: _buildBottom(model),
      ),
      viewModelBuilder: () => NavigationViewModel(),
    );
  }

  Widget getViewForIndex(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return const StatView();
      case 1:
        return const TopicView();
      case 2:
        return const SettingsView();
      default:
        return Container();
    }
  }

  Widget _buildBottom(NavigationViewModel model) =>
      ResponsiveBuilder(builder: (context, _) {
        return Container(
          color: Colors.white,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _item(
                  assetName: kIcStat,
                  isSelected: model.isIndexSelected(0),
                  lable: 'text020'.tr,
                  onTap: () {
                    model.setIndex(0);
                  }),
              _item(
                  assetName: kIcTopic,
                  isSelected: model.isIndexSelected(1),
                  lable: 'text021'.tr,
                  onTap: () {
                    model.setIndex(1);
                  }),
              _item(
                  assetName: kIcSettings,
                  isSelected: model.isIndexSelected(2),
                  lable: 'text022'.tr,
                  onTap: () {
                    model.setIndex(2);
                  }),
            ],
          ).paddingSymmetric(
              horizontal: _.isTablet ? kTabPaddingHorizontal / 2 : 0),
        );
      });

  Widget _item(
          {required assetName,
          required isSelected,
          required lable,
          required VoidCallback onTap}) =>
      ResponsiveBuilder(builder: (context, _) {
        return InkWell(
          borderRadius: kBorderSmall,
          onTap: onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height:_.isTablet?0: 2.h,
                width: 20.w,
                decoration: BoxDecoration(
                    color: !isSelected ? Colors.transparent : kcPrimaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(6))),
              ),
              SvgPicture.asset(
                assetName,
                height: _.isTablet ? 42 : 24,
                width: 24,
                color: isSelected ? kcPrimaryColor : kButtonColor,
              ).paddingAll(8),
              Text(lable,
                  style: kBodyStyle.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? kcPrimaryColor
                          : const Color(0xFFCBCBCB))).paddingOnly(bottom: 2),
              vSpaceSmall
            ],
          ),
        );
      });

}
