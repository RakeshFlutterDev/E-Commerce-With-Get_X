import 'package:e_commerce_get_x/helper/responsive_helper.dart';
import 'package:e_commerce_get_x/util/dimensions.dart';
import 'package:e_commerce_get_x/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showCustomSnackBar(String? message, {bool isError = true}) {
  if(message != null && message.isNotEmpty) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
      dismissDirection: DismissDirection.horizontal,
      margin: EdgeInsets.only(
        right: ResponsiveHelper.isDesktop(Get.context) ? Get.context!.width*0.7 : Dimensions.paddingSizeSmall,
        top: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeSmall, left: Dimensions.paddingSizeSmall,
      ),
      duration: const Duration(seconds: 3),
      backgroundColor: isError ? Colors.red : Colors.green,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
      content: Text(message, style: josefinMedium.copyWith(color: Colors.white)),
    ));
  }
}