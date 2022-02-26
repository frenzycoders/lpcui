import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lc_mobile/src/controller/manager_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lc_mobile/widget/file_icons.dart';

class FileEntityWidget extends StatefulWidget {
  FileEntityWidget({
    Key? key,
    required this.name,
    required this.path,
    required this.isFolder,
    required this.mid,
    required this.managerController,
  }) : super(key: key);
  String name;
  String path;
  bool isFolder;
  String mid;
  ManagerController managerController;
  @override
  State<FileEntityWidget> createState() => _FileEntityWidgetState();
}

class _FileEntityWidgetState extends State<FileEntityWidget> {
  bool isOpen = false;
  bool isLoading = true;
  List files = [];

  readDir() async {
    if (widget.isFolder) {
      files = await widget.managerController.getDirs(
        path: widget.path,
        mid: widget.mid,
        showHidden: widget.managerController.showHidden.value,
        loadOnHome: true,
      );
    }
    if (mounted) {
      setState(() {
        this.files = files;
        isLoading = false;
      });
    }
  }

  changeOpenState() {
    if (!isOpen && widget.isFolder) {
      readDir();
      setState(() {
        isOpen = true;
      });
    } else {
      setState(() {
        isOpen = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          InkWell(
            onTap: () {
              if (widget.isFolder) {
                widget.managerController.setCurrentPath(path: widget.path);
                changeOpenState();
              } else {
                Fluttertoast.showToast(
                    msg: 'This path is file type you can\'t open it');
              }
            },
            child: Container(
              height: 40,
              color: widget.managerController.currentWorkingRoute.value ==
                      widget.path
                  ? Colors.blueGrey
                  : Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: !widget.isFolder
                        ? FileIcon(
                            fileExt: widget.name
                                .split('.')[widget.name.split('.').length - 1],
                            size: 20,
                          )
                        : isOpen
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: SvgPicture.asset(
                                  "assets/icons/folder-open.svg",
                                ),
                              )
                            : SizedBox(
                                height: 20,
                                width: 20,
                                child: SvgPicture.asset(
                                  "assets/icons/folder.svg",
                                  color: null,
                                  theme: const SvgTheme(
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                  ),
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        widget.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15.0,
                          fontFamily: 'Roboto',
                          color: Colors.white54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          isOpen
              ? isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      children: [
                        files.isEmpty
                            ? const Text('Empty..', textAlign: TextAlign.left)
                            : Container(
                                padding: const EdgeInsets.only(left: 20),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const ClampingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return FileEntityWidget(
                                      name: files[index].name,
                                      path:
                                          widget.path + '/' + files[index].name,
                                      isFolder: files[index].isFile,
                                      mid: widget.mid,
                                      managerController:
                                          widget.managerController,
                                    );
                                  },
                                  itemCount: files.length,
                                ),
                              ),
                      ],
                    )
              : Container()
        ],
      );
    });
  }
}
