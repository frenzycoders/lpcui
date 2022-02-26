import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lc_mobile/src/controller/home_controller.dart';
import 'package:lc_mobile/src/controller/httpException.dart';

class MachinesList extends StatefulWidget {
  MachinesList({
    Key? key,
    required this.homeController,
  }) : super(key: key);
  late HomeController homeController;

  @override
  State<MachinesList> createState() => _MachinesListState();
}

class _MachinesListState extends State<MachinesList> {
  deleteMachine({required String id}) async {
    try {
      await widget.homeController.deleteMachine(id: id);
      Fluttertoast.showToast(msg: 'Machine deleted successfully ..');
    } on HttpException catch (e) {
      Fluttertoast.showToast(
        msg: e.message,
        gravity: ToastGravity.CENTER,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        gravity: ToastGravity.CENTER,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width > 860
        ? Obx(() {
            return widget.homeController.isMachineLoading.isTrue
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: width > 1200 ? width * 0.15 : 10,
                        vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: Card(
                          elevation: 2,
                          child: widget.homeController.machines.length == 0
                              ? Container(
                                  alignment: Alignment.center,
                                  child: Text('No Machines found , Create one'),
                                )
                              : DataTable(
                                  dividerThickness: 5,
                                  columns: const [
                                    DataColumn(
                                      label: Text('MACHINE NAME'),
                                    ),
                                    DataColumn(
                                      label: Text('SOCKET ID'),
                                    ),
                                    DataColumn(
                                      label: Text('OWNER'),
                                    ),
                                    DataColumn(
                                      label: Text('STATUS'),
                                    ),
                                    DataColumn(
                                      label: Text('ACTION'),
                                    )
                                  ],
                                  rows: widget.homeController.machines.value
                                      .map(
                                        (element) => DataRow(
                                          selected: false,
                                          cells: [
                                            DataCell(
                                              Text(
                                                element.name,
                                                style: GoogleFonts.firaSans(
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                element.socketId,
                                                style: GoogleFonts.firaSans(
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.green,
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              element.owner ==
                                                      widget.homeController.user
                                                          .value.id
                                                  ? Text(
                                                      widget.homeController.user
                                                          .value.name,
                                                      style:
                                                          GoogleFonts.firaSans(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                    )
                                                  : Text(
                                                      'Other',
                                                      style:
                                                          GoogleFonts.firaSans(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                    ),
                                            ),
                                            DataCell(
                                              element.status
                                                  ? Text(
                                                      'Online',
                                                      style:
                                                          GoogleFonts.firaSans(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.green,
                                                      ),
                                                    )
                                                  : Text(
                                                      'Offline',
                                                      style:
                                                          GoogleFonts.firaSans(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                            ),
                                            DataCell(
                                              Row(
                                                children: [
                                                  IconButton(
                                                    onPressed: () {
                                                      FlutterClipboard.copy(
                                                              element.id)
                                                          .then((value) {
                                                        Fluttertoast.showToast(
                                                          msg:
                                                              'Machine id copied',
                                                          gravity: ToastGravity
                                                              .CENTER,
                                                        );
                                                      }).catchError((err) {
                                                        Fluttertoast.showToast(
                                                          msg: err.toString(),
                                                          gravity: ToastGravity
                                                              .CENTER,
                                                        );
                                                      });
                                                    },
                                                    icon: Icon(Icons.copy),
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              title: const Text(
                                                                  'Warning !'),
                                                              content: const Text(
                                                                  'Are you sure ?'),
                                                              actions: [
                                                                RaisedButton(
                                                                  onPressed:
                                                                      () {
                                                                    deleteMachine(
                                                                        id: element
                                                                            .id);
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                          'YES'),
                                                                ),
                                                                RaisedButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                          'NO'),
                                                                ),
                                                              ],
                                                            );
                                                          });
                                                    },
                                                    icon: Icon(Icons.delete),
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      if (element.status ==
                                                          true) {
                                                        Get.toNamed('/manager',
                                                            parameters: {
                                                              "id": element.id,
                                                            });
                                                      } else {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                'Machine is offline you can\'t access it.');
                                                      }
                                                    },
                                                    icon: Icon(
                                                      Icons.arrow_forward,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                      .toList(),
                                ),
                        ),
                      ),
                    ),
                  );
          })
        : width > 720 && width < 860
            ? Expanded(child: Obx(() {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: widget.homeController.isMachineLoading.isTrue
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : GridView.count(
                          crossAxisCount: 4,
                          crossAxisSpacing: 4.0,
                          mainAxisSpacing: 6.0,
                          children: widget.homeController.machines.value
                              .map((element) {
                            return Card(
                              color: Colors.blueGrey,
                              child: InkWell(
                                onTap: () {
                                  if (element.status) {
                                    Get.toNamed('/manager',
                                        parameters: {"id": element.id});
                                  } else {
                                    Fluttertoast.showToast(
                                        msg:
                                            'Machine is offline you can\'t access it. ');
                                  }
                                },
                                child: GridTile(
                                  header: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          element.name,
                                          style: GoogleFonts.firaSans(
                                              fontWeight: FontWeight.w400),
                                        ),
                                        element.status
                                            ? Text(
                                                'Online',
                                                style: GoogleFonts.firaSans(
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.green,
                                                ),
                                              )
                                            : Text(
                                                'Offline',
                                                style: GoogleFonts.firaSans(
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.red,
                                                ),
                                              )
                                      ],
                                    ),
                                  ),
                                  child: Container(
                                    child: Icon(
                                      Icons.laptop,
                                      size: 50,
                                    ),
                                  ),
                                  footer: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            FlutterClipboard.copy(element.id)
                                                .then((value) {
                                              Fluttertoast.showToast(
                                                msg: 'Machine id copied',
                                                gravity: ToastGravity.CENTER,
                                              );
                                            }).catchError((err) {
                                              Fluttertoast.showToast(
                                                msg: err.toString(),
                                                gravity: ToastGravity.CENTER,
                                              );
                                            });
                                          },
                                          icon: Icon(Icons.copy),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title:
                                                        const Text('Warning !'),
                                                    content: const Text(
                                                        'Are you sure ?'),
                                                    actions: [
                                                      RaisedButton(
                                                        onPressed: () {
                                                          deleteMachine(
                                                              id: element.id);
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child:
                                                            const Text('YES'),
                                                      ),
                                                      RaisedButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text('NO'),
                                                      ),
                                                    ],
                                                  );
                                                });
                                          },
                                          icon: Icon(Icons.delete),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                );
              }))
            : Expanded(
                child: Obx(() {
                  return widget.homeController.isMachineLoading.isTrue
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Container(
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                child: Card(
                                  elevation: 2,
                                  color: Colors.blueGrey,
                                  child: ListTile(
                                    enabled: true,
                                    onTap: () {
                                      if (widget.homeController.machines
                                          .value[index].status) {
                                        Get.toNamed('/manager', parameters: {
                                          "id": widget.homeController.machines
                                              .value[index].id
                                        });
                                      } else {
                                        Fluttertoast.showToast(
                                            msg:
                                                'Machine is not online you can\'t access it.');
                                      }
                                    },
                                    leading: Icon(
                                      Icons.laptop,
                                      color: Colors.white,
                                    ),
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(widget.homeController.machines
                                            .value[index].name),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                              'Warning !'),
                                                          content: const Text(
                                                              'Are you sure ?'),
                                                          actions: [
                                                            RaisedButton(
                                                              onPressed: () {
                                                                deleteMachine(
                                                                    id: widget
                                                                        .homeController
                                                                        .machines
                                                                        .value[
                                                                            index]
                                                                        .id);
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: const Text(
                                                                  'YES'),
                                                            ),
                                                            RaisedButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: const Text(
                                                                  'NO'),
                                                            ),
                                                          ],
                                                        );
                                                      });
                                                },
                                                icon: const Icon(
                                                  Icons.delete,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  FlutterClipboard.copy(widget
                                                          .homeController
                                                          .machines
                                                          .value[index]
                                                          .id)
                                                      .then((value) {
                                                    Fluttertoast.showToast(
                                                      msg: 'Machine id copied',
                                                      gravity:
                                                          ToastGravity.CENTER,
                                                    );
                                                  }).catchError((err) {
                                                    Fluttertoast.showToast(
                                                      msg: err.toString(),
                                                      gravity:
                                                          ToastGravity.CENTER,
                                                    );
                                                  });
                                                },
                                                icon: Icon(
                                                  Icons.copy,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    subtitle: widget.homeController.machines
                                            .value[index].status
                                        ? Text(
                                            'Online : ' +
                                                widget.homeController.machines
                                                    .value[index].socketId,
                                            style: GoogleFonts.firaSans(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.green,
                                            ),
                                          )
                                        : Text(
                                            'Offline : ' +
                                                widget.homeController.machines
                                                    .value[index].socketId,
                                            style: GoogleFonts.firaSans(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.red,
                                            ),
                                          ),
                                  ),
                                ),
                              );
                            },
                            itemCount: widget.homeController.machines.length,
                          ),
                        );
                }),
              );
  }
}
