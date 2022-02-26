import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lc_mobile/src/controller/api_controller.dart';
import 'package:lc_mobile/src/controller/httpException.dart';
import 'package:lc_mobile/src/controller/register_controller.dart';
import 'package:lc_mobile/src/controller/storage_controller.dart';
import 'package:lc_mobile/widget/header.dart';

class RegisterWidget extends StatefulWidget {
  RegisterWidget({
    Key? key,
    required this.isMob,
  }) : super(key: key);
  bool isMob;

  @override
  State<RegisterWidget> createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetX<RegisterController>(builder: (rController) {
      return SizedBox(
        width: widget.isMob ? double.infinity : 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: CustomHeader(
                stringA: 'SIGN',
                stringB: 'UP',
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: TextField(
                controller: nameController,
                enabled: !rController.isLoading.value,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.title),
                    border: OutlineInputBorder(),
                    hintText: 'Your name'),
                style: GoogleFonts.firaSans(
                    color: Colors.white, fontWeight: FontWeight.w400),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: TextField(
                controller: usernameController,
                enabled: !rController.isLoading.value,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                    hintText: 'Your username'),
                style: GoogleFonts.firaSans(
                    color: Colors.white, fontWeight: FontWeight.w400),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: TextField(
                controller: emailController,
                enabled: !rController.isLoading.value,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                    hintText: 'Your email'),
                style: GoogleFonts.firaSans(
                    color: Colors.white, fontWeight: FontWeight.w400),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: TextField(
                controller: passwordController,
                enabled: !rController.isLoading.value,
                obscureText: rController.obSecure.value,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.password),
                    suffixIcon: IconButton(
                      color: Colors.white,
                      icon: rController.obSecure.isTrue
                          ? FaIcon(FontAwesomeIcons.eyeSlash)
                          : FaIcon(FontAwesomeIcons.eye),
                      onPressed: () {
                        rController.changeObSecure();
                      },
                    ),
                    border: OutlineInputBorder(),
                    hintText: 'create password'),
                style: GoogleFonts.firaSans(
                    color: Colors.white, fontWeight: FontWeight.w400),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.all(30),
                child: InkWell(
                  onTap: () async {
                    if (!rController.isLoading.value) {
                      try {
                        await rController.registerRequest(
                          name: nameController.text,
                          email: emailController.text,
                          password: passwordController.text,
                          username: usernameController.text,
                        );
                        Fluttertoast.showToast(
                            msg: 'Registration completed',
                            backgroundColor: Colors.green);
                        Get.offAndToNamed('/home');
                      } on HttpException catch (e) {
                        Fluttertoast.showToast(
                            msg: e.message, backgroundColor: Colors.red);
                      } catch (e) {
                        print(e);
                        Fluttertoast.showToast(
                          msg: 'Please connect to internet',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.TOP_RIGHT,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      }
                    } else {
                      Fluttertoast.showToast(
                          msg: 'Process is already running..',
                          backgroundColor: Colors.red,
                          timeInSecForIosWeb: 4);
                    }
                  },
                  child: Container(
                    height: 50,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.green,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 10, bottom: 10, right: 15, left: 15),
                      child: Container(
                        alignment: Alignment.center,
                        child: rController.isLoading.isTrue
                            ? CircularProgressIndicator()
                            : Text(
                                'SIGNUP',
                                style: GoogleFonts.firaSans(
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              child: TextButton(
                onPressed: () {
                  Get.offAndToNamed('/login');
                },
                child: Text(
                  'Already have an account ? Login ',
                  style: GoogleFonts.firaSans(
                    color: Colors.greenAccent,
                  ),
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}
