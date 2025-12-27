/*
 * Copyright (c) 2020 .
 */

import 'dart:core';

import 'parents/model.dart';

class Award extends Model {

  String? _title;
  String? _description;

  Award({String? id, String? title, String? description}) {
    this.id = id;
    _title = title;
    _description = description;
  }

  Award.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    _title = transStringFromJson(json, 'title');
    _description = transStringFromJson(json, 'description');
  }

  String? get title => _title ?? '';

  set title(String? value) {
    _title = value;
  }

  String? get description => _description ?? '';

  set description(String? value) {
    _description = value;
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    return data;
  }
}
