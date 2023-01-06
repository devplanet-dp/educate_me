import 'package:animations/animations.dart';
import 'package:educate_me/core/shared/shared_styles.dart';
import 'package:educate_me/core/shared/ui_helpers.dart';
import 'package:educate_me/core/widgets/app_network_image.dart';
import 'package:educate_me/core/widgets/busy_button.dart';
import 'package:educate_me/data/question.dart';
import 'package:educate_me/features/student/quiz/components/draw_brush_widget.dart';
import 'package:educate_me/features/student/quiz/components/option_tile_widget.dart';
import 'package:educate_me/features/student/quiz/components/speech_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../../core/widgets/text_field_widget.dart';
import '../../../../data/option.dart';
import '../quiz_view_model.dart';

class QuestionCard extends ViewModelWidget<QuizViewModel> {
  const QuestionCard({
    Key? key,
    required this.levelId,
    required this.topicId,
    required this.subTopicId,
    required this.lessonId,
    required this.drawEnabled,
  }) : super(key: key);
  final String levelId;
  final String topicId;
  final String subTopicId;
  final String lessonId;
  final bool drawEnabled;

  @override
  Widget build(BuildContext context, QuizViewModel model) {
    return ResponsiveBuilder(builder: (context, _) {
      return SingleChildScrollView(
        padding: _.isTablet ? fieldPaddingTablet * 0.6 : fieldPadding,
        child: Column(
          children: [
            vSpaceMedium,
            _buildQuestion(
                model.selectedQn?.question ?? '', model.selectedQn?.photoUrl),
            vSpaceMedium,
            [
              _buildCheckAnswerButton(model),
              const Expanded(child: SizedBox()),
              (model.selectedQn?.type == QuestionType.inputSingle && _.isTablet)
                  ? emptyBox()
                  : DrawBrushWidget(
                      qns: model.selectedQn?.question ?? '',
                      // enableDraw:  model.selectedQn?.enableDraw ?? true,
                      enableDraw: drawEnabled,
                      qid: model.selectedQn?.id ?? '',
                      onDrawOpen: () {
                        //update stats on drawing tool used
                        model.updateDrawingToolCount(
                            lesson: lessonId,
                            levelId: levelId,
                            topicId: topicId,
                            subTopicId: subTopicId);
                      },
                    ),
              hSpaceSmall,
              (model.selectedQn?.type == QuestionType.inputSingle && _.isTablet)
                  ? emptyBox()
                  : SpeechButton(
                      question: model.selectedQn,
                    ),
            ]
                .toRow(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end)
                .alignment(Alignment.topRight),
            _buildAnswer(model.selectedQn?.type ?? QuestionType.multipleChoice),
            vSpaceSmall,
          ],
        ),
      );
    });
  }

  Widget _buildQuestion(String qns, String? photoUrl) =>
      ResponsiveBuilder(builder: (context, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            photoUrl == null || photoUrl.trim().toLowerCase() == 'noimage'
                ? SizedBox(
                    height: _.isTablet ? 24 : 90.h,
                  )
                : emptyBox(),
            photoUrl == null || photoUrl.trim().toLowerCase() == 'noimage'
                ? emptyBox()
                : OpenContainer(
                    closedElevation: 0,
                    closedColor: Colors.transparent,
                    closedBuilder: (_, __) => AppNetworkImage(
                          path: photoUrl,
                          thumbWidth: 212.w,
                          thumbHeight: 198.h,
                          fit: BoxFit.contain,
                        ).paddingSymmetric(horizontal: 16, vertical: 8),
                    openBuilder: (_, __) => InteractiveImage(image: photoUrl)),
            Text(
              qns,
              textAlign: TextAlign.center,
              style: kBodyStyle.copyWith(
                  fontWeight: FontWeight.w400, fontSize: _.isTablet ? 24 : 17),
            )
                .paddingAll(16)
                .decorated(
                  color: Colors.white,
                  borderRadius: kBorderSmall,
                  boxShadow: [
                    const BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.05),
                      blurRadius: 9,
                      offset: Offset(0, 1), // Shadow position
                    ),
                  ],
                )
                .width(_.isTablet ? Get.width * .35 : Get.width)
                .paddingSymmetric(horizontal: 16),
          ],
        );
      });

  Widget _buildAnswer(QuestionType type) {
    switch (type) {
      case QuestionType.multipleChoice:
      case QuestionType.singleChoice:
        return const SingleChoiceQns();
      case QuestionType.inputSingle:
        return InputTypeQns(
          levelId: levelId,
          topicId: topicId,
          subTopicId: subTopicId,
          lessonId: lessonId,
          drawEnabled: drawEnabled,
        );
      case QuestionType.inputMultiple:
        return const MultipleChoiceQns();
      default:
        return const SingleChoiceQns();
    }
  }

  Widget _buildCheckAnswerButton(QuizViewModel model) {
    return model.isMultipleCorrect()
        ? ResponsiveBuilder(builder: (context, _) {
            return BoxButtonWidget(
              onPressed: () => model.onMultipleOptionSelected(),
              radius: 8,
              fontSize: 16,
              buttonText: (model.getButtonStyleQuiz()['text'] as String).tr,
              buttonColor: model.getButtonStyleQuiz()['color'],
            ).height(_.isTablet ? 55 : 40).width(_.isTablet ? 200 : 150);
          })
        : const SizedBox();
  }
}

class SingleChoiceQns extends ViewModelWidget<QuizViewModel> {
  const SingleChoiceQns({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, QuizViewModel model) {
    final options = model.selectedQn?.options ?? [];
    //mix answers

    return model.isMultipleCorrect()
        ? const MultipleChoiceQns()
        : ResponsiveBuilder(builder: (context, _) {
            return _.isTablet
                ? GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 2.2,
                    crossAxisSpacing: 32,
                    mainAxisSpacing: 32,
                    children: List.generate(options.length, (index) {
                      final p = options[index];
                      return _buildOption(p, model, index);
                    }),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: options.length,
                    itemBuilder: (_, index) {
                      final p = options[index];
                      return _buildOption(p, model, index);
                    });
          });
  }

  Widget _buildOption(OptionModel p, QuizViewModel model, int order) => InkWell(
        onTap: () => model.onOptionSelected(p),
        borderRadius: kBorderSmall,
        child: OptionTileWidget(
          isMultipleCorrect: model.isMultipleCorrect(),
          index: p.index ?? 0,
          isOptionSelected: model.isAnswered(),
          isCorrectOption: p.isCorrect ?? false,
          option: p.option ?? '',
          isUserOptionCorrect: model.isUserCorrect(),
          userSelectedIndex: model.userAnsIndex(),
          order: order,
        ),
      );
}

class MultipleChoiceQns extends ViewModelWidget<QuizViewModel> {
  const MultipleChoiceQns({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, QuizViewModel model) {
    var options = model.selectedQn?.options ?? [];
    final isMultipleCorrect =
        options.where((e) => e.isCorrect ?? false).toList().length >= 2;

    //mix answers

    return ResponsiveBuilder(builder: (context, _) {
      return _.isTablet
          ? GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              childAspectRatio: 2.5,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              children: List.generate(options.length, (index) {
                final p = options[index];
                return _buildOption(p, model);
              }),
            )
          : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: options.length,
              itemBuilder: (_, index) {
                final p = options[index];
                return _buildOption(p, model);
              });
    });
  }

  Widget _buildOption(OptionModel p, QuizViewModel model) => InkWell(
        onTap: () {
          model.onMultipleOptionChecked(p);
        },
        borderRadius: kBorderSmall,
        child: MultipleCheckOptionTile(
          index: p.index ?? -1,
          isOptionSelected: model.isOptionChecked(p),
          option: p,
          state: model.selectedQn?.state ?? AnswerState.init,
        ),
      );
}

class InputTypeQns extends ViewModelWidget<QuizViewModel> {
  InputTypeQns(
      {Key? key,
      required this.levelId,
      required this.topicId,
      required this.subTopicId,
      required this.lessonId,
      required this.drawEnabled})
      : super(key: key);
  final String levelId;
  final String topicId;
  final String subTopicId;
  final String lessonId;
  final bool drawEnabled;

  @override
  Widget build(BuildContext context, QuizViewModel model) {
    final formKey = GlobalKey<FormState>();
    // controller.text = model.getUserInputAns();

    return Form(
        key: formKey,
        child: ResponsiveBuilder(builder: (context, _) {
          return _.isTablet
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: SizedBox(width: Get.width*.04,)),
                    Expanded(child: _buildButton(model, formKey)),
                     const SizedBox(width: 12,),
                    Expanded(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 60),
                        child: _buildInput(model),
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                    Expanded(
                      child: Row(
                        children: [
                          DrawBrushWidget(
                            qns: model.selectedQn?.question ?? '',
                            // enableDraw:  model.selectedQn?.enableDraw ?? true,
                            enableDraw: drawEnabled,
                            qid: model.selectedQn?.id ?? '',
                            onDrawOpen: () {
                              //update stats on drawing tool used
                              model.updateDrawingToolCount(
                                  lesson: lessonId,
                                  levelId: levelId,
                                  topicId: topicId,
                                  subTopicId: subTopicId);
                            },
                          ),
                          hSpaceSmall,
                          SpeechButton(
                            question: model.selectedQn,
                          ),
                        ],
                      ),
                    )
                  ],
                ).paddingOnly(top: 32)
              : Column(
                  children: [
                    _buildInput(model)
                        .paddingSymmetric(horizontal: Get.width * .2),
                    vSpaceMedium,
                    _buildButton(model, formKey).width(Get.width / 2)
                  ],
                );
        }));
  }

  Widget _buildInput(QuizViewModel model) =>
      ResponsiveBuilder(builder: (context, _) {
        return AppTextFieldSecondary(
          controller: model.inputController,
          hintText: 'Enter answer',
          verticalPadding: _.isTablet ? 18 : 4,
          label: '',
          isEnabled: model.selectedQn?.state == AnswerState.tryAgain
              ? false
              : !model.isAnswered(),
          align: TextAlign.center,
          minLine: 1,
          textColor: model.getButtonStyleQuiz()['color'],
          validator: (value) {
            if (value!.isEmpty) {
              return 'Enter an answer';
            }
            return null;
          },
        );
      });

  Widget _buildButton(QuizViewModel model, dynamic formKey) =>
      ResponsiveBuilder(builder: (context, _) {
        return BoxButtonWidget(
          buttonText: (model.getButtonStyleQuiz()['text'] as String).tr,
          radius: 8,
          fontSize: _.isTablet ? 18 : 14,
          buttonColor: model.getButtonStyleQuiz()['color'],
          onPressed: () {
            //check user has already answered
            if (!model.isAnswered()) {
              if (formKey.currentState!.validate()) {
                model.onInputTypeSubmit(model.inputController.text);
              }
            }
          },
        );
      });
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

class InteractiveImage extends StatelessWidget {
  const InteractiveImage({Key? key, required this.image}) : super(key: key);
  final String image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: InteractiveViewer(
              maxScale: 10,
              child: AppNetworkImage(
                path: image,
                thumbWidth: Get.width,
                thumbHeight: Get.height / 2,
                fit: BoxFit.contain,
              ).center())
          .paddingSymmetric(horizontal: 8),
    );
  }
}
