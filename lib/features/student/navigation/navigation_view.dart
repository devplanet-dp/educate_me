import 'package:animations/animations.dart';
import 'package:educate_me/core/utils/constants/app_assets.dart';
import 'package:educate_me/features/student/settings/settings_view.dart';
import 'package:educate_me/features/student/stats/stat_view.dart';
import 'package:educate_me/features/student/topic/topic_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';

import '../../../core/shared/app_colors.dart';
import 'navigation_view_model.dart';

class NavigationView extends StatelessWidget {
  const NavigationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NavigationViewModel>.reactive(
      onModelReady: (model) {
        model.initAppUsers();
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
          child: model.isBusy?const Center(child:CupertinoActivityIndicator(),): getViewForIndex(model.currentIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
            currentIndex: model.currentIndex,
            selectedItemColor: kcPrimaryColor,
            backgroundColor: Colors.white,
            onTap: model.setIndex,
            items: [
              _buildNavIcon(
                  assetName: kIcStat,
                  isSelected: model.currentIndex == 0,
                  name: 'text020'.tr),
              _buildNavIcon(
                  assetName: kIcTopic,
                  isSelected: model.currentIndex == 1,
                  name: 'text021'.tr),
              _buildNavIcon(
                  assetName: kIcSettings,
                  isSelected: model.currentIndex == 2,
                  name: 'text022'.tr),
            ]),
      ),
      viewModelBuilder: () => NavigationViewModel(),
    );
  }

  Widget getViewForIndex(int currentIndex) {
    switch (currentIndex) {
      case 0:return const StatView();
      case 1:return const TopicView();
      case 2:return const SettingsView();
      default:
        return Container();
    }
  }

  BottomNavigationBarItem _buildNavIcon(
          {required String assetName,
          required bool isSelected,
          required String name,
          int? count}) =>
      BottomNavigationBarItem(
        icon: SvgPicture.asset(
          assetName,
          color: isSelected ? kcPrimaryColor : kButtonColor,
        ),
        label: name,
      );
}
