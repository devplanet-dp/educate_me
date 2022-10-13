import 'package:educate_me/data/question.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';

import '../../../../core/shared/app_colors.dart';
import '../../../../core/shared/shared_styles.dart';
import '../speech_view_model.dart';

class SpeechButton extends StatelessWidget {
  const SpeechButton({Key? key, required this.question}) : super(key: key);
  final QuestionModel? question;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SpeechViewModel>.reactive(
      onModelReady: (model) {
        model.initSpeechEngine();
      },
      builder: (context, vm, child) => InkWell(
        borderRadius: kBorderLarge,
        onTap: () => vm.speak(question),
        child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: kcTextGrey.withOpacity(.2),
                      blurRadius: 10,
                      offset: const Offset(0, 1), // Shadow position
                    ),
                  ],
                ),
                child: Icon(
                  vm.speechStat == SpeechStat.playing
                      ? CupertinoIcons.speaker_3
                      : CupertinoIcons.speaker_3,
                  size: 20.h,
                ).paddingAll(8))
            .paddingSymmetric(vertical: 12),
      ),
      viewModelBuilder: () => SpeechViewModel(),
    );
  }
}
