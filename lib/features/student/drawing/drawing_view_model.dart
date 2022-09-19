import 'package:educate_me/core/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

class DrawingViewModel extends BaseViewModel {
  final GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();
  List<Color> strokeColors = <Color>[
    Colors.black,
    kcStrokeYellow,
    kcStrokeGreen
  ];
  Color? selectedStroke;

  void onColorSelected(index) {
    selectedStroke = strokeColors[index];
    notifyListeners();
  }
}
