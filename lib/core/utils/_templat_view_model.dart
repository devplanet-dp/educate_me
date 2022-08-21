import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'device_utils.dart';


class TemplateViewModel extends BaseViewModel {
}

class TemplateView extends StatelessWidget {
  const TemplateView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TemplateViewModel>.reactive(
      builder: (context, vm, child) => GestureDetector(
        onTap: ()=>DeviceUtils.hideKeyboard(context),
        child: SafeArea(
          child: Scaffold(
            body: Container(),
          ),
        ),
      ),
      viewModelBuilder: () => TemplateViewModel(),
    );
  }
}
