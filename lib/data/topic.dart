import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educate_me/core/utils/app_utils.dart';
import 'package:educate_me/data/sub_topic.dart';

class TopicModel {
  String? id;
  String? name;
  String? cover;
  int? order;
  Timestamp? createdAt;
  List<SubTopicModel>? subtopics;
  bool? expanded;

  TopicModel(
      {this.id,
      this.name,
      this.cover,
      this.order,
        this.expanded,
      this.createdAt,
      this.subtopics});



  TopicModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    cover = json['cover'];
    order = json['order'];
    createdAt = json['createdAt'];
    if (json['subtopics'] != null) {
      subtopics = [];
      json['subtopics'].forEach((v) {
        subtopics!.add(SubTopicModel.fromJson(v));
      });
    } else {
      subtopics = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['cover'] = cover;
    data['order'] = order;
    data['createdAt'] = createdAt;
    data['subtopics'] =
        subtopics != null ? subtopics!.map((e) => e.toJson()).toList() : null;
    return data;
  }

  TopicModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromJson(snapshot.data() as Map<String, dynamic>);
}
