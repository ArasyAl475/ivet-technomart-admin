import 'package:cwt_ecommerce_admin_panel/features/chat/controllers/whatsapp_support/whatsapp_support_controller.dart';
import 'package:cwt_ecommerce_admin_panel/features/chat/models/whatsapp_support_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_overlay_notification/t_overlay_notification.dart';
import 'package:t_utils/t_utils.dart';

import '../../../../data/repositories/whatsapp_support/whatsapp_support_repository.dart';
import '../../../../utils/constants/text_strings.dart';

class EditWhatsappSupportControllerController extends GetxController {
  static EditWhatsappSupportControllerController get instance => Get.find();

  final isActive = true.obs;
  final isLoading = false.obs;
  final name = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final number = TextEditingController();
  final whatsappSupportController = Get.put(WhatsappSupportController());
  final whatsappSupportRepository = Get.put(WhatsappSupportRepository());

  final support = WhatsappSupportModel.empty().obs;
  final supportId = ''.obs;

  /// Init Data
  Future<void> init() async {
    try {
      // Fetch record if argument was null
      if (support.value.id.isEmpty) {
        isLoading.value = true;
        support.value = await whatsappSupportRepository.getSingleItem(supportId.value);
      }

      name.text = support.value.name;
      isActive.value = support.value.isActive;
      number.text = support.value.number;
    } catch (e) {
      if (kDebugMode) printError(info: e.toString());
      TNotificationOverlay.error(context: Get.context!, title: TTexts.unitCreated.tr, subTitle: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Register new Unit
  Future<void> updateWhatsappSupportMember(WhatsappSupportModel support) async {
    try {
      // Start Loading
      isLoading.value = true;

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        isLoading.value = false;
        return;
      }

      // Form Validation
      if (!formKey.currentState!.validate()) {
        isLoading.value = false;
        return;
      }

      // Map Data
      support.name = name.text.trim();
      support.number = number.text.trim();
      support.isActive = isActive.value;
      support.updatedAt = DateTime.now();

      // Call Repository to Create New User
      await WhatsappSupportRepository.instance.updateItemRecord(support);

      // Update All Data list
      WhatsappSupportController.instance.updateItemFromLists(support);

      // Reset Form
      resetFields();

      // Remove Loader
      isLoading.value = false;

      // Success Message & Redirect
      TNotificationOverlay.success(context: Get.context!, title: 'Unit Updated', duration: Duration(seconds: 3));

      // Return
      Get.back();
    } catch (e) {
      isLoading.value = false;
      TNotificationOverlay.error(context: Get.context!, title: 'Oh Snap', subTitle: e.toString());
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
