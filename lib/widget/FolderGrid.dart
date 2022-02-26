import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lc_mobile/src/controller/httpException.dart';
import 'package:lc_mobile/src/controller/manager_controller.dart';
import 'package:lc_mobile/widget/file_icons.dart';
import 'package:lc_mobile/widget/grid_item.dart';

class FolderGrid extends StatefulWidget {
  FolderGrid({
    Key? key,
    required this.managerController,
    required this.isMobileFunction,
    required this.mid,
    required this.shrinkWrap,
  }) : super(key: key);
  late ManagerController managerController;
  bool isMobileFunction;
  String mid;
  bool shrinkWrap;
  @override
  State<FolderGrid> createState() => _FolderGridState();
}

class _FolderGridState extends State<FolderGrid> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.isMobileFunction) {
      loadDirsForMobile();
    }
  }

  loadDirsForMobile() async {
    try {
      widget.managerController.setHomeDir(
        path: widget.managerController.sysDetails.value.homeDir,
        mid: widget.mid,
      );
    } on HttpException catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error !'),
              content: Text(e.message),
              actions: [
                RaisedButton(
                  onPressed: () {
                    loadDirsForMobile();
                    Navigator.of(context).pop();
                  },
                  child: Text('TRY AGAIN'),
                ),
                RaisedButton(
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
                RaisedButton(
                  onPressed: () {
                    loadDirsForMobile();
                    Navigator.of(context).pop();
                  },
                  child: Text('TRY AGAIN'),
                ),
                RaisedButton(
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
    final width = MediaQuery.of(context).size.width;
    return Obx(() {
      return widget.managerController.homeDirs.isNotEmpty
          ? GridView.count(
              shrinkWrap: widget.shrinkWrap,
              crossAxisCount: width > 1345
                  ? 6
                  : width < 1150 && width > 720
                      ? 3
                      : width <= 500
                          ? 2
                          : 3,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 6.0,
              // ignore: invalid_use_of_protected_member
              children: widget.managerController.homeDirs.value.map(
                (e) {
                  return e.isFile == true
                      ? GridItem(
                          isFile: false,
                          height: 100,
                          width: 100,
                          managerController: widget.managerController,
                          icon: SvgPicture.asset(
                            "assets/icons/folder.svg",
                            color: null,
                            theme: const SvgTheme(
                              fontSize: 50,
                            ),
                          ),
                          exactPath: e.exactPath,
                          mid: widget.mid,
                          name: e.name,
                        )
                      : GridItem(
                          isFile: true,
                          height: 100,
                          width: 100,
                          managerController: widget.managerController,
                          icon: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: FileIcon(
                              fileExt:
                                  e.name.split('.')[e.name.split('.').length - 1],
                              size: 60,
                            ),
                          ),
                          exactPath: e.exactPath,
                          mid: widget.mid,
                          name: e.name,
                        );
                },
              ).toList(),
            )
          : Container(
              child: Text('This folder is empty'),
            );
    });
  }
}
