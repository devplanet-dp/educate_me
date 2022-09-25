import 'package:educate_me/core/shared/app_colors.dart';
import 'package:educate_me/core/utils/constants/app_assets.dart';
import 'package:educate_me/core/widgets/app_dialog.dart';
import 'package:educate_me/data/controllers/quiz_controller.dart';
import 'package:educate_me/data/question.dart';
import 'package:educate_me/data/services/firestore_service.dart';
import 'package:educate_me/features/student/quiz/quiz_view.dart';
import 'package:educate_me/locator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';

class LessonViewModel extends BaseViewModel {
  final QuizController quizController = Get.find<QuizController>();
  final PageController barrierController = PageController(initialPage: 0);
  final ScrollController scrollController = ScrollController();
  final service = locator<FirestoreService>();

  List<PracticeAnswerModel> answers = [];

  bool isAnswered(index) => answers.any((element) => element.index == index);

  String? getUserAnswer(index) => isAnswered(index)
      ? answers[answers.indexWhere((e) => e.index == index)].answer
      : null;

  bool isQuizEnabled(){
    return !answers.every((e) => e.state == AnswerState.correct || e.state==AnswerState.failed);
  }

  onQuestionAnswered(
      {required String text,
      required int index,
      required String correctAnswer}) {
    if (!isAnswered(index)) {
      answers.add(PracticeAnswerModel(
          index: index,
          answer: text,
          attemptCount: 0,
          state: AnswerState.init));
    }

    PracticeAnswerModel answerModel =
        answers[answers.indexWhere((e) => e.index == index)];
    answerModel.attemptCount++;
    answerModel.answer = text;
    if (correctAnswer.trim() == text.trim()) {
      answerModel.state = AnswerState.correct;
    } else {
      if (isAttemptExceeded(index)) {
        answerModel.state = AnswerState.failed;
      } else {
        answerModel.state = AnswerState.tryAgain;
      }
    }
    notifyListeners();
  }

  bool isAttemptExceeded(index) =>
      isAnswered(index) ? answers[index].attemptCount >= 2 : false;

  Map<int, dynamic> getButtonStyle(index) {
    if (isAnswered(index)) {
      AnswerState state =
          answers[answers.indexWhere((e) => e.index == index)].state;

      switch (state) {
        case AnswerState.init:
          return {
            index: {'text': 'text095', 'color': kcPrimaryColor}
          };
        case AnswerState.correct:
          return {
            index: {'text': 'text096', 'color': kcCorrectAns}
          };
        case AnswerState.tryAgain:
          return {
            index: {'text': 'text097', 'color': kcTryAgainAns}
          };
        case AnswerState.failed:
          return {
            index: {'text': 'text098', 'color': kcFailedAns}
          };
        default:
          return {
            index: {'text': 'text095', 'color': kcPrimaryColor}
          };
      }
    } else {
      return {
        index: {'text': 'text095', 'color': kcPrimaryColor}
      };
    }
  }

  goToNextBarrier() {
    barrierController.animateToPage((barrierController.page! + 1).toInt(),
        duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
  }

  resetScroll() {
    scrollController.animateTo(scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn);
  }

  void onStartQuizTapped(
      {required levelId,
      required topicId,
      required subTopicId,
      required lesson}) {
    Get.dialog(AppDialog(
      title: 'text045'.tr,
      image: kIcQuiz,
      onPositiveTap: () {
        Get.back();
        Get.to(() => QuizView(
            levelId: levelId,
            topicId: topicId,
            subTopicId: subTopicId,
            lesson: lesson));
      },
    ));
  }
}
