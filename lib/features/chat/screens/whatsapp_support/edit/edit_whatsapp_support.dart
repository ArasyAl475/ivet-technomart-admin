import 'package:cwt_ecommerce_admin_panel/features/chat/models/whatsapp_support_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/layouts/templates/site_layout.dart';
import '../../../controllers/whatsapp_support/edit_whatsapp_support_controller.dart';
import 'layouts/desktop.dart';
import 'layouts/mobile.dart';
import 'layouts/tablet.dart';

class EditWhatsappSupportScreen extends StatelessWidget {
  const EditWhatsappSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditWhatsappSupportControllerController());
    controller.support.value = Get.arguments ?? WhatsappSupportModel.empty();
    controller.supportId.value = Get.parameters['id'] ?? '';

    // Initialize the controller data outside the build method
    WidgetsBinding.instance.addPostFrameCallback((_) => controller.init());

    return const TSiteTemplate(desktop: DesktopScreen(), tablet: TabletScreen(), mobile: MobileScreen());
  }
}
