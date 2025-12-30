/*
 * File name: subscription_required_dialog.dart
 * Last modified: 2025.12.30 at 10:00:00
 * Purpose: Reusable dialog for subscription-required features
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';

void showSubscriptionRequiredPopup() {
  Get.dialog(
    AlertDialog(
      title: const Text("Subscription Required"),
      content: const Text(
        "Please activate a subscription to access this feature.",
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            Get.back();
            Get.toNamed(Routes.PACKAGES);
          },
          child: const Text("View Plans"),
        ),
      ],
    ),
    barrierDismissible: false,
  );
}
