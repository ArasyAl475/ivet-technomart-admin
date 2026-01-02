import 'package:cwt_ecommerce_admin_panel/features/chat/models/whatsapp_support_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_overlay_notification/t_overlay_notification.dart';

import 'package:t_utils/t_utils.dart';
import '../../../../data/repositories/whatsapp_support/whatsapp_support_repository.dart';
import '../../../../utils/constants/text_strings.dart';
import 'whatsapp_support_controller.dart';

class CreateWhatsappSupportControllerController extends GetxController {
  static CreateWhatsappSupportControllerController get instance => Get.find();

  final isLoading = false.obs;
  final isActive = true.obs;
  final formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final number = TextEditingController();
  final whatsappSupportController = Get.put(WhatsappSupportController());
  final repository = Get.put(WhatsappSupportRepository());

  /// Register new Unit
  Future<void> createWhatsappSupportMember() async {
    try {
      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        return;
      }

      // Form Validation
      if (!formKey.currentState!.validate()) {
        return;
      }

      // Start Loading
      isLoading.value = true;

      // Map Data
      final newRecord = WhatsappSupportModel(
        id: '',
        name: name.text.trim(),
        number: number.text.trim(),
        isActive: isActive.value,
        createdAt: DateTime.now(),
      );

      // Call Repository to Create New Unit
      newRecord.id = await repository.addNewItem(newRecord);

      // Update All Data list
      whatsappSupportController.insertItemAtStartInLists(newRecord);

      // Reset Form
      resetFields();

      // Remove Loader
      isLoading.value = false;

      // Success Message & Redirect
      TNotificationOverlay.success(context: Get.context!, title: TTexts.unitCreated.tr, duration: Duration(seconds: 3));

      // Return
      Get.back();
    } catch (e) {
      isLoading.value = false;
      TNotificationOverlay.error(context: Get.context!, title: TTexts.ohSnap.tr, subTitle: e.toString());
    }
  }

  /// Method to reset fields
  void resetFields() {
    name.clear();
    isLoading(false);
    number.clear();
    isActive.value = true;
  }
}
