import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:lc_mobile/src/controller/api_controller.dart';
import 'package:lc_mobile/src/controller/httpException.dart';
import 'package:lc_mobile/src/controller/storage_controller.dart';
import 'package:lc_mobile/src/models/dir_type.dart';
import 'package:lc_mobile/src/models/system_model.dart';
import 'package:lc_mobile/src/models/user_model.dart';

class ManagerController extends GetxController {
  RxBool isLoading = false.obs;
  late ApiController _apiController;
  late StorageController _storageController;
  RxBool isLoadingData = false.obs;
  RxString currentWorkingRoute = ''.obs;
  RxString homeDir = ''.obs;

  RxBool showHidden = false.obs;
  RxList dir = [].obs;
  RxList homeDirs = [].obs;

  RxString selectedFolder = ''.obs;

  Rx<User> user =
      User(id: '', name: '', email: '', username: '', password: '').obs;
  Rx<SystemDetails> sysDetails = SystemDetails(
    operatingSys: '',
    hostName: '',
    platform: '',
    ostype: '',
    release: '',
    arch: '',
    homeDir: '',
    version: '',
    totalSpace: '',
    free: '',
    available: '',
  ).obs;

  ManagerController() {
    _apiController = Get.find<ApiController>();
    _storageController = Get.find<StorageController>();
  }

  Future loadToken() async {
    try {
      await _storageController.getToken(isAuth: false);
    } catch (e) {
      rethrow;
    }
  }

  Future<User> loadProfileData() async {
    try {
      User user = await _apiController.getUserProfile(
          token: _storageController.token.value, authCheck: false);
      this.user.value = user;
      return user;
    } on HttpException catch (e) {
      throw HttpException(e.message);
    } catch (e) {
      rethrow;
    }
  }

  logout({required bool withApi}) async {
    try {
      if (withApi) {
        await _apiController.logOut();
      } else {
        await _storageController.removeToken();
      }
      return;
    } on HttpException catch (e) {
      throw HttpException(e.message);
    } catch (e) {
      rethrow;
    }
  }

  getSystemDetails({required String id}) async {
    try {
      sysDetails.value = await _apiController.getSystemDetails(
          token: _storageController.token.value, id: id);
      homeDir.value = sysDetails.value.homeDir;
      currentWorkingRoute.value = homeDir.value;
    } on HttpException catch (e) {
      throw HttpException(e.message);
    } catch (e) {
      rethrow;
    }
  }

  Future getDirs({
    required String path,
    required String mid,
    required bool showHidden,
    required bool loadOnHome,
  }) async {
    try {
      List dir = await _apiController.readDirectory(
        path: path,
        token: _storageController.token.value,
        mid: mid,
        hidden: showHidden,
      );

      if (loadOnHome) {
        homeDirs.value = dir;
      }
      return dir;
    } on HttpException catch (e) {
      throw HttpException(e.message);
    } catch (e) {
      rethrow;
    }
  }

  setCurrentPath({required String path}) {
    currentWorkingRoute.value = path;
  }

  setHomeDir({required String path, required String mid}) async {
    homeDir.value = path;
    try {
      dir.value = await getDirs(
          path: path, mid: mid, showHidden: showHidden.value, loadOnHome: true);
      currentWorkingRoute.value = path;
    } on HttpException catch (e) {
      throw HttpException(e.message);
    } catch (e) {
      rethrow;
    }
  }

  String returnExactPath({required String path, required String index}) {
    final pathArray = path.split('/');

    String localPath = '';
    for (var i = 0; i < pathArray.length; i++) {
      if (pathArray[i] == '') {
        continue;
      }
      if (pathArray[i] != index) {
        localPath = localPath + '/' + pathArray[i];
      } else {
        localPath = localPath + '/' + pathArray[i];
        break;
      }
    }
    return localPath;
  }

  Future download({required String path, required String mid}) async {
    try {
      await _apiController.download(path: path, mid: mid);
    } on HttpException catch (e) {
      throw HttpException(e.message);
    } catch (e) {
      rethrow;
    }
  }

  uploadFile(
      {required PlatformFile file,
      required String mid,
      required String path}) async {
    try {
      await _apiController.uploadFile(file: file, path: path, mid: mid);
    } on HttpException catch (e) {
      throw HttpException(e.message);
    } catch (e) {
      rethrow;
    }
  }

  deleteFiles({required String path, required String mid}) async {
    try {
      List p = path.split('/');
      String newPath = '';

      if (p.length - 1 == 1) {
        newPath = '/';
      } else {
        p.removeAt(p.length - 1);
        newPath = p.join('/');
      }
      await _apiController.deleteContant(mid: mid, path: path);
      await setHomeDir(path: newPath, mid: mid);
    } on HttpException catch (e) {
      throw HttpException(e.message);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> createSharedLinks(
      {required String path, required String mid}) async {
    try {
      var p =
          await _apiController.createDownloadLink(mid: mid, contentPath: path);
      return p;
    } on HttpException catch (e) {
      throw HttpException(e.message);
    } catch (e) {
      rethrow;
    }
  }
}
