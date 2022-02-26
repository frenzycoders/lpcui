import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lc_mobile/src/controller/httpException.dart';
import 'package:lc_mobile/src/controller/manager_controller.dart';
import 'package:lc_mobile/widget/file_icons.dart';

class UploadFilesWidget extends StatefulWidget {
  UploadFilesWidget({
    Key? key,
    required this.mid,
    required this.exactPath,
    required this.managerController,
  }) : super(key: key);
  String mid;
  String exactPath;
  ManagerController managerController;
  @override
  State<UploadFilesWidget> createState() => _UploadFilesWidgetState();
}

class _UploadFilesWidgetState extends State<UploadFilesWidget> {
  bool uploadProgress = false;
  PlatformFile? fileObj;
  bool showError = false;
  String err = '';

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    fileObj = null;
    widget.managerController.dispose();
  }

  uploadFiles() async {
    try {
      setState(() {
        uploadProgress = true;
      });
      await widget.managerController.uploadFile(
        file: fileObj as PlatformFile,
        mid: widget.mid,
        path: widget.exactPath,
      );
      setState(() {
        uploadProgress = false;
      });
      Timer(Duration(seconds: 2), () {
        Fluttertoast.showToast(
          msg: 'File uploaded',
          gravity: ToastGravity.CENTER,
        );
      });
      Navigator.of(context).pop();
    } on HttpException catch (e) {
      err = e.message;
      showErrorFun();
    } catch (e) {
      err = e.toString();
      showErrorFun();
    }
  }

  showErrorFun() {
    setState(() {
      showError = true;
      uploadProgress = false;
    });
    Timer(Duration(seconds: 5), () {
      setState(() {
        showError = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select file to upload'),
      content: Container(
        height: 170,
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: fileObj == null
              ? RaisedButton.icon(
                  onPressed: () async {
                    var result = await FilePicker.platform.pickFiles(
                        dialogTitle:
                            'Select file for upload to your local device',
                        withReadStream: true);
                    if (result != null) {
                      setState(() {
                        fileObj = result.files.single;
                      });
                    }
                  },
                  icon: const FaIcon(FontAwesomeIcons.upload),
                  label: const Text('Click here'),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    showError
                        ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              err,
                              style: GoogleFonts.firaSans(color: Colors.red),
                            ),
                          )
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 0),
                      child: Flex(
                        direction: Axis.horizontal,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FileIcon(fileExt: "", size: 20),
                          ),
                          Flexible(
                            child: Text(
                              fileObj!.name,
                              style: GoogleFonts.firaSans(),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: Flex(
                        direction: Axis.horizontal,
                        children: [
                          Flexible(
                            child: Text(
                              " (size " +
                                  (fileObj!.size / (1024 * 1024))
                                      .roundToDouble()
                                      .toString() +
                                  " MB)",
                              style: GoogleFonts.firaSans(),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        children: [
                          uploadProgress
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: RaisedButton.icon(
                                    onPressed: () {
                                      setState(() {
                                        fileObj = null;
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.clear,
                                      size: 10,
                                    ),
                                    label: Text(
                                      'CANCLE',
                                      style: GoogleFonts.firaSans(),
                                    ),
                                  ),
                                ),
                          uploadProgress
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: RaisedButton.icon(
                                    onPressed: () {
                                      uploadFiles();
                                    },
                                    icon: const FaIcon(
                                      FontAwesomeIcons.upload,
                                      size: 10,
                                    ),
                                    label: Text(
                                      'UPLOAD',
                                      style: GoogleFonts.firaSans(),
                                    ),
                                  ),
                                )
                        ],
                      ),
                    )
                  ],
                ),
        ),
      ),
      actions: [
        uploadProgress
            ? Container()
            : RaisedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('CANCLE'),
              ),
      ],
    );
  }
}
