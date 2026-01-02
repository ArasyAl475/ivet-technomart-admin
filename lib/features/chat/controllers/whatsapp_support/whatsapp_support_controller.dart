import 'package:get/get.dart';

import '../../../../data/abstract/base_data_table_controller.dart';
import '../../../../data/repositories/whatsapp_support/whatsapp_support_repository.dart';
import '../../models/whatsapp_support_model.dart';

class WhatsappSupportController extends TBaseTableController<WhatsappSupportModel> {
  static WhatsappSupportController get instance => Get.find();

  // Inject the repository
  final WhatsappSupportRepository whatsappSupportRepository = Get.put(WhatsappSupportRepository());

  @override
  Future<List<WhatsappSupportModel>> fetchItems() async {
    // To make sure add more items button is not visible (allFetchedItems < limit)
    limit.value = 10000000;
    return await whatsappSupportRepository.getAllItems();
  }

  @override
  bool containsSearchQuery(WhatsappSupportModel item, String query) {
    return item.name.toLowerCase().contains(query.toLowerCase());
  }

  /// Sorting related code
  void sortByName(int sortColumnIndex, bool ascending) {
    sortByProperty(sortColumnIndex, ascending, (WhatsappSupportModel category) => category.name.toLowerCase());
  }

  @override
  Future<WhatsappSupportModel?> updateStatusToggleSwitch(bool toggle, WhatsappSupportModel item) async {
    if (item.isActive == toggle) return null;

    item.isActive = toggle;
    await whatsappSupportRepository.updateSingleItemRecord(item.id, {'isActive': toggle});
    return item;
  }

  @override
  Future<WhatsappSupportModel?> updateFeaturedToggleSwitch(bool toggle, WhatsappSupportModel item) async {
    await whatsappSupportRepository.updateSingleItemRecord(item.id, {'isFeatured': toggle});
    return item;
  }

  @override
  Future<void> deleteItem(WhatsappSupportModel item) async {
    // Now, delete the brand itself
    await WhatsappSupportRepository.instance.deleteItemRecord(item);
  }
}
