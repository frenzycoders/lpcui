// ignore_for_file: unnecessary_null_comparison

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:lc_mobile/src/controller/api_controller.dart';
import 'package:lc_mobile/src/controller/httpException.dart';
import 'package:lc_mobile/src/controller/storage_controller.dart';

class LoginController extends GetxController {
  RxBool remeber = false.obs;
  RxBool isLoading = false.obs;
  RxBool showPwd = false.obs;

  late StorageController _storageController;
  late ApiController _apiController;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  LoginController() {
    _storageController = Get.find<StorageController>();
    _apiController = Get.find<ApiController>();
    loadLoginData();
  }

  loadLoginData() async {
    try {
      Remebr remebr = await _storageController.getPasswords();
      if (remebr.username != "null" && remebr.password != "null") {
        usernameController.text = remebr.username.toString();
        passwordController.text = remebr.password.toString();
      }
    } catch (e) {
      print(e);
    }
  }

  changeremember(value) {
    remeber.value = value;
  }

  loginUser() async {
    isLoading.value = true;
    if (remeber.isTrue) {
      await _storageController.remeberPassword(
          username: usernameController.text, password: passwordController.text);
    }
    try {
      await _apiController.loginUser(
          username: usernameController.text, password: passwordController.text);
      isLoading.value = false;
    } on HttpException catch (e) {
      isLoading.value = false;
      throw HttpException(e.message);
    } catch (e) {
      isLoading.value = false;
      rethrow;
    }
  }

  validateInputs() async {
    if (usernameController.text.length < 6) {
      throw HttpException(
          'Username length should be 6 or greater then 6 characters.');
    } else if (passwordController.text.length < 6) {
      throw HttpException(
          'Password length should be 6 or grater then 6 characters');
    }
  }

  changeShowPwd() {
    showPwd.value = !showPwd.value;
  }
}
