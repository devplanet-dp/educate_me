import 'package:educate_me/core/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:stacked/stacked.dart';

class DrawingViewModel extends BaseViewModel {
  final SignatureController signatureController = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.blue,
  );

  final List<Color> colors = [Colors.black, kcAccent, kcSecondary];

  void onColorSelected(index){
  }

}
