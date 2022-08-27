import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educate_me/data/lesson.dart';

class SubTopicModel {
  String? id;
  String? title;
  String? description;
  String? cover;
  int? order;
  Timestamp? createdAt;
  List<LessonModel>? lessons;

  SubTopicModel(
      {this.id,
        this.title,
        this.description,
        this.cover,
        this.order,
        this.createdAt,
        this.lessons});

  SubTopicModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    cover = json['cover'];
    order = json['order'];
    createdAt = json['createdAt'];
    if (json['lessons'] != null) {
      lessons = [];
      json['lessons'].forEach((v) {
        lessons!.add(LessonModel.fromJson(v));
      });
    } else {
      lessons = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['cover'] = cover;
    data['order'] = order;
    data['createdAt'] = createdAt;
    data['lessons'] =
    lessons != null ? lessons!.map((e) => e.toJson()).toList() : null;
    return data;
  }
  SubTopicModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromJson(snapshot.data() as Map<String, dynamic>);
}