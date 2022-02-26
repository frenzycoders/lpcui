import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lc_mobile/src/controller/api_controller.dart';
import 'package:lc_mobile/src/controller/httpException.dart';
import 'package:lc_mobile/src/controller/storage_controller.dart';

class AuthScreen extends StatefulWidget {
  AuthScreen({
    Key? key,
    required this.widget,
    required this.route,
  }) : super(key: key);
  Widget widget;
  String route;
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  checkLogin() async {
    StorageController storageController = Get.find<StorageController>();
    await storageController.getToken(isAuth: true);
    if (storageController.token.isNotEmpty) {
      checkAuth(
        token: storageController.token.value,
        storageController: storageController,
      );
    } else {
      if (widget.route == '/splash') {
        Get.offAndToNamed('/login');
      }
    }
  }

  checkAuth(
      {required String token,
      required StorageController storageController}) async {
    ApiController apiController = Get.find<ApiController>();
    try {
      await apiController.getUserProfile(token: token, authCheck: true);
      Fluttertoast.showToast(msg: 'Logged In', backgroundColor: Colors.green);
      await storageController.getToken(isAuth: true);
      if (widget.route != '/manager') {
        Get.offAndToNamed('/home');
      }
    } on HttpException catch (e) {
      print('Here');
      Fluttertoast.showToast(msg: e.message, backgroundColor: Colors.red);
      Get.offAndToNamed('/login');
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          backgroundColor: Colors.red,
          timeInSecForIosWeb: 4);

      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Server Error'),
              content: Text(e.toString()),
              actions: [
                RaisedButton(
                  onPressed: () {
                    checkLogin();
                    Navigator.of(context).pop();
                  },
                  child: Text('TRY AGAIN'),
                ),
              ],
            );
          });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return GetX<StorageController>(builder: (stController) {
      return stController.authCheck.isFalse
          ? Center(child: CircularProgressIndicator())
          : widget.widget;
    });
  }
}
