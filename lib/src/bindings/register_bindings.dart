import 'package:get/get.dart';
import 'package:lc_mobile/src/controller/register_controller.dart';

class RegisterBindings extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(RegisterController());
  }
}
