// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lc_mobile/src/controller/httpException.dart';
import 'package:lc_mobile/src/controller/manager_controller.dart';

class DeleteFileWidgetd extends StatefulWidget {
  DeleteFileWidgetd({
    Key? key,
    required this.exactPath,
    required this.managerController,
    required this.mid,
  }) : super(key: key);
  String exactPath;
  String mid;
  ManagerController managerController;

  @override
  State<DeleteFileWidgetd> createState() => _DeleteFileWidgetdState();
}

class _DeleteFileWidgetdState extends State<DeleteFileWidgetd> {
  bool deleteProgress = false;
  bool deleteError = false;
  String err = '';

  deleteFile() async {
    try {
      setState(() {
        deleteProgress = true;
        deleteError = false;
      });
      await widget.managerController
          .deleteFiles(path: widget.exactPath, mid: widget.mid);
      setState(() {
        deleteProgress = false;
        deleteError = false;
      });
      Timer(const Duration(seconds: 1), () {
        Fluttertoast.showToast(
            msg: 'Item deleted', gravity: ToastGravity.CENTER);
      });
      Navigator.of(context).pop();
    } on HttpException catch (e) {
      showError(message: e.message);
    } catch (e) {
      showError(message: e.toString());
    }
  }

  showError({required String message}) {
    setState(() {
      deleteProgress = false;
      deleteError = true;
      err = message;
    });
    Timer(Duration(seconds: 5), () {
      setState(() {
        deleteError = false;
        err = '';
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    widget.managerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Warning!',
        style: GoogleFonts.firaSans(
          fontSize: 25,
          fontWeight: FontWeight.w400,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          deleteError
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    err,
                    style: GoogleFonts.firaSans(color: Colors.red),
                  ),
                )
              : Container(),
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              'Are you sure ? after this process file or folder with path  [\' ' +
                  widget.exactPath +
                  ' \'] is not available on your local computer or laptor.',
              style: GoogleFonts.firaSans(
                color: Colors.red.shade500,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ],
      ),
      actions: [
        deleteProgress
            ? Container()
            : RaisedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('NO'),
              ),
        deleteProgress
            ? const CircularProgressIndicator()
            : RaisedButton(
                onPressed: () {
                  deleteFile();
                },
                child: const Text('YES'),
              ),
      ],
    );
  }
}
