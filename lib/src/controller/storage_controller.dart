import 'package:get/get.dart';
import 'package:lc_mobile/src/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageController extends GetxController {
  RxString token = ''.obs;
  Rx<User> user =
      User(id: '', name: '', email: '', username: '', password: '').obs;
  RxBool authCheck = false.obs;

  setToken({required String token}) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString('token', token);
      this.token.value = token;
    } catch (e) {
      print(e);
    }
  }

  removeToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token.value = '';
    preferences.remove('token');
    return;
  }

  getToken({required bool isAuth}) async {
    try {
      if (isAuth) changeCheckAuth(true);
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? token = sharedPreferences.getString('token');
      if (token != null) {
        this.token.value = token;
        return;
      } else {
        return;
      }
    } catch (e) {
      rethrow;
    }
  }

  setUser({required User user}) {
    this.user.value = user;
    return;
  }

  changeCheckAuth(value) {
    authCheck.value = value;
  }

  remeberPassword({required String username, required String password}) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString('username', username);
      preferences.setString('password', password);
    } catch (e) {
      print(e);
    }
  }

  Future<Remebr> getPasswords() async {
    try {
      Remebr remebr = Remebr();
      SharedPreferences preferences = await SharedPreferences.getInstance();
      remebr.username = preferences.getString('username').toString();
      remebr.password = preferences.getString('password').toString();
      return remebr;
    } catch (e) {
      rethrow;
    }
  }
}

class Remebr {
  String username;
  String password;
  Remebr({
    this.password = '',
    this.username = '',
  });
}
