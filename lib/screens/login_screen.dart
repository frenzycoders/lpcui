import 'package:flutter/material.dart';
import 'package:lc_mobile/widget/login.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: width > 1000
          ? Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: 500,
                width: 800,
                child: Card(
                  elevation: 2,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 390,
                        height: 500,
                        child: Image.asset(
                          'assets/bannet.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Login(
                        isMob: false,
                      ),
                    ],
                  ),
                ),
              ),
            )
          : width > 600 && width < 1000
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Login(
                        isMob: false,
                      ),
                    )
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Login(
                        isMob: true,
                      ),
                    )
                  ],
                ),
    );
  }
}
