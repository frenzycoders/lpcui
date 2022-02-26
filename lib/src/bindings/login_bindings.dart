import 'package:get/get.dart';
import 'package:lc_mobile/src/controller/login_controller.dart';

class LoginBindings extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(LoginController());
  }
}
