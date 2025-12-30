// ignore_for_file: deprecated_member_use

/*
 * File name: booking_address_chip_widget.dart
 * Last modified: 2023.02.09 at 15:50:34
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2023
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/ui.dart';
import '../../models/booking_model.dart';

class BookingAddressChipWidget extends StatelessWidget {
  const BookingAddressChipWidget({
    super.key,
    required Booking booking,
  }) : _booking = booking;

  final Booking _booking;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 200),
      child: RichText(
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        softWrap: true,
        text: TextSpan(
          style: Get.textTheme.bodyLarge,
          children: <InlineSpan>[
            WidgetSpan(
              baseline: TextBaseline.ideographic,
              child: Container(
                margin: const EdgeInsetsDirectional.only(end: 5),
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 0.5),
                decoration: Ui.getBoxDecoration(
                    color: Get.theme.focusColor.withOpacity(0.4)),
                child: Text(
                  _booking.atSalon!
                      ? 'At Salon'.tr
                      : (_booking.address!.description == ''
                              ? 'My Address'.tr
                              : _booking.address!.description) ??
                          '',
                  textScaleFactor: 1,
                  style: Get.textTheme.bodyLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            TextSpan(
              text: _booking.address?.isUnknown() == true
                  ? _booking.salon?.address?.address ?? ''
                  : _booking.address?.address ?? '',
              style: Get.textTheme.bodyLarge,
            ),
          ],
        ),
        textScaler: TextScaler.linear(Get.textScaleFactor),
      ),
    );
  }
}
