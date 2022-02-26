import 'dart:async';

import 'package:get/get.dart';
import 'package:lc_mobile/src/controller/api_controller.dart';
import 'package:lc_mobile/src/controller/httpException.dart';

class RegisterController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool obSecure = true.obs;
  RxBool showErr = false.obs;

  late ApiController _apiController;

  RegisterController() {
    _apiController = Get.find<ApiController>();
  }

  registerRequest({
    required String name,
    required String username,
    required String email,
    required String password,
  }) async {
    isLoading.value = true;
    try {
      await _apiController.registerUser(
        name: name,
        username: username,
        email: email,
        password: password,
      );
      isLoading.value = false;
    } on HttpException catch (e) {
      isLoading.value = false;
      throw HttpException(e.message);
    } catch (e) {
      isLoading.value = false;
      rethrow;
    }
  }

  changeObSecure() {
    obSecure.value = !obSecure.value;
  }
}
