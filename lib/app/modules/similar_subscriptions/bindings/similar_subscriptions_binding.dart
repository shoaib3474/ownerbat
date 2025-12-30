import 'package:get/get.dart';
import '../controllers/similar_subscriptions_controller.dart';

class SimilarSubscriptionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SimilarSubscriptionsController>(
      () => SimilarSubscriptionsController(),
    );
  }
}
