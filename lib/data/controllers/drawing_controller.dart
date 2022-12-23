import 'dart:ui';

import 'package:educate_me/core/utils/app_utils.dart';
import 'package:educate_me/features/student/drawing/custom_drawing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/shared/app_colors.dart';

class DrawingController extends GetxController {
  List<Color> strokeColors = <Color>[
    Colors.black,
    kcStrokeYellow,
    kcStrokeGreen
  ];
  Rx<Color> selectedStroke = Colors.black.obs;

  List<QuestionDrawings> tempDrawings = [];

  RxBool isBusy = false.obs;

  void onDrawingCompleted(String qid, List<DrawingPoints?> points) {
    //remove item if exists
    tempDrawings.removeWhere((element) => element.qid == qid);

    tempDrawings.add(QuestionDrawings(
        qid: qid, drawingPoints: points, colorsIndex: selectedStroke.value));
  }

  QuestionDrawings? getTempDrawing(String qid) {

    if(tempDrawings.where((element) => element.qid == qid).isNotEmpty){
      return tempDrawings.singleWhere((element) => element.qid == qid);
    }
    return null;

  }

  void onColorSelected(index) {
    selectedStroke.value = strokeColors[index];
  }
}

class QuestionDrawings {
  final String qid;
  final List<DrawingPoints?> drawingPoints;
  final Color colorsIndex;

  QuestionDrawings(
      {required this.qid,
      required this.drawingPoints,
      required this.colorsIndex});
}
