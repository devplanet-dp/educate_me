import 'package:educate_me/core/widgets/paint_canvas_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../data/controllers/drawing_controller.dart';
import '../shared/shared_styles.dart';
import '../utils/constants/app_assets.dart';

class Blackboard extends StatefulWidget {
  const Blackboard({Key? key, required this.qid}) : super(key: key);
  final String qid;

  @override
  State<Blackboard> createState() => _BlackboardState();
}

class _BlackboardState extends State<Blackboard> {
  DrawingController controller = Get.find<DrawingController>();

  List<Offset?> _drawingPoints = [];
  Color? _strokeColor;

  void _onGesture(offset) => setState(() => _drawingPoints.add(offset));

  void _onClear() => setState(() => _drawingPoints.clear());

  @override
  void initState() {
    initPastDrawing();
    super.initState();
  }

  void initPastDrawing() async {
    controller.isBusy.value = true;
    var temp = controller.getTempDrawing(widget.qid);
    _drawingPoints = temp?.drawingPoints ?? [];
    controller.selectedStroke.value = temp?.colorsIndex ?? Colors.black;
    controller.isBusy.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) => _onGesture(details.localPosition),
      onPanUpdate: (details) => _onGesture(details.localPosition),
      onPanEnd: (details) => _onGesture(null),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () {
                controller.onDrawingCompleted(widget.qid, _drawingPoints);
                Get.back();
              },
              icon: const Icon(Iconsax.close_circle),
            ),
          ),
         controller.isBusy.value?const Center(child: CircularProgressIndicator(),): CustomPaint(
            painter: PaintCanvasView(points: _drawingPoints),
            size: Size.fromHeight(Get.height * 0.3),
          ),
          _buildControllers()
        ],
      ),
    );
  }

  Widget _buildControllers() => [
        IconButton(
            onPressed: () => _onClear(), icon: SvgPicture.asset(kIcTrash)),
        _buildColorPallets(),
        IconButton(onPressed: () {}, icon: SvgPicture.asset(kIcEraser)),
      ].toRow();

  Widget _buildColorPallets() => Expanded(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
              controller.strokeColors.length,
              (index) => InkWell(
                    borderRadius: kBorderLarge,
                    onTap: () => controller.onColorSelected(index),
                    child: Container(
                      height: 28.h,
                      width: 28.w,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: controller.strokeColors[index]),
                    ).paddingSymmetric(horizontal: 8),
                  )),
        ),
      );
}
