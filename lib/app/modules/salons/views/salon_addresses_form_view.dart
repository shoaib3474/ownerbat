/*
 * File name: salon_addresses_form_view.dart
 * Fixed: Runtime null crashes, map blocking, empty states
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../common/map.dart';
import '../../../../common/ui.dart';
import '../../../models/address_model.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/confirm_dialog.dart';
import '../controllers/salon_addresses_form_controller.dart';
import '../widgets/horizontal_stepper_widget.dart';
import '../widgets/step_widget.dart';

class SalonAddressesFormView extends GetView<SalonAddressesFormController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Salon Addresses".tr, style: context.textTheme.titleLarge),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
          onPressed: () async {
            controller.isCreateForm()
                ? await Get.offAndToNamed(Routes.SALONS)
                : await Get.offAndToNamed(
              Routes.SALON,
              arguments: {
                'salon': controller.salon.value,
                'heroTag': 'salon_addresses_form_back'
              },
            );
          },
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Get.theme.colorScheme.secondary,
        child: Icon(Icons.add, size: 32, color: Get.theme.primaryColor),
        onPressed: () {
          Get.toNamed(
            Routes.SALON_ADDRESS_PICKER,
            arguments: {'address': Address()},
          );
        },
      ),

      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Get.theme.primaryColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Get.theme.focusColor.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: Obx(() {
          final hasAddress = controller.salon.value.address != null;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: MaterialButton(
              onPressed: hasAddress
                  ? () async {
                await Get.toNamed(
                  Routes.SALON_FORM,
                  arguments: {'salon': controller.salon.value},
                );
              }
                  : null,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              disabledColor: Get.theme.focusColor,
              color: Get.theme.colorScheme.secondary,
              elevation: 0,
              child: Text(
                "Save & Next".tr,
                style: Get.textTheme.bodyMedium?.copyWith(
                  color: Get.theme.primaryColor,
                ),
              ),
            ),
          );
        }),
      ),

      body: ListView(
        padding: EdgeInsets.only(bottom: 80),
        children: [
          HorizontalStepperWidget(
            controller: ScrollController(),
            steps: [
              StepWidget(
                title: Text("Addresses".tr),
                index: Text("1", style: TextStyle(color: Get.theme.primaryColor)),
              ),
              StepWidget(
                title: Text("Salon Details".tr),
                color: Get.theme.focusColor,
                index: Text("2", style: TextStyle(color: Get.theme.primaryColor)),
              ),
              StepWidget(
                title: Text("Availability".tr),
                color: Get.theme.focusColor,
                index: Text("3", style: TextStyle(color: Get.theme.primaryColor)),
              ),
            ],
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(22, 25, 22, 5),
            child: Text(
              "Addresses details".tr,
              style: Get.textTheme.headlineSmall,
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 22),
            child: Text(
              "Select from your addresses".tr,
              style: Get.textTheme.bodySmall,
            ),
          ),

          Obx(() {
            if (controller.addresses.isEmpty) {
              return Container(
                margin: EdgeInsets.all(20),
                decoration: Ui.getBoxDecoration(),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.withOpacity(0.15),
                  highlightColor: Colors.grey.withOpacity(0.05),
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              );
            }

            return Container(
              margin: EdgeInsets.all(20),
              decoration: Ui.getBoxDecoration(),
              child: Column(
                children: [
                  /// MAP (FAIL-SAFE)
                  ClipRRect(
                    borderRadius:
                    BorderRadius.vertical(top: Radius.circular(10)),
                    child: Builder(
                      builder: (_) {
                        try {
                          final address = controller.salon.value.address;
                          if (address == null) return SizedBox(height: 150);
                          return MapsUtil.getStaticMaps(
                            [address.getLatLng()],
                          );
                        } catch (_) {
                          return SizedBox(height: 150);
                        }
                      },
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.fromLTRB(20, 20, 5, 10),
                    decoration: BoxDecoration(
                      color: Get.theme.primaryColor,
                      borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(10)),
                    ),
                    child: Column(
                      children: controller.addresses.map((address) {
                        final selectedId =
                            controller.salon.value.address?.id;
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Transform.scale(
                              scale: 1.4,
                              child: Checkbox(
                                value: selectedId == address.id,
                                onChanged: (value) {
                                  if (value == true) {
                                    controller.toggleAddress(true, address);
                                  }
                                },
                                checkColor:
                                Get.theme.colorScheme.secondary,
                                fillColor:
                                MaterialStateProperty.all(
                                  Get.theme.colorScheme.secondary
                                      .withOpacity(0.2),
                                ),
                              ),
                            ),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(address.description,
                                      style:
                                      Get.textTheme.titleSmall),
                                  SizedBox(height: 5),
                                  Text(address.address,
                                      style:
                                      Get.textTheme.bodySmall),
                                ],
                              ),
                            ),

                            IconButton(
                              icon: Icon(Icons.edit_outlined),
                              color:
                              Get.theme.colorScheme.secondary,
                              onPressed: () {
                                Get.toNamed(
                                  Routes.SALON_ADDRESS_PICKER,
                                  arguments: {'address': address},
                                );
                              },
                            ),

                            IconButton(
                              icon: Icon(Icons.delete_outlined),
                              color: Colors.redAccent,
                              onPressed: () async {
                                final confirm =
                                await showDialog<bool>(
                                  context: context,
                                  builder: (_) => ConfirmDialog(
                                    title: "Delete Address".tr,
                                    content:
                                    "Are you sure you want to delete this address?"
                                        .tr,
                                    submitText: "Submit".tr,
                                    cancelText: "Cancel".tr,
                                  ),
                                );
                                if (confirm == true &&
                                    address.hasData) {
                                  await controller
                                      .deleteAddress(address);
                                }
                              },
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
