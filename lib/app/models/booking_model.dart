/*
 * File name: booking_model.dart
 * Last modified: 2022.02.27 at 23:37:17
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'address_model.dart';
import 'booking_status_model.dart';
import 'coupon_model.dart';
import 'e_service_model.dart';
import 'option_model.dart';
import 'parents/model.dart';
import 'payment_model.dart';
import 'salon_model.dart';
import 'tax_model.dart';
import 'user_model.dart';

class Booking extends Model {
  String? _hint;
  bool? _cancel;
  bool? _atSalon;
  double? _duration;
  int? _quantity;
  BookingStatus? _status;
  User? _user;
  User? _employee;
  List<EService>? _eServices;
  Salon? _salon;
  List<Option>? _options;
  List<Tax>? _taxes;
  Address? _address;
  Coupon? _coupon;
  DateTime? _bookingAt;
  DateTime? _startAt;
  DateTime? _endsAt;
  Payment? _payment;

  Booking(
      {String? id,
      String? hint,
      bool? cancel,
      bool? atSalon,
      double? duration,
      int? quantity,
      BookingStatus? status,
      User? user,
      User? employee,
      List<EService>? eServices,
      Salon? salon,
      List<Option>? options,
      List<Tax>? taxes,
      Address? address,
      Coupon? coupon,
      DateTime? bookingAt,
      DateTime? startAt,
      DateTime? endsAt,
      Payment? payment,
      double? total,
      double? subTotal,
      double? taxesValue}) {
    this.id = id;
    _hint = hint;
    _cancel = cancel;
    _atSalon = atSalon;
    _duration = duration;
    _quantity = quantity;
    _status = status;
    _user = user;
    _employee = employee;
    _eServices = eServices;
    _salon = salon;
    _options = options;
    _taxes = taxes;
    _address = address;
    _coupon = coupon;
    _bookingAt = bookingAt;
    _startAt = startAt;
    _endsAt = endsAt;
    _payment = payment;
  }

  Booking.fromJson(Map<String, dynamic>? json) {
    super.fromJson(json);
    _hint = stringFromJson(json, 'hint');
    _cancel = boolFromJson(json, 'cancel');
    _atSalon = boolFromJson(json, 'at_salon');
    _duration = doubleFromJson(json, 'duration');
    _quantity = intFromJson(json, 'quantity');
    _status = objectFromJson(json, 'booking_status', (v) => BookingStatus.fromJson(v));
    _user = objectFromJson(json, 'user', (v) => User.fromJson(v));
    _employee = objectFromJson(json, 'employee', (v) => User.fromJson(v));
    _eServices = listFromJson(json, 'e_services', (v) => EService.fromJson(v));
    _salon = objectFromJson(json, 'salon', (v) => Salon.fromJson(v));
    _address = objectFromJson(json, 'address', (v) => Address.fromJson(v));
    _coupon = objectFromJson(json, 'coupon', (v) => Coupon.fromJson(v));
    _payment = objectFromJson(json, 'payment', (v) => Payment.fromJson(v));
    _options = listFromJson(json, 'options', (v) => Option.fromJson(v));
    _taxes = listFromJson(json, 'taxes', (v) => Tax.fromJson(v));
    _bookingAt = dateFromJson(json, 'booking_at', defaultValue: null);
    _startAt = dateFromJson(json, 'start_at', defaultValue: null);
    _endsAt = dateFromJson(json, 'ends_at', defaultValue: null);
  }

  String? get hint => _hint;
  set hint(String? hint) => _hint = hint;

  bool? get cancel => _cancel;
  set cancel(bool? cancel) => _cancel = cancel;

  bool? get atSalon => _atSalon;
  set atSalon(bool? atSalon) => _atSalon = atSalon;

  double? get duration => _duration;
  set duration(double? duration) => _duration = duration;

  int? get quantity => _quantity;
  set quantity(int? quantity) => _quantity = quantity;

  BookingStatus? get status => _status;
  set status(BookingStatus? status) => _status = status;

  User? get user => _user;
  set user(User? user) => _user = user;

  User? get employee => _employee;
  set employee(User? employee) => _employee = employee;

  List<EService>? get eServices => _eServices;
  set eServices(List<EService>? eServices) => _eServices = eServices;

  Salon? get salon => _salon;
  set salon(Salon? salon) => _salon = salon;

  List<Option>? get options => _options;
  set options(List<Option>? options) => _options = options;

  List<Tax>? get taxes => _taxes;
  set taxes(List<Tax>? taxes) => _taxes = taxes;

  Address? get address => _address;
  set address(Address? address) => _address = address;

  Coupon? get coupon => _coupon;
  set coupon(Coupon? coupon) => _coupon = coupon;

  DateTime? get bookingAt => _bookingAt;
  set bookingAt(DateTime? bookingAt) => _bookingAt = bookingAt;

  DateTime? get startAt => _startAt;
  set startAt(DateTime? startAt) => _startAt = startAt;

  DateTime? get endsAt => _endsAt;
  set endsAt(DateTime? endsAt) => _endsAt = endsAt;

  Payment? get payment => _payment;
  set payment(Payment? payment) => _payment = payment;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.hasData) {
      data['id'] = this.id;
    }
    if (this.hint != null) {
      data['hint'] = this.hint;
    }
    if (this.duration != null) {
      data['duration'] = this.duration;
    }
    if (this.quantity != null) {
      data['quantity'] = this.quantity;
    }
    if (this.cancel != null) {
      data['cancel'] = this.cancel;
    }
    if (this.status != null) {
      data['booking_status_id'] = this.status!.id;
    }
    if (this.coupon != null && this.coupon!.id != null) {
      data['code'] = this.coupon!.code;
    }
    if (this.taxes != null) {
      data['taxes'] = this.taxes!.map((e) => e.toJson()).toList();
    }
    if (this.options != null && this.options!.isNotEmpty) {
      data['options'] = this.options!.map((e) => e.id).toList();
    }
    if (this.user != null) {
      data['user_id'] = this.user!.id;
    }
    if (this.employee != null) {
      data['employee_id'] = this.employee!.id;
    }
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    if (this.eServices != null) {
      data['e_services'] = this.eServices!.map((e) => e.id).toList();
    }
    if (this.salon != null) {
      data['salon_id'] = this.salon!.id;
    }
    if (this.payment != null) {
      data['payment'] = this.payment!.toJson();
    }
    if (this.bookingAt != null) {
      data['booking_at'] = bookingAt!.toUtc().toString();
    }
    if (this.startAt != null) {
      data['start_at'] = startAt!.toUtc().toString();
    }
    if (this.endsAt != null) {
      data['ends_at'] = endsAt!.toUtc().toString();
    }
    return data;
  }

  bool get canBookingAtSalon {
    return this.eServices!.fold<bool>(true, (previousValue, element) => previousValue && element.enableAtSalon!);
  }

  bool get canBookingAtCustomerAddress {
    return this.eServices!.fold<bool>(true, (previousValue, element) => previousValue && element.enableAtCustomerAddress!);
  }

  double getTotal() {
    double total = getSubtotal();
    total += getTaxesValue();
    total -= getCouponValue();
    return total;
  }

  double getTaxesValue() {
    double total = getSubtotal();
    double taxValue = 0.0;
    taxes?.forEach((element) {
      if (element.type == 'percent') {
        taxValue += (total * element.value / 100);
      } else {
        taxValue += element.value;
      }
    });
    return taxValue;
  }

  double getCouponValue() {
    return coupon?.value ?? 0;
  }

  double getSubtotal() {
    double total = 0.0;
    eServices?.forEach((element) {
      total += element.getPrice * (quantity! >= 1 ? quantity! : 1);
    });
    options?.forEach((element) {
      total += element.price! * (quantity! >= 1 ? quantity! : 1);
    });
    return total;
  }

  @override
  bool operator ==(Object? other) =>
      identical(this, other) ||
      super == other &&
          other is Booking &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          hint == other.hint &&
          cancel == other.cancel &&
          duration == other.duration &&
          quantity == other.quantity &&
          status == other.status &&
          user == other.user &&
          eServices == other.eServices &&
          salon == other.salon &&
          options == other.options &&
          taxes == other.taxes &&
          address == other.address &&
          coupon == other.coupon &&
          bookingAt == other.bookingAt &&
          startAt == other.startAt &&
          endsAt == other.endsAt &&
          payment == other.payment;

  @override
  int get hashCode =>
      super.hashCode ^
      id.hashCode ^
      hint.hashCode ^
      cancel.hashCode ^
      duration.hashCode ^
      quantity.hashCode ^
      status.hashCode ^
      user.hashCode ^
      eServices.hashCode ^
      salon.hashCode ^
      options.hashCode ^
      taxes.hashCode ^
      address.hashCode ^
      coupon.hashCode ^
      bookingAt.hashCode ^
      startAt.hashCode ^
      endsAt.hashCode ^
      payment.hashCode;
}
