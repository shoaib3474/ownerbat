/*
 * File name: address_model.dart
 * Last modified: 2022.10.16 at 12:23:16
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'parents/model.dart';

class Address extends Model {
  String? _description;
  String? _address;
  double? _latitude;
  double? _longitude;
  bool? _isDefault;
  String? _userId;

  Address({String? id, String? description, String? address, double? latitude, double? longitude, String? userId, bool? isDefault}) {
    _userId = userId;
    _longitude = longitude;
    _latitude = latitude;
    _address = address;
    _description = description;
    this.id = id;
  }

  Address.fromJson(Map<String, dynamic>? json) {
    super.fromJson(json);
    _description = stringFromJson(json, 'description').replaceAll('\n', ' ');
    _address = stringFromJson(json, 'address').replaceAll('\n', ' ');
    _latitude = doubleFromJson(json, 'latitude', decimal: 10);
    _longitude = doubleFromJson(json, 'longitude', decimal: 10);
    _isDefault = boolFromJson(json, 'default');
    _userId = stringFromJson(json, 'user_id');
  }

  String get address => _address ?? '';

  set address(String? value) {
    _address = value;
  }


  String get description {
    if (hasDescription()) return _description!;
    return address.substring(0, min(address.length, 10));
  }

  set description(String? value) {
    _description = value;
  }

  bool get isDefault => _isDefault ?? false;

  set isDefault(bool? value) {
    _isDefault = value;
  }

  double get latitude => _latitude ?? 0;

  set latitude(double? value) {
    _latitude = value;
  }

  double get longitude => _longitude ?? 0;

  set longitude(double? value) {
    _longitude = value;
  }

  String? get userId => _userId ?? '';

  set userId(String? value) {
    _userId = value;
  }

  LatLng getLatLng() {
    if (isUnknown()) {
      // Default center point - user will select actual location
      return const LatLng(28.6139, 77.2090); // New Delhi, India
    } else {
      return LatLng(latitude, longitude);
    }
  }

  bool hasDescription() {
    if (_description != null && (_description?.isNotEmpty ?? false)) return true;
    return false;
  }

  bool isUnknown() {
    return _latitude == null && _longitude == null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (hasData) {
      data['id'] = id;
    }
    if (_description != null) {
      data['description'] = _description;
    }
    if (_address != null) {
      data['address'] = _address;
    }
    if (_latitude != null) {
      data['latitude'] = _latitude;
    }
    if (_longitude != null) {
      data['longitude'] = _longitude;
    }
    if (_isDefault != null) {
      data['default'] = _isDefault;
    }
    if (_userId != null) {
      data['user_id'] = _userId;
    }
    return data;
  }
}
