import 'package:cloud_firestore/cloud_firestore.dart';

class CompletedLessonModel {
  String? levelId;
  String? topicId;
  String? subtopicId;
  String? lessonId;
  Timestamp? createdAt;

  CompletedLessonModel(
      {this.levelId,
      this.topicId,
      this.subtopicId,
      this.lessonId,
      this.createdAt});

  CompletedLessonModel.fromJson(Map<String, dynamic> json) {
    levelId = json['level_id'];
    topicId = json['topic_id'];
    subtopicId = json['subtopic_id'];
    lessonId = json['lesson_id'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['level_id'] = levelId;
    data['topic_id'] = topicId;
    data['subtopic_id'] = subtopicId;
    data['lesson_id'] = lessonId;
    data['created_at'] = createdAt;
    return data;
  }
}
