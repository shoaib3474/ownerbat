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
      title: const Text('Subscription Required'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Please activate a subscription to access this feature.',
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                title: const Text('Similar Subscriptions'),
                subtitle: const Text('View available subscription packages'),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  Get.back();
                  Get.toNamed(Routes.SIMILAR_SUBSCRIPTIONS);
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Get.back();
            Get.toNamed(Routes.PACKAGES);
          },
          child: const Text('View Plans'),
        ),
      ],
    ),
    barrierDismissible: false,
  );
}
