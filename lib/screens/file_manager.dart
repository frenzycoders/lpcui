import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lc_mobile/src/controller/httpException.dart';
import 'package:lc_mobile/src/controller/manager_controller.dart';
import 'package:lc_mobile/widget/FolderGrid.dart';
import 'package:lc_mobile/widget/jump_widget.dart';
import 'package:lc_mobile/widget/path_array.dart';
import 'package:lc_mobile/widget/sysdetails.dart';
import 'package:lc_mobile/widget/tree_view.dart';

class FileManager extends StatefulWidget {
  FileManager({Key? key}) : super(key: key);

  @override
  State<FileManager> createState() => _FileManagerState();
}

class _FileManagerState extends State<FileManager> {
  late ManagerController _managerController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _managerController = Get.find<ManagerController>();
    checkAuth();
  }

  checkAuth() async {
    try {
      _managerController.isLoadingData.value = true;
      final data = Get.parameters;
      await _managerController.loadToken();
      try {
        await _managerController.loadProfileData();
        await _managerController.getSystemDetails(id: data['id'].toString());
        _managerController.isLoadingData.value = false;
      } on HttpException catch (e) {
        _managerController.isLoadingData.value = false;
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Error !'),
                content: Text(e.message),
                actions: [
                  RaisedButton(
                    onPressed: () {
                      checkAuth();
                      Navigator.of(context).pop();
                    },
                    child: Text('TRY AGAIN'),
                  ),
                ],
              );
            });
      } catch (e) {
        _managerController.isLoadingData.value = false;
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Server Error'),
                content: Text(e.toString()),
                actions: [
                  RaisedButton(
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
      _managerController.isLoadingData.value = false;
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Server Error'),
              content: Text(e.toString()),
              actions: [
                RaisedButton(
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
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    print(width);
    return Obx(() {
      return _managerController.isLoadingData.isTrue
          ? const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                leading: Icon(Icons.laptop),
                title: Text(
                  _managerController.sysDetails.value.operatingSys +
                      '@' +
                      _managerController.sysDetails.value.hostName +
                      ' (' +
                      _managerController.sysDetails.value.arch +
                      ')',
                  style: GoogleFonts.firaSans(
                    color: Colors.white,
                  ),
                ),
                actions: [
                  width < 1356 && width > 500
                      ? Padding(
                          padding: EdgeInsets.all(8),
                          child: RaisedButton.icon(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    if (width < 500) {
                                      Navigator.of(context).pop();
                                    }
                                    return AlertDialog(
                                      content: JumpToPath(
                                        managerController: _managerController,
                                        mid: Get.parameters['id'].toString(),
                                      ),
                                      actions: [
                                        RaisedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('CLOSE'),
                                        ),
                                      ],
                                    );
                                  });
                            },
                            icon: Icon(Icons.directions),
                            label: Text('JUMP TO'),
                          ),
                        )
                      : width <= 500
                          ? IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      if (width > 500) {
                                        Navigator.of(context).pop();
                                      }
                                      return AlertDialog(
                                        content: JumpToPath(
                                          managerController: _managerController,
                                          mid: Get.parameters['id'].toString(),
                                        ),
                                        actions: [
                                          RaisedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('CLOSE'),
                                          ),
                                        ],
                                      );
                                    });
                              },
                              icon: const FaIcon(FontAwesomeIcons.directions),
                            )
                          : Container(
                              padding: EdgeInsets.all(6),
                              child: RaisedButton.icon(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        if (width < 500) {
                                          Navigator.of(context).pop();
                                        }
                                        return AlertDialog(
                                          content: JumpToPath(
                                            managerController:
                                                _managerController,
                                            mid:
                                                Get.parameters['id'].toString(),
                                          ),
                                          actions: [
                                            RaisedButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('CLOSE'),
                                            ),
                                          ],
                                        );
                                      });
                                },
                                icon: Icon(Icons.directions),
                                label: Text('JUMP TO'),
                              ),
                            ),
                  width < 1356 && width > 500
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton.icon(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    if (width < 500) {
                                      Navigator.of(context).pop();
                                    }
                                    return AlertDialog(
                                      content: SysDetails(
                                        managerController: _managerController,
                                      ),
                                      actions: [
                                        RaisedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('CLOSE'),
                                        ),
                                      ],
                                    );
                                  });
                            },
                            icon: Icon(Icons.storage),
                            label: Text('SYSTEM DETAILS'),
                          ),
                        )
                      : width <= 500
                          ? IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      if (width > 500) {
                                        Navigator.of(context).pop();
                                      }
                                      return AlertDialog(
                                        content: SysDetails(
                                          managerController: _managerController,
                                        ),
                                        actions: [
                                          RaisedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('CLOSE'),
                                          ),
                                        ],
                                      );
                                    });
                              },
                              icon: Icon(Icons.storage))
                          : Container(),
                ],
              ),
              body: width > 720
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: width > 720 && width < 1356 ? 2 : 2,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Drawer(
                              child: TreeView(
                                mid: Get.parameters['id'].toString(),
                                path: _managerController.homeDir.value,
                                managerController: _managerController,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: width > 1100 ? 5 : 4,
                          child: Column(
                            children: [
                              PathArray(
                                mid: Get.parameters['id'].toString(),
                                managerController: _managerController,
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding:
                                            EdgeInsets.only(top: 15, left: 15),
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          'Files & Folders',
                                          style: GoogleFonts.firaSans(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: FolderGrid(
                                          shrinkWrap: true,
                                          isMobileFunction: false,
                                          mid: Get.parameters['id'].toString(),
                                          managerController: _managerController,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        if (width > 1356)
                          Expanded(
                            flex: 2,
                            child: SysDetails(
                              managerController: _managerController,
                            ),
                          ),
                      ],
                    )
                  : Column(
                      children: [
                        PathArray(
                          mid: Get.parameters['id'].toString(),
                          managerController: _managerController,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 15, bottom: 5, right: 10),
                          child: Container(
                            alignment: Alignment.topLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Files & Folders',
                                  style: GoogleFonts.firaSans(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 20,
                                  ),
                                ),
                                RaisedButton.icon(
                                  onPressed: () async  {
                                    await _managerController.setHomeDir(
                                      path: _managerController
                                          .currentWorkingRoute.value,
                                      mid: Get.parameters['id'].toString(),
                                    );
                                  },
                                  icon: Icon(Icons.refresh),
                                  label: Text(
                                    "Refresh",
                                    style: GoogleFonts.firaSans(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 15,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: FolderGrid(
                                shrinkWrap: false,
                                isMobileFunction: true,
                                mid: Get.parameters['id'].toString(),
                                managerController: _managerController,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
            );
    });
  }
}
