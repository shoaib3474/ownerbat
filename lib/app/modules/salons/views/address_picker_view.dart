/*
 * address_picker_view.dart
 * 100% stable – NO flutter_google_places_sdk
 * Flutter 3.38 compatible
 */

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmap;

import '../../../models/address_model.dart';
import '../../../services/settings_service.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../controllers/salon_addresses_form_controller.dart';

/// ─────────────────────────────────────────
/// CONTROLLER
/// ─────────────────────────────────────────
class AddressPickerController extends GetxController {
  late Address address;
  late String apiKey;

  final Rx<gmap.LatLng> selectedLatLng =
      const gmap.LatLng(28.6139, 77.2090).obs;

  final RxString formattedAddress = ''.obs;
  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();

    address = Get.arguments['address'] as Address;
    apiKey = Get.find<SettingsService>().setting.value.googleMapsKey ?? '';

    selectedLatLng.value = gmap.LatLng(
      address.latitude ?? 28.6139,
      address.longitude ?? 77.2090,
    );
  }

  /// 🔍 AUTOCOMPLETE
  Future<List<dynamic>> search(String input) async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    final completer = Completer<List<dynamic>>();
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      final url =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json'
          '?input=$input&key=$apiKey&components=country:in';

      final res = await http.get(Uri.parse(url));
      final body = json.decode(res.body);
      completer.complete(body['predictions'] ?? []);
    });

    return completer.future;
  }

  /// 📍 PLACE DETAILS
  Future<void> selectPlace(String placeId) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/details/json'
        '?place_id=$placeId&key=$apiKey';

    final res = await http.get(Uri.parse(url));
    final body = json.decode(res.body);

    final loc = body['result']['geometry']['location'];
    formattedAddress.value = body['result']['formatted_address'];

    selectedLatLng.value = gmap.LatLng(loc['lat'], loc['lng']);

    address
      ..latitude = loc['lat']
      ..longitude = loc['lng']
      ..address = formattedAddress.value;
  }

  /// 🔁 REVERSE GEOCODE
  Future<void> reverseGeocode(gmap.LatLng latLng) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json'
        '?latlng=${latLng.latitude},${latLng.longitude}&key=$apiKey';

    final res = await http.get(Uri.parse(url));
    final body = json.decode(res.body);

    if (body['results'] != null && body['results'].isNotEmpty) {
      formattedAddress.value = body['results'][0]['formatted_address'];
      address.address = formattedAddress.value;
    }

    address
      ..latitude = latLng.latitude
      ..longitude = latLng.longitude;
  }

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }
}

/// ─────────────────────────────────────────
/// VIEW
/// ─────────────────────────────────────────
class AddressPickerView extends GetView<AddressPickerController> {
  const AddressPickerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Obx(() => Text(
          controller.formattedAddress.value.isEmpty
              ? "Pick Address".tr
              : controller.formattedAddress.value,
          overflow: TextOverflow.ellipsis,
        )),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _openSearchDialog,
          ),
        ],
      ),
      body: Stack(
        children: [
          /// MAP
          Obx(() => gmap.GoogleMap(
            initialCameraPosition: gmap.CameraPosition(
              target: controller.selectedLatLng.value,
              zoom: 15,
            ),
            onTap: (latLng) async {
              controller.selectedLatLng.value = latLng;
              await controller.reverseGeocode(latLng);
            },
            markers: {
              gmap.Marker(
                markerId: const gmap.MarkerId("selected"),
                position: controller.selectedLatLng.value,
              ),
            },
            myLocationEnabled: false, // ✅ SAFE
            zoomControlsEnabled: false,
          )),

          /// BOTTOM PANEL (NO OVERFLOW)
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFieldWidget(
                        labelText: "Description".tr,
                        initialValue: controller.address.description,
                        onChanged: (v) =>
                        controller.address.description = v,
                        iconData: Icons.description_outlined,
                        isFirst: true,
                        isLast: false,
                      ),
                      TextFieldWidget(
                        labelText: "Full Address".tr,
                        initialValue: controller.address.address,
                        onChanged: (v) =>
                        controller.address.address = v,
                        iconData: Icons.place_outlined,
                        isFirst: false,
                        isLast: true,
                      ),
                      const SizedBox(height: 12),
                      BlockButtonWidget(
                        color: Get.theme.colorScheme.secondary,
                        text: Text("Pick Here".tr),
                        onPressed: () async {
                          final addr = controller.address;
                          final formCtrl =
                          Get.find<SalonAddressesFormController>();

                          addr.hasData
                              ? await formCtrl.updateAddress(addr)
                              : await formCtrl.createAddress(addr);

                          Get.back();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔍 SEARCH DIALOG
  void _openSearchDialog() {
    final ctrl = TextEditingController();
    List results = [];

    Get.dialog(
      AlertDialog(
        title: const Text("Search location"),
        content: StatefulBuilder(
          builder: (_, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: ctrl,
                onChanged: (v) async {
                  results = await controller.search(v);
                  setState(() {});
                },
              ),
              SizedBox(
                height: 300,
                child: ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (_, i) => ListTile(
                    title: Text(results[i]['description']),
                    onTap: () async {
                      await controller
                          .selectPlace(results[i]['place_id']);
                      Get.back();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
