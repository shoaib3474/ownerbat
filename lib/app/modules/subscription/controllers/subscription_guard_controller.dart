/*
 * File name: subscription_guard_controller.dart
 * Last modified: 2025.12.30 at 10:00:00
 * Purpose: Manages subscription status and guards feature access
 */

import 'package:get/get.dart';
import '../../../repositories/subscription_repository.dart';

class SubscriptionGuardController extends GetxController {
  final SubscriptionRepository _repo = SubscriptionRepository();

  final RxBool hasSubscription = false.obs;
  final RxBool loading = true.obs;

  @override
  void onInit() {
    super.onInit();
    checkSubscription();
  }

  Future<void> checkSubscription() async {
    try {
      loading.value = true;
      hasSubscription.value = await _repo.hasActiveSubscription();
    } catch (e) {
      print('Error checking subscription: $e');
      hasSubscription.value = false;
    } finally {
      loading.value = false;
    }
  }
}
