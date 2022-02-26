import 'package:get/get.dart';
import 'package:lc_mobile/src/controller/api_controller.dart';
import 'package:lc_mobile/src/controller/storage_controller.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(StorageController());
    Get.put(ApiController());
  }
}
