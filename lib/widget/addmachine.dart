import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lc_mobile/src/controller/home_controller.dart';

class CreateMachine extends StatefulWidget {
  CreateMachine({
    Key? key,
    required this.homeController,
  }) : super(key: key);
  HomeController homeController;

  @override
  State<CreateMachine> createState() => _CreateMachineState();
}

class _CreateMachineState extends State<CreateMachine> {
  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return AlertDialog(
        title: Text('Add Machine'),
        content: Container(
          height: 100,
          width: 300,
          child: widget.homeController.createMachine.isTrue
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : widget.homeController.machineCreated.isTrue
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.check,
                            size: 40,
                            color: Colors.green,
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            'Machine created successfully. copy machine id and configure it on your local machine',
                            style: GoogleFonts.firaSans(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    )
                  : widget.homeController.machineCreateError.isTrue
                      ? Column(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.clear,
                                color: Colors.red,
                                size: 40,
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                widget.homeController.errorMessage,
                                style: GoogleFonts.firaSans(
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        )
                      : Padding(
                          padding: const EdgeInsets.all(20),
                          child: TextField(
                            enabled: !widget.homeController.createMachine.value,
                            controller: textEditingController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(),
                              hintText: 'Machine name',
                            ),
                            style: GoogleFonts.firaSans(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
        ),
        actions: widget.homeController.createMachine.isTrue
            ? []
            : widget.homeController.machineCreated.isTrue
                ? [
                    ElevatedButton(
                      onPressed: () {
                        widget.homeController.reset();
                      },
                      child: Text('CREATE ANOTHER'),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.green,
                        ),
                      ),
                      onPressed: () {
                        widget.homeController.reset();
                        Navigator.of(context).pop();
                      },
                      child: Text('CLOSE'),
                    )
                  ]
                : widget.homeController.machineCreateError.isTrue
                    ? [
                        ElevatedButton(
                          onPressed: () {
                            widget.homeController.reset();
                          },
                          child: Text('RETRY'),
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              Colors.green,
                            ),
                          ),
                          onPressed: () {
                            widget.homeController.reset();
                            Navigator.of(context).pop();
                          },
                          child: Text('CLOSE'),
                        )
                      ]
                    : [
                        ElevatedButton(
                          onPressed: () {
                            widget.homeController.reset();
                            Navigator.of(context).pop();
                          },
                          child: Text('CLOSE'),
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              Colors.green,
                            ),
                          ),
                          onPressed: () {
                            if (textEditingController.text.length > 4) {
                              widget.homeController.createMachinePocess(
                                  name: textEditingController.text);
                            } else {
                              Fluttertoast.showToast(
                                  msg:
                                      'Name should be or greater then 4 character');
                            }
                          },
                          child: Text('CREATE MACHINE'),
                        )
                      ],
        elevation: 20,
      );
    });
  }
}
