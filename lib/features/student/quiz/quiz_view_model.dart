import 'package:educate_me/core/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../data/question.dart';
import '../../../data/services/firestore_service.dart';
import '../../../locator.dart';

class QuizViewModel extends BaseViewModel {
  final _service = locator<FirestoreService>();
  final PageController pageController = PageController(initialPage: 0);

  List<QuestionModel> _questions = [];

  List<QuestionModel> get questions => _questions;

  set questions(value) {
    _questions = value;
    notifyListeners();
  }

  QuestionModel? _selectedQn;

  QuestionModel? get selectedQn => _selectedQn;

  set selectedQn(value) {
    _selectedQn = value;
    notifyListeners();
  }

  int _qnNo = 1;

  int get qnNo => _qnNo;

  _incrementQno() {
    if (qnNo < questions.length) {
      _qnNo++;
      notifyListeners();
    }
  }

  _decrementQno() {
    if (qnNo > 1) {
      _qnNo--;
      notifyListeners();
    }
  }

  goToNextQn() {
    pageController.animateToPage((pageController.page! + 1).toInt(),
        duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
    _incrementQno();
  }
  goToPrvQn() {
    pageController.animateToPage((pageController.page! - 1).toInt(),
        duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
    _decrementQno();
  }

  Future getQuestions(
      {required levelId,
      required topicId,
      required subTopicId,
      required lessonId}) async {
    setBusy(true);
    var result = await _service.getQuestions(
        levelId: levelId,
        topicId: topicId,
        subTopicId: subTopicId,
        lessonId: lessonId);
    if (!result.hasError) {
      _questions = result.data as List<QuestionModel>;
      if (_questions.isNotEmpty) {
        selectedQn = questions[0];
      }
    } else {
      showErrorMessage(message: result.errorMessage ?? '');
    }
    setBusy(false);
  }
}
