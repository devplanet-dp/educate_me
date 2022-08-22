import 'package:dio/dio.dart';

class QuestionModel {
  String? id;
  String? index;
  String? question;
  List<Options>? options;

  QuestionModel({this.id, this.index, this.question, this.options});

  QuestionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    index = json['index'];
    question = json['question'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['index'] = index;
    data['question'] = question;
    data['options'] = options;
    return data;
  }
}
