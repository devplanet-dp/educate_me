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

  QuestionModel(
      {this.id,
      this.index,
      this.question,
      this.options,
      this.promptOne,
      this.enableDraw,
      this.photoUrl,
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
        options != null ? options!.map((e) => e.toJson()).toList() : null;
    return data;
  }

  QuestionModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromJson(snapshot.data() as Map<String, dynamic>);
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
  failed;
}
