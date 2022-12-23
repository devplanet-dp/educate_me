import 'dart:io';
import 'dart:ui';

import 'package:educate_me/core/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/shared/app_colors.dart';
import '../../../core/utils/constants/app_assets.dart';
import '../../../data/controllers/drawing_controller.dart';

class Draw extends StatefulWidget {
  const Draw({super.key, required this.qid});

  @override
  _DrawState createState() => _DrawState();
  final String qid;
}

class _DrawState extends State<Draw> {
  DrawingController controller = Get.find<DrawingController>();
  Color selectedColor = Colors.black;
  Color pickerColor = Colors.black;
  double strokeWidth = 3.0;
  List<DrawingPoints?> points = [];
  bool showBottomList = false;
  double opacity = 1.0;
  StrokeCap strokeCap = (Platform.isAndroid) ? StrokeCap.butt : StrokeCap.round;
  SelectedMode selectedMode = SelectedMode.StrokeWidth;
  List<Color> colors = [Colors.black, kcStrokeYellow, kcStrokeGreen];

  void _onClear() => setState(() => points.clear());

  @override
  void initState() {
    super.initState();
    initPastDrawing();
  }

  void initPastDrawing() async {
    controller.isBusy.value = true;
    var temp = controller.getTempDrawing(widget.qid);
    points = temp?.drawingPoints ?? [];
    // controller.selectedStroke.value = temp?.colorsIndex ?? Colors.black;
    controller.isBusy.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          RenderBox renderBox = context.findRenderObject() as RenderBox;
          points.add(DrawingPoints(
              points: renderBox.globalToLocal(details.globalPosition),
              paint: Paint()
                ..strokeCap = strokeCap
                ..isAntiAlias = true
                ..color = selectedColor.withOpacity(opacity)
                ..strokeWidth = strokeWidth));
        });
      },
      onPanStart: (details) {
        setState(() {
          RenderBox renderBox = context.findRenderObject() as RenderBox;
          points.add(DrawingPoints(
              points: renderBox.globalToLocal(details.globalPosition),
              paint: Paint()
                ..strokeCap = strokeCap
                ..isAntiAlias = true
                ..color = selectedColor.withOpacity(opacity)
                ..strokeWidth = strokeWidth));
        });
      },
      onPanEnd: (details) {
        setState(() {
          points.add(null);
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () {
                controller.onDrawingCompleted(widget.qid, points);
                Get.back();
              },
              icon: const Icon(Iconsax.close_circle),
            ),
          ),
          controller.isBusy.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : CustomPaint(
                  size: Size.fromHeight(Get.height * 0.3),
                  painter: DrawingPainter(
                    pointsList: points,
                  ),
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: getColorList(),
          ),
        ],
      ),
    );
  }

  getColorList() {
    List<Widget> listWidget = [];

    var trash = IconButton(
        onPressed: () => _onClear(), icon: SvgPicture.asset(kIcTrash));
    var eraser = IconButton(
        onPressed: () {
          setState(() {
            strokeWidth = 10;
            selectedColor = Colors.white;
          });
        },
        icon: SvgPicture.asset(kIcEraser));

    listWidget.add(trash);
    for (Color color in colors) {
      listWidget.add(colorCircle(color));
    }
    listWidget.add(eraser);
    return listWidget;
  }

  Widget colorCircle(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          strokeWidth = 3;
          selectedColor = color;
        });
      },
      child: ClipOval(
        child: Container(
          padding: const EdgeInsets.only(bottom: 16.0),
          height: 36,
          width: 36,
          color: color,
        ),
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  DrawingPainter({required this.pointsList});

  List<DrawingPoints?> pointsList;
  List<Offset> offsetPoints = [];

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < pointsList.length - 1; i++) {
      if (pointsList[i] != null && pointsList[i + 1] != null) {
        canvas.drawLine(pointsList[i]!.points, pointsList[i + 1]!.points,
            pointsList[i]!.paint);
      } else if (pointsList[i] != null && pointsList[i + 1] == null) {
        offsetPoints.clear();
        offsetPoints.add(pointsList[i]!.points);
        offsetPoints.add(Offset(
            pointsList[i]!.points.dx + 0.1, pointsList[i]!.points.dy + 0.1));
        canvas.drawPoints(PointMode.points, offsetPoints, pointsList[i]!.paint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}

class DrawingPoints {
  Paint paint;
  Offset points;

  DrawingPoints({required this.points, required this.paint});
}

enum SelectedMode { StrokeWidth, Opacity, Color }
