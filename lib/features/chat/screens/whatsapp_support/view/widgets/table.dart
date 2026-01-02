import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_utils/t_utils.dart';

import '../../../../../../routes/routes.dart';
import '../../../../controllers/whatsapp_support/whatsapp_support_controller.dart';
import '../../../../models/whatsapp_support_model.dart';

class WhatsappSupportTable extends StatelessWidget {
  const WhatsappSupportTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WhatsappSupportController());
    return Column(
      children: [
        /// Table Header
        TTableHeader(
          buttonText: 'Create New Support',
          searchController: controller.searchTextController,
          onCreatePressed: () => Get.toNamed(TRoutes.createWhatsappSupport),
          onSearchChanged: (value) => controller.searchQuery(value),
        ),
        SizedBox(height: TSizes().spaceBtwSections),

        /// Table
        Obx(
          () {
            return TDataTable(
              minWidth: 900,
              isLoading: controller.isLoading.value,
              sortAscending: controller.sortAscending.value,
              allItemsFetched: controller.allItemsFetched.value,
              sortColumnIndex: controller.sortColumnIndex.value,
              loadMoreButtonOnPressed: () => controller.fetchData(),
              columns: [
                const DataColumn2(label: Text('Ser'), fixedWidth: 40),
                DataColumn2(label: const Text('Name'), onSort: (index, asc) => controller.sortByName(index, asc)),
                const DataColumn2(label: Text('Abbreviation')),
                const DataColumn2(label: Text('Date')),
                const DataColumn2(label: Text('Action'), fixedWidth: 100),
              ],
              rows: controller.filteredItems.asMap().entries.map((entry) {
                final index = entry.key;
                final attribute = entry.value;
                return buildDataRow(controller, index, attribute, context);
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  DataRow buildDataRow(WhatsappSupportController controller, int index, WhatsappSupportModel item, BuildContext context) {
    return DataRow(
      selected: controller.selectedRows[index],
      onSelectChanged: (value) => controller.selectedRows[index] = value ?? false,
      cells: [
        DataCell(Text('${index + 1}')),
        DataCell(Text(item.name.capitalize.toString(), style: Theme.of(context).textTheme.titleLarge!.apply(color: TColors().primary))),
        DataCell(Text(item.number, style: Theme.of(context).textTheme.bodyLarge)),
        DataCell(Text(item.createdAt == null ? '' : item.formattedDate)),
        DataCell(
          TTableActionButtons(
            onDeletePressed: () => controller.confirmAndDeleteItem(item),
            onEditPressed: () => Get.toNamed(TRoutes.editWhatsappSupport, arguments: item, parameters: {'id': item.id}),
          ),
        ),
      ],
    );
  }
}
