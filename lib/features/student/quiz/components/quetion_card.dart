import 'package:educate_me/core/shared/shared_styles.dart';
import 'package:educate_me/core/shared/ui_helpers.dart';
import 'package:educate_me/core/utils/constants/app_assets.dart';
import 'package:educate_me/core/widgets/app_network_image.dart';
import 'package:educate_me/features/student/quiz/components/option_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../../core/shared/app_colors.dart';
import '../../drawing/drawing_view.dart';
import '../quiz_view_model.dart';

class QuestionCard extends ViewModelWidget<QuizViewModel> {
  const QuestionCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, QuizViewModel model) {
    return SingleChildScrollView(
      padding: fieldPadding,
      child: Column(
        children: [
          vSpaceSmall,
          _buildQuestion(model.selectedQn?.question ?? '',model.selectedQn?.photoUrl),
          vSpaceSmall,
          _buildBrushButton(model.selectedQn?.question ?? '',
              model.selectedQn?.enableDraw ?? true)
              .alignment(Alignment.topRight),
          vSpaceSmall,
          const MultipleChoiceQns(),
        ],
      ),
    );
  }

  Widget _buildQuestion(String qns, String? photoUrl) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          photoUrl == null ? emptyBox() : AppNetworkImage(
            path: photoUrl, thumbWidth: 212.w, thumbHeight: 198.h,)
              .paddingSymmetric(horizontal: 16),
          Text(
            qns,
            textAlign: TextAlign.center,
            style: kBodyStyle.copyWith(fontWeight: FontWeight.w500),
          ).paddingAll(8).decorated(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: kcTextGrey.withOpacity(.2),
                blurRadius: 9,
                offset: const Offset(0, 1), // Shadow position
              ),
            ],
          ).width(Get.width),
        ],
      );

  Widget _buildBrushButton(String qns, bool enableDraw) =>
      InkWell(
        borderRadius: kBorderLarge,
        onTap: () =>
            Get.dialog(
                enableDraw ? DrawQnsView(question: qns) : const DisableDraw(),
                barrierDismissible: false),
        child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: enableDraw ? Colors.white : kErrorRed.withOpacity(.3),
              boxShadow: [
                BoxShadow(
                  color: kcTextGrey.withOpacity(.2),
                  blurRadius: 10,
                  offset: const Offset(0, 1), // Shadow position
                ),
              ],
            ),
            child: Image.asset(
              kIcBrush,
              height: 20.h,
              width: 20.h,
              color: enableDraw ? Colors.black : kErrorRed,
            ).paddingAll(8)).paddingSymmetric(vertical: 12),
      );
}

class MultipleChoiceQns extends ViewModelWidget<QuizViewModel> {
  const MultipleChoiceQns({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, QuizViewModel model) {
    final options = model.selectedQn?.options ?? [];
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: options.length,
        itemBuilder: (_, index) {
          final p = options[index];
          return InkWell(
            onTap: () => model.onOptionSelected(p),
            borderRadius: kBorderSmall,
            child: OptionTileWidget(
              index: p.index ?? 0,
              isOptionSelected: model.isAnswered(),
              isCorrectOption: p.isCorrect ?? false,
              option: p.option ?? '',
              isUserOptionCorrect: model.isUserCorrect(),
              userSelectedIndex: model.userAnsIndex(),
            ),
          );
        });
  }
}

class DrawingPadWidget extends StatefulWidget {
  const DrawingPadWidget({Key? key}) : super(key: key);

  @override
  State<DrawingPadWidget> createState() => _DrawingPadWidgetState();
}

class _DrawingPadWidgetState extends State<DrawingPadWidget> {
  var _currentColor = Colors.black;
  var _currentWidth = 4.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 32),
          const Text('DRAW WHAT YOU WANT!'),
          const SizedBox(height: 120),
          const SizedBox(height: 32),
          Wrap(
            spacing: 16,
            children: [
              Colors.black,
              Colors.blue,
              Colors.red,
              Colors.green,
              Colors.yellow
            ].map(
                  (color) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentColor = color;
                    });
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 40,
                      height: 40,
                      color: color,
                      child: Center(
                        child: _currentColor == color
                            ? const Icon(
                          Icons.brush,
                          color: Colors.white,
                        )
                            : const SizedBox.shrink(),
                      ),
                    ),
                  ),
                );
              },
            ).toList(),
          ),
          const SizedBox(height: 32),
          Slider(
            max: 40,
            min: 1,
            value: _currentWidth,
            onChanged: (value) {
              setState(() {
                _currentWidth = value;
              });
            },
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}
