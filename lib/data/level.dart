import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educate_me/data/question.dart';

class LevelModel {
  String? id;
  String? name;
  String? order;

  LevelModel({this.id, this.name, this.order});

  LevelModel.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    order = json['order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['order'] = order;
    return data;
  }

  LevelModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data() as Map<String, dynamic>);
}
