import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educate_me/data/question.dart';

class LessonModel {
  String? id;
  String? title;
  String? description;
  String? introduction;
  String? cover;
  String? thumbnail;
  String? order;
  Timestamp? createdAt;
  List<QuestionModel>? questions;
  String? video;

  LessonModel(
      {this.id,
        this.title,
        this.description,
        this.introduction,
        this.cover,
        this.thumbnail,
        this.order,
        this.createdAt,
        this.questions,
        this.video});

  LessonModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    introduction = json['introduction'];
    cover = json['cover'];
    thumbnail = json['thumbnail'];
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
    video = json['video'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['introduction'] = introduction;
    data['cover'] = cover;
    data['thumbnail'] = thumbnail;
    data['order'] = order;
    data['createdAt'] = createdAt;
    data['questions'] =
    questions != null ? questions!.map((e) => e.toJson()).toList() : null;
    data['video'] = video;
    return data;
  }
  LessonModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromJson(snapshot.data() as Map<String, dynamic>);
}


