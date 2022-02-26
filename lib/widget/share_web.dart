import 'dart:async';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lc_mobile/src/controller/httpException.dart';
import 'package:lc_mobile/src/controller/manager_controller.dart';

class ShareScreenWeb extends StatefulWidget {
  ShareScreenWeb({
    Key? key,
    required this.mid,
    required this.managerController,
    required this.path,
  }) : super(key: key);
  String mid;
  String path;
  ManagerController managerController;

  @override
  State<ShareScreenWeb> createState() => _ShareScreenWebState();
}

class _ShareScreenWebState extends State<ShareScreenWeb> {
  bool createScreen = true;
  String currentLink = '';
  bool downloadCreate = false;
  bool isError = false;
  bool showMessage = false;
  bool isDownload = true;
  String message = '';

  createDownloadLink() async {
    try {
      setState(() {
        downloadCreate = true;
        isError = false;
      });
      currentLink = await widget.managerController
          .createSharedLinks(path: widget.path, mid: widget.mid);
      setState(() {
        downloadCreate = false;
        isError = false;
      });
    } on HttpException catch (e) {
      showError(message: e.message);
    } catch (e) {
      showError(message: e.toString());
    }
  }

  showError({required String message}) {
    this.message = message;
    setState(() {
      downloadCreate = false;
      isError = true;
    });
    Timer(Duration(seconds: 5), () {
      isError = false;
      message = '';
    });
  }

  showMessageFun({required String msg}) {
    message = msg;
    setState(() {
      showMessage = true;
    });

    Timer(Duration(seconds: 1), () {
      message = '';
      setState(() {
        showMessage = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text(
        'Your Shared links',
        style: GoogleFonts.firaSans(
          fontWeight: FontWeight.w400,
          fontSize: 25,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 80,
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          isDownload = true;
                        });
                      },
                      hoverColor: Colors.transparent,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: isDownload ? Colors.black45 : Colors.blue,
                        ),
                        child: Text(
                          'DOWNLOAD',
                          style: GoogleFonts.firaSans(),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      hoverColor: Colors.transparent,
                      onTap: () {
                        setState(() {
                          isDownload = false;
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: isDownload ? Colors.blue : Colors.black45,
                        ),
                        child: Text(
                          'UPLOAD',
                          style: GoogleFonts.firaSans(),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Divider(),
          isError
              ? Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    message,
                    style: GoogleFonts.firaSans(color: Colors.red),
                  ),
                )
              : Container(),
          showMessage
              ? Text(
                  message,
                  style: GoogleFonts.firaSans(color: Colors.green),
                )
              : Container(),
          Padding(
            padding: EdgeInsets.all(10),
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: RaisedButton.icon(
                    color: createScreen ? Colors.black45 : Colors.blue,
                    onPressed: () {
                      setState(() {
                        createScreen = true;
                      });
                    },
                    icon: FaIcon(FontAwesomeIcons.plus),
                    label: Text(
                      'CREATE LINK',
                      style: GoogleFonts.firaSans(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: RaisedButton.icon(
                    color: createScreen ? Colors.blue : Colors.black45,
                    onPressed: () {
                      setState(() {
                        createScreen = false;
                      });
                    },
                    icon: FaIcon(FontAwesomeIcons.listUl),
                    label: Text(
                      'YOUR LINKS',
                      style: GoogleFonts.firaSans(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          isDownload
              ? createScreen
                  ? Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                              'Create shared link for [ ' + widget.path + ' ]'),
                        ),
                        currentLink != ''
                            ? RaisedButton.icon(
                                color: Colors.green,
                                onPressed: () {
                                  FlutterClipboard.copy(currentLink)
                                      .then((value) {
                                    showMessageFun(msg: 'Link copied');
                                  });
                                },
                                icon: FaIcon(FontAwesomeIcons.copy),
                                label: Text('Link Created Copy it'),
                              )
                            : Container(),
                      ],
                    )
                  : Container()
              : Container(),
          isDownload
              ? !createScreen
                  ? Container()
                  : Container()
              : Container(),
        ],
      ),
      actions: [
        createScreen
            ? downloadCreate
                ? CircularProgressIndicator()
                : RaisedButton.icon(
                    onPressed: () {
                      createDownloadLink();
                    },
                    icon: Icon(Icons.add),
                    label: Text('CREATE'),
                  )
            : Container(),
        downloadCreate
            ? Container()
            : RaisedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('CANCLE'),
              )
      ],
    );
  }
}
