import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lc_mobile/src/controller/httpException.dart';
import 'package:lc_mobile/src/controller/manager_controller.dart';
import 'package:lc_mobile/src/models/dir_type.dart';
import 'package:lc_mobile/widget/file_entity.dart';

class TreeView extends StatefulWidget {
  TreeView({
    Key? key,
    required this.path,
    required this.managerController,
    required this.mid,
  }) : super(key: key);
  String path;
  String mid;
  ManagerController managerController;

  @override
  State<TreeView> createState() => _TreeViewState();
}

class _TreeViewState extends State<TreeView> {
  bool isLoading = false;
  bool isError = false;
  String errorMessage = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDirs();
  }

  getDirs() async {
    setState(() {
      isLoading = true;
      isError = false;
    });
    try {
      await widget.managerController
          .setHomeDir(path: widget.path, mid: widget.mid);
      setState(() {
        isLoading = false;
        isError = false;
      });
    } on HttpException catch (e) {
      setState(() {
        errorMessage = e.message;
        isError = true;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isError
        ? Container(
            height: 100,
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Center(
                    child: Text(
                      errorMessage,
                      style: GoogleFonts.firaSans(color: Colors.red),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    getDirs();
                  },
                  icon: Icon(Icons.refresh),
                  label: Text('RETRY'),
                )
              ],
            ),
          )
        : isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Obx(() {
                return widget.managerController.dir.length > 0
                    ? ListView.builder(
                        itemBuilder: (context, index) {
                          return FileEntityWidget(
                            name: widget.managerController.dir[index].name,
                            path: widget.managerController.dir[index].exactPath,
                            isFolder:
                                widget.managerController.dir[index].isFile,
                            mid: widget.mid,
                            managerController: widget.managerController,
                          );
                        },
                        itemCount: widget.managerController.dir.value.length,
                      )
                    : Center(
                        child: Text('Empty or Wrong path :[ ' +
                            widget.managerController.homeDir.value +
                            ' ]'),
                      );
              });
  }
}
