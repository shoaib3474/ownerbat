import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/similar_subscriptions_controller.dart';

class SimilarSubscriptionsView extends GetView<SimilarSubscriptionsController> {
  const SimilarSubscriptionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Similar Subscriptions'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Available Subscription Packages',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildSubscriptionCard(
              title: 'Basic Plan',
              price: '\$9.99',
              duration: 'per month',
              features: [
                '✓ Basic features',
                '✓ Limited access',
                '✓ Email support',
              ],
            ),
            const SizedBox(height: 12),
            _buildSubscriptionCard(
              title: 'Premium Plan',
              price: '\$19.99',
              duration: 'per month',
              features: [
                '✓ All features',
                '✓ Unlimited access',
                '✓ Priority support',
              ],
              isHighlighted: true,
            ),
            const SizedBox(height: 12),
            _buildSubscriptionCard(
              title: 'Annual Plan',
              price: '\$199.99',
              duration: 'per year',
              features: [
                '✓ All features',
                '✓ Unlimited access',
                '✓ 24/7 support',
                '✓ Save 17%',
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionCard({
    required String title,
    required String price,
    required String duration,
    required List<String> features,
    bool isHighlighted = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: isHighlighted ? Colors.green : Colors.grey.shade300,
          width: isHighlighted ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
        color: isHighlighted ? Colors.green.shade50 : Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (isHighlighted)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Popular',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              price,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            Text(
              duration,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),
            ...features.map((feature) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(feature),
              );
            }),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.snackbar(
                    'Coming Soon',
                    'Subscription feature will be available soon',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isHighlighted ? Colors.green : Colors.grey,
                ),
                child: const Text('Subscribe Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
