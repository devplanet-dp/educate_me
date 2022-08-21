import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../data/question.dart';

class QnsViewModel extends BaseViewModel {
  final formKey = GlobalKey<FormState>();
  final qnsTEC = TextEditingController();

  bool _isMultiple = true;

  bool get isMultipleChoice => _isMultiple;

  set isMultipleChoice(value) {
    _isMultiple = value;
    notifyListeners();
  }

  List<Question> addedQns = [
    Question(index: 0, qns: '', isCorrect: false),
    Question(index: 1, qns: '', isCorrect: false),
    Question(index: 2, qns: '', isCorrect: false),
    Question(index: 3, qns: '', isCorrect: false),
  ];

  void updateQn(Question qns) {
    addedQns.removeAt(qns.index);
    addedQns.add(
        Question(index: qns.index, qns: qns.qns, isCorrect: qns.isCorrect));
    addedQns.sort((a, b) => a.index.compareTo(b.index));
    notifyListeners();
  }
  Future addQuestion()async{
    if(formKey.currentState!.validate()){

    }
  }

  @override
  void dispose() {
    qnsTEC.dispose();
    super.dispose();
  }
}
