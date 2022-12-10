import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educate_me/data/option.dart';

enum QuestionType { multipleChoice, inputSingle, inputMultiple, singleChoice }

class QuestionModel {
  String? id;
  int? index;
  String? question;
  List<OptionModel>? options;
  String? promptOne;
  String? promptTwo;
  bool? enableDraw;
  String? photoUrl;
  QuestionType? type;
  String? raw;

  QuestionModel(
      {this.id,
      this.index,
      this.question,
      this.options,
      this.promptOne,
      this.enableDraw,
      this.photoUrl,
      this.raw,
      this.type,
      this.promptTwo});

  QuestionModel.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      index = json['index'];
      question = json['question'];
      promptOne = json['promptOne'];
      promptTwo = json['promptTwo'];
      enableDraw = json['enableDraw'];
      photoUrl = json['photoUrl'];
      type = json['type'] != null
          ? QuestionType.values.elementAt(json['type'] ?? 0)
          : null;
      if (json['options'] != null) {
        options = [];
        json['options'].forEach((v) {
          options!.add(OptionModel.fromJson(v));
        });
        options = shuffleAnswers(options??[]);
      } else {
        options = [];
      }
    } catch (e) {}
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['index'] = index;
    data['question'] = question;
    data['promptOne'] = promptOne;
    data['promptTwo'] = promptTwo;
    data['enableDraw'] = enableDraw;
    data['photoUrl'] = photoUrl;
    data['type'] = type == null ? null : type!.index;
    data['options'] =
        options != null ? options!.map((e) => e.toJson()).toList() : [];

    return data;
  }

  QuestionModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromJson(snapshot.data() as Map<String, dynamic>);

  List<OptionModel> shuffleAnswers(List<OptionModel> original) {
    //disable shuffle for not multiple type questions
    if (original.length < 4) {
      return original;
    }
    var shouldShuffleList = original.getRange(0, 2).toList();
    var disableShuffleList = original.getRange(2, 4).toList();

    shouldShuffleList.shuffle();

    var finalList = shouldShuffleList..addAll(disableShuffleList);

    for (int i = 0; i < 4; i++) {
      finalList[i].index = i;
    }

    return finalList;
  }
}

class PracticeAnswerModel {
  int index;
  String answer;
  int attemptCount;
  AnswerState state;

  PracticeAnswerModel(
      {required this.index,
      required this.answer,
      required this.attemptCount,
      required this.state});
}

enum AnswerState {
  init,
  correct,
  tryAgain,
  checkAgain,
  failed;
}
