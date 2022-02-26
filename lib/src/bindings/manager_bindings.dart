import 'package:get/get.dart';
import 'package:lc_mobile/src/controller/manager_controller.dart';

class ManagerBindings extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(ManagerController());
  }
}
