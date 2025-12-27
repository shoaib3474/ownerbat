/*
 * File name: salon_subscription_model.dart
 * Last modified: 2022.10.16 at 12:23:14
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'parents/model.dart';
import 'payment_model.dart';
import 'salon_model.dart';
import 'subscription_package_model.dart';

class SalonSubscription extends Model {
  Salon? _salon;
  SubscriptionPackage? _subscriptionPackage;
  DateTime? _startsAt;
  DateTime? _expiresAt;
  Payment? _payment;
  bool? _active;

  SalonSubscription(
      {String? id,
      Salon? salon,
      SubscriptionPackage? subscriptionPackage,
      DateTime? startsAt,
      DateTime? expiresAt,
      Payment? payment,
      bool? active}) {
    this.id = id;
    _salon = salon;
    _subscriptionPackage = subscriptionPackage;
    _startsAt = startsAt;
    _expiresAt = expiresAt;
    _payment = payment;
    _active = active;
  }



  SalonSubscription.fromJson(Map<String, dynamic>? json) {
    super.fromJson(json);
    _salon = objectFromJson(json, 'salon', (value) => Salon.fromJson(value));
    _subscriptionPackage = objectFromJson(json, 'subscription_package', (value) => SubscriptionPackage.fromJson(value));
    _startsAt = dateFromJson(json, 'starts_at', defaultValue: null);
    _expiresAt = dateFromJson(json, 'expires_at', defaultValue: null);
    _payment = objectFromJson(json, 'payment', (value) => Payment.fromJson(value));
    _active = boolFromJson(json, 'active');
  }

  Salon? get salon => _salon ?? Salon();

  set salon(Salon? value) {
    _salon = value;
  }

  SubscriptionPackage? get subscriptionPackage => _subscriptionPackage ?? SubscriptionPackage();

  set subscriptionPackage(SubscriptionPackage? value) {
    _subscriptionPackage = value;
  }

  DateTime? get startsAt => _startsAt ?? DateTime.now();

  set startsAt(DateTime? value) {
    _startsAt = value;
  }

  DateTime? get expiresAt => _expiresAt ?? DateTime.now();

  set expiresAt(DateTime? value) {
    _expiresAt = value;
  }

  Payment? get payment => _payment ?? Payment();

  set payment(Payment? value) {
    _payment = value;
  }

  bool? get active => _active ?? false;

  set active(bool? value) {
    _active = value;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    if (this.salon != null && this.salon!.hasData) {
      data['salon_id'] = this.salon!.id;
    }
    if (this.subscriptionPackage != null && this.subscriptionPackage!.hasData) {
      data['subscription_package_id'] = this.subscriptionPackage!.id;
    }
    if (this.startsAt != null) {
      data['starts_at'] = startsAt!.toUtc().toString();
    }
    if (this.expiresAt != null) {
      data['expires_at'] = expiresAt!.toUtc().toString();
    }
    if (this.payment != null) {
      data['payment'] = this.payment!.toJson();
    }
    if (this.active != null) {
      data['active'] = active;
    }
    return data;
  }
}
