import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lc_mobile/src/controller/httpException.dart';
import 'package:lc_mobile/src/controller/manager_controller.dart';

class PathArray extends StatelessWidget {
  PathArray({
    Key? key,
    required this.managerController,
    required this.mid,
  }) : super(key: key);
  late ManagerController managerController;
  String mid;
  setDir({required path, required BuildContext context}) async {
    try {
      await managerController.setHomeDir(path: path, mid: mid);
    } on HttpException catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error !'),
              content: Text(e.message),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    setDir(path: path, context: context);
                    Navigator.of(context).pop();
                  },
                  child: Text('TRY AGAIN'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('EXIT'),
                ),
              ],
            );
          });
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error !'),
              content: Text(e.toString()),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    setDir(path: path, context: context);
                    Navigator.of(context).pop();
                  },
                  child: Text('TRY AGAIN'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('EXIT'),
                ),
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Obx(() {
        return managerController.currentWorkingRoute.value == '/'
            ? Padding(
                padding: const EdgeInsets.all(3.0),
                child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextButton(
                        onPressed: () {
                          setDir(path: '/', context: context);
                        },
                        child: Icon(Icons.home),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_sharp,
                      )
                    ],
                  ),
                ),
              )
            : managerController.currentWorkingRoute.value.split('/').isNotEmpty
                ? SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Container(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    if (managerController
                                            .currentWorkingRoute.value
                                            .split('/')[index] ==
                                        '') {
                                      setDir(path: '/', context: context);
                                    } else {
                                      final p =
                                          managerController.returnExactPath(
                                              path: managerController
                                                  .currentWorkingRoute.value,
                                              index: managerController
                                                  .currentWorkingRoute.value
                                                  .split('/')[index]);
                                      setDir(path: p, context: context);
                                    }
                                  },
                                  child: managerController
                                              .currentWorkingRoute.value
                                              .split('/')[index] ==
                                          ''
                                      ? Icon(Icons.home)
                                      : Text(
                                          managerController
                                              .currentWorkingRoute.value
                                              .split('/')[index],
                                        ),
                                ),
                                index !=
                                        managerController
                                                .currentWorkingRoute.value
                                                .split('/')
                                                .length -
                                            1
                                    ? Icon(
                                        Icons.arrow_forward_ios_sharp,
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: managerController.currentWorkingRoute.value
                          .split('/')
                          .length,
                    ),
                  )
                : Text('Empty Path');
      }),
    );
  }
}
