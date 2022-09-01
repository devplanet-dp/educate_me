import 'package:educate_me/features/student/stats/stat_view_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../core/utils/device_utils.dart';

class StatView extends StatelessWidget {
  const StatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StatViewModel>.reactive(
      builder: (context, vm, child) => GestureDetector(
        onTap: ()=>DeviceUtils.hideKeyboard(context),
        child: SafeArea(
          child: Scaffold(
            body: Container(),
          ),
        ),
      ),
      viewModelBuilder: () => StatViewModel(),
    );
  }
}
