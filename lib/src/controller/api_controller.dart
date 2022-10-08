import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lc_mobile/src/controller/httpException.dart';
import 'package:lc_mobile/src/controller/storage_controller.dart';
import 'package:lc_mobile/src/models/dir_type.dart';
import 'package:lc_mobile/src/models/machine_mode.dart';
import 'package:lc_mobile/src/models/system_model.dart';
import 'package:lc_mobile/src/models/user_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ApiController extends GetxController {
  final String apiAddr =
      'http://localhost:5432/'; // 'http://api.lc-manager.bytecodes.club/';
  // 'http://192.168.185.59:5432/'; // 'http://localhost:5432/';
  late StorageController _storageController;

  ApiController() {
    _storageController = Get.find<StorageController>();
  }

  Future<String> registerUser({
    required String name,
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      http.Response response =
          await http.post(Uri.parse(apiAddr + 'signup'), body: {
        "name": name,
        "username": username,
        "email": email,
        "password": password,
      });
      if (response.statusCode != 201) {
        throw HttpException(response.body);
      }
      await _storageController.setToken(
          token: json.decode(response.body)['jwtToken']);
      User user = User.fromJSON(json.decode(response.body)['user']);
      await _storageController.setUser(user: user);
      return json.decode(response.body)['jwtToken'];
    } catch (e) {
      rethrow;
    }
  }

  Future<User> getUserProfile(
      {required String token, required bool authCheck}) async {
    try {
      http.Response response =
          await http.get(Uri.parse(apiAddr + 'profile'), headers: {
        'Authorization': 'Bearer ' + token,
      });

      if (response.statusCode != 200) {
        if (authCheck) await _storageController.changeCheckAuth(false);
        throw HttpException(response.body);
      }
      User user = User.fromJSON(json.decode(response.body)['user']);
      await _storageController.setUser(user: user);
      if (authCheck) await _storageController.changeCheckAuth(false);
      return user;
    } catch (e) {
      if (authCheck) await _storageController.changeCheckAuth(false);
      rethrow;
    }
  }

  Future<String> loginUser(
      {required String username, required String password}) async {
    try {
      http.Response response = await http.post(
        Uri.parse(apiAddr + 'login'),
        body: {
          "username": username,
          "password": password,
        },
      );

      if (response.statusCode != 200) {
        throw HttpException(response.body);
      }
      String token = json.decode(response.body)['jwtToken'];
      await _storageController.setToken(token: token);
      User user = User.fromJSON(json.decode(response.body)['user']);
      await _storageController.setUser(user: user);
      return token;
    } catch (e) {
      rethrow;
    }
  }

  logOut() async {
    try {
      http.Response response = await http.delete(Uri.parse(apiAddr + 'logout'),
          headers: {
            "authorization": "Bearer " + _storageController.token.value
          });
      if (response.statusCode != 200) throw HttpException(response.body);
      await _storageController.removeToken();
      return;
    } catch (e) {
      rethrow;
    }
  }

  Future<Machine> createMachine({required String name}) async {
    try {
      http.Response response =
          await http.post(Uri.parse(apiAddr + 'machine'), headers: {
        "authorization": "Bearer " + _storageController.token.value,
      }, body: {
        "name": name,
      });
      if (response.statusCode != 200) {
        throw HttpException(response.body);
      } else {
        Machine machine = Machine.fromJson(json.decode(response.body));
        return machine;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Machine>> loadAllMachine({required String token}) async {
    try {
      List<Machine> machines = [];
      http.Response response = await http.get(
        Uri.parse(apiAddr + 'machine'),
        headers: {
          "authorization": "Bearer " + token,
        },
      );

      if (response.statusCode != 200) {
        throw HttpException(response.body);
      }
      json.decode(response.body)['machine'].forEach((machine) {
        Machine m = Machine.fromJson(machine);
        print(m.status);
        machines.add(m);
      });

      return machines;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteMachine(
      {required String id, required String token}) async {
    try {
      http.Response response =
          await http.delete(Uri.parse(apiAddr + 'machine?id=' + id), headers: {
        "authorization": "Bearer " + token,
      });
      if (response.statusCode != 200) throw HttpException(response.body);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<SystemDetails> getSystemDetails(
      {required String token, required String id}) async {
    print(token);
    try {
      http.Response response = await http.get(
        Uri.parse(apiAddr + 'get-sysdetails?id=' + id),
        headers: {
          "authorization": "Bearer " + token,
        },
      );

      if (response.statusCode != 200) {
        throw HttpException(response.body);
      }
      SystemDetails systemDetails =
          SystemDetails.fromJson(json.decode(response.body));
      return systemDetails;
    } catch (e) {
      rethrow;
    }
  }

  Future<List> readDirectory(
      {required String path,
      required String token,
      bool hidden = false,
      required String mid}) async {
    List dirs = [];
    try {
      http.Response response = await http.get(
        Uri.parse(apiAddr +
            'read?path=' +
            path +
            '&hidden=' +
            hidden.toString() +
            '&id=' +
            mid),
        headers: {
          "authorization": "Bearer " + token,
        },
      );

      if (response.statusCode != 200) {
        throw HttpException(response.body);
      }
      if (json.decode(response.body)['directory'].length > 0) {
        json.decode(response.body)['directory'].forEach((element) {
          DirType dirType = DirType.fromJSON(element);
          if (path == '/') {
            dirType.exactPath = '/' + dirType.name;
          } else {
            dirType.exactPath = path + '/' + dirType.name;
          }
          dirs.add(dirType);
        });
      }
      return dirs;
    } catch (e) {
      rethrow;
    }
  }

  download({required String path, required String mid}) async {
    try {
      await launch(
        apiAddr +
            'download?id=' +
            mid +
            '&path=' +
            path +
            '&authorization=Bearer ' +
            _storageController.token.value,
      );
    } catch (e) {
      rethrow;
    }
  }

  uploadFile(
      {required PlatformFile file,
      required String path,
      required String mid}) async {
    try {
      http.MultipartRequest request = http.MultipartRequest(
          'POST', Uri.parse(apiAddr + 'upload?id=' + mid + '&path=' + path));

      request.files.add(http.MultipartFile(
        "file",
        file.readStream as Stream<List<int>>,
        file.size,
        filename: file.name,
      ));
      request.headers["Authorization"] =
          "Bearer " + _storageController.token.value;
      http.StreamedResponse response = await request.send();
      print(await response.stream.bytesToString());
      if (response.statusCode != 200) {
        throw HttpException("Error in file uploading");
      }
    } catch (e) {
      rethrow;
    }
  }

  deleteContant({required String mid, required String path}) async {
    try {
      http.Response response = await http.delete(
        Uri.parse(apiAddr + 'delete?id=' + mid + '&path=' + path),
        headers: {'Authorization': 'Bearer ' + _storageController.token.value},
      );
      if (response.statusCode != 200) throw HttpException(response.body);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> createDownloadLink(
      {required String mid, required String contentPath}) async {
    try {
      http.Response response = await http.post(
        Uri.parse(
            apiAddr + 'shared-link?id=' + mid + '&contentPath=' + contentPath),
        headers: {'Authorization': 'Bearer ' + _storageController.token.value},
      );

      if (response.statusCode != 200) throw HttpException(response.body);

      var data = json.decode(response.body)['_id'];
      return apiAddr + 'public/download?sid=' + data;
    } catch (e) {
      rethrow;
    }
  }
}
