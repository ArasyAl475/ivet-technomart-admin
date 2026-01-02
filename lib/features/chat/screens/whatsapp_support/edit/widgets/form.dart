import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:t_utils/t_utils.dart';

import '../../../../controllers/whatsapp_support/edit_whatsapp_support_controller.dart';

class EditWhatsappSupportForm extends StatelessWidget {
  const EditWhatsappSupportForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditWhatsappSupportControllerController());

    return Obx(
      () => TFormContainer(
        isLoading: controller.isLoading.value,
        padding: EdgeInsets.all(TSizes().defaultSpace),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Heading
              SizedBox(height: TSizes().sm),
              const TTextWithIcon(text: 'Update Support', icon: Iconsax.unlimited),
              SizedBox(height: TSizes().spaceBtwSections),

              // Name Text Field
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: controller.name,
                      validator: (value) => TValidator.validateEmptyText('Name', value),
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        prefixIcon: Icon(Iconsax.personalcard),
                        suffixIcon: Tooltip(
                          message:
                          'Enter the name of the support Person.',
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
                          message:
                          'Enter the Number of the support Person',
                          child: Icon(Iconsax.info_circle),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: TSizes().spaceBtwInputFields * 2),

              Obx(
                () => AnimatedSwitcher(
                  duration: const Duration(seconds: 1),
                  child: controller.isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(onPressed: () => controller.updateWhatsappSupportMember(controller.support.value), child: const Text('Update')),
                        ),
                ),
              ),
              SizedBox(height: TSizes().spaceBtwInputFields * 2),
            ],
          ),
        ),
      ),
    );
  }
}
