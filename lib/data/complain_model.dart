import 'package:cloud_firestore/cloud_firestore.dart';

class ComplainModel {
  String? id;
  String? createdAt;
  String? authorId;
  String? name;
  String? email;
  String? message;

  ComplainModel(
      {this.id,
      this.createdAt,
      this.authorId,
      this.name,
      this.email,
      this.message});

  ComplainModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    authorId = json['author_id'];
    name = json['name'];
    email = json['email'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['created_at'] = createdAt;
    data['author_id'] = authorId;
    data['name'] = name;
    data['email'] = email;
    data['message'] = message;
    return data;
  }
  ComplainModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromJson(snapshot.data() as Map<String, dynamic>);
}
