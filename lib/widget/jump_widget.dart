import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lc_mobile/src/controller/httpException.dart';
import 'package:lc_mobile/src/controller/manager_controller.dart';

class JumpToPath extends StatefulWidget {
  JumpToPath({
    Key? key,
    required this.managerController,
    required this.mid,
  }) : super(key: key);
  late ManagerController managerController;

  String mid;

  @override
  State<JumpToPath> createState() => _JumpToPathState();
}

class _JumpToPathState extends State<JumpToPath> {
  bool isLoading = false;
  bool isError = false;
  String errorMessage = '';

  setDir({required String path}) async {
    try {
      setState(() {
        isLoading = true;
        isError = false;
      });
      await widget.managerController.setHomeDir(
        path: path,
        mid: widget.mid,
      );
      setState(() {
        isLoading = false;
        isError = false;
      });
      Navigator.of(context).pop();
    } on HttpException catch (e) {
      setState(() {
        errorMessage = e.message;
        isError = true;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isError = true;
        isLoading = false;
      });
    }
  }

  TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      width: 250,
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : isError
              ? Container(
                  child: Text(
                    errorMessage,
                    style: GoogleFonts.firaSans(
                      color: Colors.red,
                    ),
                  ),
                )
              : Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RaisedButton.icon(
                            onPressed: () {
                              setDir(
                                  path: widget.managerController.sysDetails
                                      .value.homeDir);
                            },
                            icon: Icon(Icons.home),
                            label: Text('HOME'),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          RaisedButton.icon(
                            onPressed: () {
                              setDir(path: '/');
                            },
                            icon: Icon(Icons.admin_panel_settings),
                            label: Text('ROOT'),
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            'Or',
                            style: GoogleFonts.firaSans(
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ),
                      TextField(
                        enabled: !isLoading,
                        controller: textEditingController,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                if (textEditingController.text.length > 0 &&
                                    textEditingController.text.contains('/'))
                                  setDir(path: textEditingController.text);
                                else {
                                  Fluttertoast.showToast(
                                      msg: 'Wrong path type',
                                      gravity: ToastGravity.CENTER);
                                }
                              },
                              icon: Icon(
                                Icons.arrow_forward_ios,
                              ),
                            ),
                            border: InputBorder.none,
                            hintText: 'Enter your path'),
                        style: GoogleFonts.firaSans(
                            color: Colors.white, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
    );
  }
}
