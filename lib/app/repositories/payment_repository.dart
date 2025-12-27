/*
 * File name: payment_repository.dart
 * Last modified: 2023.02.09 at 15:46:15
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2023
 */

import 'package:get/get.dart';

import '../models/payment_method_model.dart';
import '../models/payment_model.dart';
import '../models/salon_subscription_model.dart';
import '../models/wallet_model.dart';
import '../models/wallet_transaction_model.dart';
import '../providers/laravel_provider.dart';

class PaymentRepository {
  late LaravelApiClient _laravelApiClient;

  PaymentRepository() {
    _laravelApiClient = Get.find<LaravelApiClient>();
  }

  Future<List<PaymentMethod>> getMethods() {
    return _laravelApiClient.getPaymentMethods();
  }

  Future<List<Wallet>> getWallets() {
    return _laravelApiClient.getWallets();
  }

  Future<List<WalletTransaction>> getWalletTransactions(Wallet wallet) {
    return _laravelApiClient.getWalletTransactions(wallet);
  }

  Future<Wallet> createWallet(Wallet wallet) {
    return _laravelApiClient.createWallet(wallet);
  }

  Future<Wallet> updateWallet(Wallet wallet) {
    return _laravelApiClient.updateWallet(wallet);
  }

  Future<bool> deleteWallet(Wallet wallet) {
    return _laravelApiClient.deleteWallet(wallet);
  }

  Future<Payment> update(Payment payment) {
    return _laravelApiClient.updatePayment(payment);
  }

  Uri getPayPalUrl(SalonSubscription salonSubscription) {
    return _laravelApiClient.getPayPalUrl(salonSubscription);
  }

  Uri getRazorPayUrl(SalonSubscription salonSubscription) {
    return _laravelApiClient.getRazorPayUrl(salonSubscription);
  }

  Uri getStripeUrl(SalonSubscription salonSubscription) {
    return _laravelApiClient.getStripeUrl(salonSubscription);
  }

  Uri getPayStackUrl(SalonSubscription salonSubscription) {
    return _laravelApiClient.getPayStackUrl(salonSubscription);
  }

  Uri getPayMongoUrl(SalonSubscription salonSubscription) {
    return _laravelApiClient.getPayMongoUrl(salonSubscription);
  }

  Uri getFlutterWaveUrl(SalonSubscription salonSubscription) {
    return _laravelApiClient.getFlutterWaveUrl(salonSubscription);
  }

  Uri getStripeFPXUrl(SalonSubscription salonSubscription) {
    return _laravelApiClient.getStripeFPXUrl(salonSubscription);
  }
}
