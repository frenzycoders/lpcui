import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lc_mobile/src/controller/home_controller.dart';
import 'package:lc_mobile/src/controller/httpException.dart';
import 'package:lc_mobile/src/controller/storage_controller.dart';
import 'package:lc_mobile/src/models/user_model.dart';
import 'package:lc_mobile/widget/addmachine.dart';
import 'package:lc_mobile/widget/machines.dart';
import 'package:lc_mobile/widget/responsive_header.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeController _homeController;
  TextEditingController textEditingController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _homeController = Get.find<HomeController>();
    checkAuth();
  }

  checkAuth() async {
    try {
      await _homeController.loadToken();
      try {
        await _homeController.loadProfileData();
        await _homeController.getAllMachines();
        _homeController.showError(message: '', status: false);
      } on HttpException catch (e) {
        _homeController.logout(withApi: false);
        _homeController.showError(message: e.message, status: true);
        Get.offAndToNamed('/login');
      } catch (e) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Server Error'),
                content: Text(e.toString()),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      checkAuth();
                      Navigator.of(context).pop();
                    },
                    child: Text('TRY AGAIN'),
                  ),
                ],
              );
            });
      }
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Server Error'),
              content: Text(e.toString()),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    checkAuth();
                    Navigator.of(context).pop();
                  },
                  child: Text('TRY AGAIN'),
                ),
              ],
            );
          });
    }
  }

  reloadMachines() async {
    try {
      await _homeController.getAllMachines();
    } on HttpException catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Server Error'),
              content: Text(e.toString()),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    reloadMachines();
                    Navigator.of(context).pop();
                  },
                  child: Text('TRY AGAIN'),
                ),
              ],
            );
          });
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Server Error'),
              content: Text(e.toString()),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    checkAuth();
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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          return _homeController.isError.isTrue
              ? Center(
                  child: Text(_homeController.errorMessage),
                )
              : Column(
                  children: [
                    ResponsiveHeader(
                      onCreate: () {
                        return showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            if (MediaQuery.of(context).size.width < 720) {
                              Navigator.of(context).pop();
                            }
                            return CreateMachine(
                              homeController: _homeController,
                            );
                          },
                        );
                      },
                      onHeaderTapped: () {
                        reloadMachines();
                      },
                      headerText: 'My Machines',
                      onLogoutTapped: () async {
                        try {
                          await _homeController.logout(withApi: true);
                          Fluttertoast.showToast(
                              msg: 'Logout success',
                              gravity: ToastGravity.CENTER);
                          Get.offAndToNamed('/login');
                        } on HttpException catch (e) {
                          Fluttertoast.showToast(
                              msg: e.message, gravity: ToastGravity.CENTER);
                        } catch (e) {
                          Fluttertoast.showToast(
                            msg: 'Check internet connection',
                            gravity: ToastGravity.CENTER,
                          );
                        }
                      },
                      username: _homeController.user.value.name,
                    ),
                    if (width < 720)
                      Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  reloadMachines();
                                },
                                icon: Icon(Icons.refresh),
                                label: Text('RELOAD'),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              ElevatedButton.icon(
                                onPressed: () {
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      if (MediaQuery.of(context).size.width >
                                          720) {
                                        Navigator.of(context).pop();
                                      }
                                      return CreateMachine(
                                        homeController: _homeController,
                                      );
                                    },
                                  );
                                },
                                icon: Icon(Icons.add),
                                label: Text('CREATE MACHINE'),
                              ),
                            ],
                          )),
                    MachinesList(
                      homeController: _homeController,
                    ),
                  ],
                );
        }),
      ),
    );
  }
}
