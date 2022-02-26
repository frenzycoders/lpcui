import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lc_mobile/src/controller/httpException.dart';
import 'package:lc_mobile/src/controller/manager_controller.dart';
import 'package:lc_mobile/widget/delete_file.dart';
import 'package:lc_mobile/widget/share_web.dart';
import 'package:lc_mobile/widget/upload_file.dart';

class GridItem extends StatefulWidget {
  GridItem({
    Key? key,
    required this.height,
    required this.width,
    required this.managerController,
    required this.icon,
    required this.exactPath,
    required this.mid,
    required this.name,
    required this.isFile,
  }) : super(key: key);
  double height;
  double width;
  Widget icon;
  String mid;
  String name;
  String exactPath;
  bool isFile;
  late ManagerController managerController;

  @override
  State<GridItem> createState() => _GridItemState();
}

class _GridItemState extends State<GridItem> {
  bool extOpt = false;

  loadDir() async {
    try {
      await widget.managerController
          .setHomeDir(path: widget.exactPath, mid: widget.mid);
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
                    loadDir();
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
                    loadDir();
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
    return Obx(() {
      return InkWell(
        borderRadius: BorderRadius.circular(10),
        onLongPress: () {
          if (kIsWeb) {
          } else {
            setState(() {
              extOpt = !extOpt;
            });
          }
        },
        onDoubleTap: () {
          loadDir();
        },
        onTap: () {
          setState(() {
            extOpt = false;
          });
        },
        onHover: (value) {
          setState(() {
            extOpt = value;
          });
        },
        hoverColor: Colors.blueGrey,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: widget.managerController.selectedFolder.value ==
                    widget.exactPath
                ? Colors.blueGrey
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          height: widget.height,
          width: widget.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                child: widget.icon,
              ),
              Container(
                padding: EdgeInsets.only(top: 5),
                alignment: Alignment.center,
                child: Text(
                  widget.name,
                  style: GoogleFonts.firaSans(fontWeight: FontWeight.w300),
                ),
              ),
              extOpt
                  ? Container(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  useSafeArea: true,
                                  builder: (context) {
                                    return DeleteFileWidgetd(
                                      exactPath: widget.exactPath,
                                      mid: widget.mid,
                                      managerController:
                                          widget.managerController,
                                    );
                                  },
                                );
                              },
                              icon: const Icon(
                                Icons.delete,
                              ),
                            ),
                            widget.isFile
                                ? Container(
                                    height: 0,
                                    width: 0,
                                  )
                                : IconButton(
                                    onPressed: () async {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) {
                                          return UploadFilesWidget(
                                            mid: widget.mid,
                                            exactPath: widget.exactPath,
                                            managerController:
                                                widget.managerController,
                                          );
                                        },
                                      );
                                    },
                                    icon: const FaIcon(
                                      FontAwesomeIcons.upload,
                                    ),
                                  ),
                            IconButton(
                              onPressed: () async {
                                try {
                                  await widget.managerController.download(
                                      path: widget.exactPath, mid: widget.mid);
                                } on HttpException catch (e) {
                                  print(e.message);
                                } catch (e) {
                                  print(e.toString());
                                }
                              },
                              icon: const FaIcon(
                                FontAwesomeIcons.download,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                if (kIsWeb) {
                                  showDialog(
                                    useSafeArea: true,
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return ShareScreenWeb(
                                        managerController:
                                            widget.managerController,
                                        mid: widget.mid,
                                        path: widget.exactPath,
                                      );
                                    },
                                  );
                                } else {
                                  print('Fuck');
                                }
                              },
                              icon: const FaIcon(
                                FontAwesomeIcons.share,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      );
    });
  }
}
