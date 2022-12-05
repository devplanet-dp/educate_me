import 'package:educate_me/core/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

import '../../../data/controllers/drawing_controller.dart';

class DrawingViewModel extends BaseViewModel {
  final GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();

}
