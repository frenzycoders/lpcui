import 'package:flutter/material.dart';
import 'package:lc_mobile/widget/register.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: width > 1000
          ? Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: 600,
                width: 800,
                child: Card(
                  elevation: 2,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 390,
                        height: 600,
                        child: Image.asset(
                          'assets/bannet.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                      RegisterWidget(
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
                      child: RegisterWidget(
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
                      child: RegisterWidget(
                        isMob: true,
                      ),
                    )
                  ],
                ),
    );
  }
}
