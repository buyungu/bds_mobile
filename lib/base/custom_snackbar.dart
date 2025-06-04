import 'package:bds/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showCustomSnackBar(String message, {bool isError=true, String title="Error"}){
  Get.snackbar(title, message,
    titleText: Text(title,
      style: AppTextStyles.heroTitle
    ),
    messageText: Text(message,
      style: AppTextStyles.whiteBody
    ),
    colorText: Colors.white,
    snackPosition: SnackPosition.TOP,
    backgroundColor: Colors.redAccent
  );
}