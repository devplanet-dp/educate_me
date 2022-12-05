import 'dart:ui';

import 'package:educate_me/features/student/drawing/drawing_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/controllers/drawing_controller.dart';

class PaintCanvasView extends CustomPainter {
  PaintCanvasView( {Key? key, required this.points}) : super();
  final List<Offset?> points;

  DrawingController controller = Get.find<DrawingController>();



  @override
  void paint(Canvas canvas, Size size) {
    final Paint paintDetails = Paint()
      ..color = controller.selectedStroke.value
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    for (int index = 0; index < points.length; index++) {
      if (index != points.length - 1 &&
          points[index] != null &&
          points[index + 1] != null) {
        canvas.drawLine(points[index]!, points[index + 1]!, paintDetails);
      } else if (points[index] != null) {
        canvas.drawPoints(PointMode.points, [points[index]!], paintDetails);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
