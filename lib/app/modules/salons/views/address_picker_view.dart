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
import '../../../services/location_service.dart';
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
  late LocationService _locationService;

  final Rx<gmap.LatLng> selectedLatLng =
      const gmap.LatLng(28.6139, 77.2090).obs;

  final Completer<gmap.GoogleMapController> mapController = Completer();
  final RxString formattedAddress = ''.obs;
  final RxBool isLoading = false.obs;
  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();

    address = Get.arguments['address'] as Address;
    apiKey = Get.find<SettingsService>().setting.value.googleMapsKey ?? '';
    _locationService = Get.find<LocationService>();

    // Initialize with existing address or default
    double lat = 28.6139;
    double lng = 77.2090;

    if (address.latitude != null && address.latitude > 0) {
      lat = address.latitude;
    }
    if (address.longitude != null && address.longitude > 0) {
      lng = address.longitude;
    }

    selectedLatLng.value = gmap.LatLng(lat, lng);

    // Set formatted address if it exists
    if (address.address.isNotEmpty) {
      formattedAddress.value = address.address;
    }
  }

  /// Check and request location permission
  Future<bool> checkLocationPermission() async {
    return await _locationService.checkAndRequestLocationPermission();
  }

  /// 🔍 AUTOCOMPLETE
  Future<List<dynamic>> search(String input) async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    final completer = Completer<List<dynamic>>();
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      final url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json'
          '?input=$input&key=$apiKey&components=country:in';

      final res = await http.get(Uri.parse(url));
      final body = json.decode(res.body);
      completer.complete(body['predictions'] ?? []);
    });

    return completer.future;
  }

  /// 📍 PLACE DETAILS
  Future<void> selectPlace(String placeId) async {
    final url = 'https://maps.googleapis.com/maps/api/place/details/json'
        '?place_id=$placeId&key=$apiKey';

    final res = await http.get(Uri.parse(url));
    final body = json.decode(res.body);

    final loc = body['result']['geometry']['location'];
    formattedAddress.value = body['result']['formatted_address'];

    selectedLatLng.value = gmap.LatLng(loc['lat'], loc['lng']);

    final controller = await mapController.future;
    controller.animateCamera(gmap.CameraUpdate.newLatLng(selectedLatLng.value));

    address
      ..latitude = loc['lat']
      ..longitude = loc['lng']
      ..address = formattedAddress.value
      ..description = formattedAddress.value; // Ensure description is set
  }

  /// 📍 GET CURRENT LOCATION
  Future<void> getCurrentLocation() async {
    isLoading.value = true;
    try {
      final position = await _locationService.getLocation();
      if (position != null) {
        final latLng = gmap.LatLng(position.latitude, position.longitude);
        selectedLatLng.value = latLng;
        final controller = await mapController.future;
        controller.animateCamera(gmap.CameraUpdate.newLatLng(latLng));
        await reverseGeocode(latLng);
      } else {
        Get.showSnackbar(
          GetSnackBar(
            message: 'Unable to get current location'.tr,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      Get.showSnackbar(
        GetSnackBar(
          message: 'Error getting location: ${e.toString()}'.tr,
          duration: const Duration(seconds: 2),
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔁 REVERSE GEOCODE
  Future<void> reverseGeocode(gmap.LatLng latLng) async {
    isLoading.value = true;
    try {
      final url = 'https://maps.googleapis.com/maps/api/geocode/json'
          '?latlng=${latLng.latitude},${latLng.longitude}&key=$apiKey';

      final res = await http.get(Uri.parse(url));
      final body = json.decode(res.body);

      if (body['results'] != null && body['results'].isNotEmpty) {
        final formattedAddr =
            body['results'][0]['formatted_address'] ?? 'Unknown Location';
        formattedAddress.value = formattedAddr;

        address
          ..latitude = latLng.latitude
          ..longitude = latLng.longitude
          ..address = formattedAddr
          ..description = formattedAddr; // Ensure description is set
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔁 REVERSE GEOCODE (OLD - KEPT FOR REFERENCE)

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
                  ? 'Pick Address'.tr
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
                onMapCreated: (gmap.GoogleMapController mapCtrl) {
                  if (!controller.mapController.isCompleted) {
                    controller.mapController.complete(mapCtrl);
                  }
                },
                onTap: (latLng) async {
                  controller.selectedLatLng.value = latLng;
                  await controller.reverseGeocode(latLng);
                },
                markers: {
                  gmap.Marker(
                    markerId: const gmap.MarkerId('selected'),
                    position: controller.selectedLatLng.value,
                  ),
                },
                myLocationEnabled: false, // ✅ SAFE
                zoomControlsEnabled: false,
              )),

          /// FLOATING ACTION BUTTONS (Top Right)
          Positioned(
            top: 16,
            right: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// CURRENT LOCATION FAB
                Obx(
                  () => FloatingActionButton(
                    heroTag: 'currentLocation',
                    mini: true,
                    backgroundColor: controller.isLoading.value
                        ? Colors.grey
                        : Get.theme.colorScheme.secondary,
                    onPressed: controller.isLoading.value
                        ? null
                        : () => controller.getCurrentLocation(),
                    child: controller.isLoading.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                        : const Icon(Icons.my_location, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 12),

                /// SEARCH FAB
                FloatingActionButton(
                  heroTag: 'search',
                  mini: true,
                  backgroundColor: Get.theme.colorScheme.secondary,
                  onPressed: _openSearchDialog,
                  child: const Icon(Icons.search, color: Colors.white),
                ),
              ],
            ),
          ),

          /// BOTTOM PANEL (NO OVERFLOW)
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// LOCATION BUTTONS ROW
                      Row(
                        children: [
                          /// CURRENT LOCATION BUTTON
                          Expanded(
                            child: Obx(() => ElevatedButton.icon(
                                  onPressed: controller.isLoading.value
                                      ? null
                                      : () => controller.getCurrentLocation(),
                                  icon: controller.isLoading.value
                                      ? SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation(
                                              Get.theme.primaryColor,
                                            ),
                                          ),
                                        )
                                      : const Icon(Icons.my_location),
                                  label: Text('My Location'.tr),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Get.theme.colorScheme.secondary,
                                    foregroundColor: Colors.white,
                                    elevation: 2,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                )),
                          ),
                          const SizedBox(width: 10),

                          /// SEARCH BUTTON
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _openSearchDialog,
                              icon: const Icon(Icons.search),
                              label: Text('Search'.tr),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Get.theme.colorScheme.secondary,
                                foregroundColor: Colors.white,
                                elevation: 2,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      /// INPUT FIELDS
                      TextFieldWidget(
                        labelText: 'Description'.tr,
                        initialValue: controller.address.description,
                        onChanged: (v) => controller.address.description = v,
                        iconData: Icons.description_outlined,
                        isFirst: true,
                        isLast: false,
                      ),
                      TextFieldWidget(
                        labelText: 'Full Address'.tr,
                        initialValue: controller.address.address,
                        onChanged: (v) => controller.address.address = v,
                        iconData: Icons.place_outlined,
                        isFirst: false,
                        isLast: true,
                      ),
                      const SizedBox(height: 12),

                      /// PICK HERE BUTTON
                      BlockButtonWidget(
                        color: Get.theme.colorScheme.secondary,
                        text: Text(
                          'Pick Here'.tr,
                          style: Get.textTheme.titleMedium?.merge(
                            const TextStyle(color: Colors.white),
                          ),
                        ),
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
        title: Text('Search location'.tr),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        content: StatefulBuilder(
          builder: (_, setState) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// SEARCH INPUT
                TextField(
                  controller: ctrl,
                  decoration: InputDecoration(
                    hintText: 'Search for a place...'.tr,
                    prefixIcon: const Icon(Icons.location_on),
                    suffixIcon: ctrl.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              ctrl.clear();
                              setState(() => results.clear());
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                  onChanged: (v) async {
                    if (v.isNotEmpty) {
                      results = await controller.search(v);
                    } else {
                      results.clear();
                    }
                    setState(() {});
                  },
                ),
                const SizedBox(height: 12),

                /// RESULTS LIST
                if (results.isNotEmpty)
                  SizedBox(
                    height: 300, // ✅ FIXED HEIGHT
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: results.length,
                      itemBuilder: (_, i) => ListTile(
                        leading: const Icon(Icons.location_on,
                            color: Colors.grey, size: 18),
                        title: Text(
                          results[i]['description'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 14),
                        ),
                        onTap: () async {
                          await controller.selectPlace(results[i]['place_id']);
                          Get.back();
                        },
                      ),
                    ),
                  )
                else if (ctrl.text.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'No results found'.tr,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Start typing to search locations...'.tr,
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                  ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Close'.tr),
          ),
        ],
      ),
    );
  }
}
