import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educate_me/data/question.dart';

class LessonModel {
  String? id;
  String? title;
  String? description;
  String? introduction;
  String? cover;
  int? maxQuestions;
  int? order;
  Timestamp? createdAt;
  List<QuestionModel>? questions;
  String? video;
  int? noCorrectToPass;
  List<String>? content;

  LessonModel(
      {this.id,
      this.title,
      this.description,
      this.introduction,
      this.cover,
      this.maxQuestions,
      this.order,
      this.createdAt,
      this.content,
      this.questions,
      this.noCorrectToPass,
      this.video});

  LessonModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    introduction = json['introduction'];
    cover = json['cover'];
    noCorrectToPass = json['no_correct_pass'] ?? 0;
    maxQuestions = json['maxQuestions'];
    order = json['order'];
    createdAt = json['createdAt'];
    if (json['questions'] != null) {
      questions = [];
      json['questions'].forEach((v) {
        questions!.add(QuestionModel.fromJson(v));
      });
    } else {
      questions = [];
    }
    if (json['content'] != null) {
      content = [];
      json['content'].forEach((v) {
        content!.add(v);
      });
    } else {
      content = [];
    }
    video = json['video'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['introduction'] = introduction;
    data['cover'] = cover;
    data['maxQuestions'] = maxQuestions;
    data['no_correct_pass'] = noCorrectToPass;
    data['order'] = order;
    data['content'] = content != null ? content!.map((e) => e).toList() : null;
    data['createdAt'] = createdAt;
    data['questions'] =
        questions != null ? questions!.map((e) => e.toJson()).toList() : null;
    data['video'] = video;
    return data;
  }

  LessonModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromJson(snapshot.data() as Map<String, dynamic>);
}
