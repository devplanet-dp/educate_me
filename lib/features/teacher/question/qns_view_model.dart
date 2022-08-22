import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../data/option.dart';

class QnsViewModel extends BaseViewModel {
  final formKey = GlobalKey<FormState>();
  final qnsTEC = TextEditingController();
  final ansTEC = TextEditingController();

  bool _isMultiple = true;

  bool get isMultipleChoice => _isMultiple;

  set isMultipleChoice(value) {
    _isMultiple = value;
    notifyListeners();
  }

  List<OptionModel> addedQns = [
    OptionModel(index: 0, option: '', isCorrect: false),
    OptionModel(index: 1, option: '', isCorrect: false),
    OptionModel(index: 2, option: '', isCorrect: false),
    OptionModel(index: 3, option: '', isCorrect: false),
  ];

  void updateQn(OptionModel qns) {
    addedQns.removeAt(qns.index);
    addedQns.add(
        OptionModel(index: qns.index, option: qns.option, isCorrect: qns.isCorrect));
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
