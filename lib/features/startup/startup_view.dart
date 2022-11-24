import 'package:educate_me/core/shared/app_colors.dart';
import 'package:educate_me/core/utils/constants/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';

import '../../core/shared/shared_styles.dart';
import 'startup_view_model.dart';

class StartUpView extends StatefulWidget {
  const StartUpView({Key? key}) : super(key: key);

  @override
  _StartUpViewState createState() => _StartUpViewState();
}

class _StartUpViewState extends State<StartUpView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));

    _controller.forward();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StartUpViewModel>.reactive(
      onModelReady: (model) {
        _controller.addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            model.handleStartUpLogic();
          }
        });
      },
      builder: (context, vm, child) => ResponsiveBuilder(
          builder: (ctx, _) => Scaffold(
                backgroundColor: kcPrimaryColor,
                body: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          FadeTransition(
                            opacity: Tween<double>(begin: 0.0, end: 1.0)
                                .animate(CurvedAnimation(
                                    parent: _controller,
                                    curve: const Interval(.3, 1.0,
                                        curve: Curves.easeOut))),
                            child: Column(
                              children: [
                                Image.asset(kAppLogo,height: 48.h,width: 48.w,),
                                Text(
                                  'MATH EDU ME',
                                  style: kHeading1Style.copyWith(
                                      color: Colors.white),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                        ],
                      ).paddingAll(16.h),
                    ),
                  ],
                ),
              )),
      viewModelBuilder: () => StartUpViewModel(),
    );
  }
}
