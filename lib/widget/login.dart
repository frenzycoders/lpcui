import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lc_mobile/src/controller/httpException.dart';
import 'package:lc_mobile/src/controller/login_controller.dart';
import 'package:lc_mobile/widget/header.dart';

class Login extends StatelessWidget {
  Login({
    Key? key,
    required this.isMob,
  }) : super(key: key);
  bool isMob;
  @override
  Widget build(BuildContext context) {
    return GetX<LoginController>(builder: (lController) {
      return SizedBox(
        width: isMob ? double.infinity : 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: CustomHeader(
                stringA: 'LOG',
                stringB: 'IN',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                enabled: !lController.isLoading.value,
                controller: lController.usernameController,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                    hintText: 'Username or email'),
                style: GoogleFonts.firaSans(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: TextField(
                enabled: !lController.isLoading.value,
                obscureText: !lController.showPwd.value,
                controller: lController.passwordController,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.password),
                    suffixIcon: IconButton(
                      onPressed: () {
                        lController.changeShowPwd();
                      },
                      icon: FaIcon(
                        lController.showPwd.isTrue
                            ? FontAwesomeIcons.eye
                            : FontAwesomeIcons.eyeSlash,
                      ),
                    ),
                    border: OutlineInputBorder(),
                    hintText: 'password'),
                style: GoogleFonts.firaSans(
                    color: Colors.white, fontWeight: FontWeight.w400),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                          value: lController.remeber.value,
                          onChanged: (value) {
                            lController.changeremember(value);
                          }),
                      Container(
                        margin: EdgeInsets.only(left: 2),
                        child: Text(MediaQuery.of(context).size.width < 500
                            ? 'remeber me'
                            : 'remember me for next time'),
                      )
                    ],
                  ),
                  lController.isLoading.isTrue
                      ? Container()
                      : TextButton(
                          onPressed: () {},
                          child: Text(
                            'Forgot password',
                            style: GoogleFonts.firaSans(
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.all(30),
                child: InkWell(
                  onTap: () async {
                    if (!lController.isLoading.isTrue) {
                      try {
                        await lController.validateInputs();
                        await lController.loginUser();
                        Fluttertoast.showToast(
                          msg: 'Logged in',
                          gravity: ToastGravity.CENTER,
                        );
                        Get.offAndToNamed('/home');
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
                  },
                  child: Container(
                    height: 50,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.green,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, right: 15, left: 15),
                      child: Container(
                        alignment: Alignment.center,
                        child: lController.isLoading.isTrue
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : Text(
                                'LOGIN',
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
            lController.isLoading.isTrue
                ? Container()
                : Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: TextButton(
                      onPressed: () {
                        Get.offAndToNamed('/signup');
                      },
                      child: Text(
                        'Don\'t have account create one',
                        style: GoogleFonts.firaSans(
                          color: Colors.greenAccent,
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      );
    });
  }
}
