import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_utils/t_utils.dart';

import '../../../../controllers/whatsapp_support/create_whatsapp_support_controller.dart';

class CreateWhatsappSupportForm extends StatelessWidget {
  const CreateWhatsappSupportForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateWhatsappSupportControllerController());
    return TFormContainer(
      isLoading: controller.isLoading.value,
      padding: EdgeInsets.all(TSizes().defaultSpace),
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Heading
            SizedBox(height: TSizes().sm),
            const TTextWithIcon(text: 'Create new Support', icon: Iconsax.unlimited),
            SizedBox(height: TSizes().spaceBtwSections),

            // Name Text Field
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller.name,
                    validator: (value) => TValidator.validateEmptyText('Name', value),
                    decoration: InputDecoration(
                      labelText: 'Name',
                      prefixIcon: Icon(Iconsax.personalcard),
                      suffixIcon: Tooltip(
                        message: 'Enter the name of the support Person.',
                        child: Icon(Iconsax.info_circle),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: TSizes().spaceBtwInputFields),
                Expanded(
                  child: TextFormField(
                    controller: controller.number,
                    decoration: const InputDecoration(
                      labelText: 'Number',
                      prefixIcon: Icon(Iconsax.mobile),
                      suffixIcon: Tooltip(
                        message: 'Enter the Number of the support Person',
                        child: Icon(Iconsax.info_circle),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: TSizes().spaceBtwSections),

            Obx(
              () => AnimatedSwitcher(
                duration: const Duration(seconds: 1),
                child: controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(onPressed: () => controller.createWhatsappSupportMember(), child: const Text('Create')),
                      ),
              ),
            ),
            SizedBox(height: TSizes().spaceBtwInputFields * 2),
          ],
        ),
      ),
    );
  }
}
