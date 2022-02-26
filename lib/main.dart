import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:lc_mobile/screens/auth_screen.dart';
import 'package:lc_mobile/screens/home_screen.dart';
import 'package:lc_mobile/screens/login_screen.dart';
import 'package:lc_mobile/screens/register_screen.dart';
import 'package:lc_mobile/screens/splash_screen.dart';
import 'package:lc_mobile/src/bindings/home_bindings.dart';
import 'package:lc_mobile/src/bindings/initial_bindings.dart';
import 'package:lc_mobile/src/bindings/login_bindings.dart';
import 'package:lc_mobile/src/bindings/manager_bindings.dart';
import 'package:lc_mobile/src/bindings/register_bindings.dart';
import 'package:lc_mobile/screens/file_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: InitialBindings(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      getPages: [
        GetPage(
          name: '/splash',
          page: () => AuthScreen(
            widget: SplashScreen(),
            route: '/splash',
          ),
        ),
        GetPage(
          name: '/login',
          page: () => AuthScreen(
            widget: LoginScreen(),
            route: '/login',
          ),
          binding: LoginBindings(),
        ),
        GetPage(
          name: '/signup',
          page: () => AuthScreen(
            widget: RegisterScreen(),
            route: '/signup',
          ),
          binding: RegisterBindings(),
        ),
        GetPage(
          name: '/home',
          page: () => HomeScreen(),
          binding: HomeBindings(),
        ),
        GetPage(
          name: '/manager',
          page: () => FileManager(),
          binding: ManagerBindings(),
        )
      ],
      initialRoute: '/splash',
    );
  }
}
