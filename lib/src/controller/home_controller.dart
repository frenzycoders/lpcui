import 'package:get/get.dart';
import 'package:lc_mobile/src/controller/api_controller.dart';
import 'package:lc_mobile/src/controller/httpException.dart';
import 'package:lc_mobile/src/controller/storage_controller.dart';
import 'package:lc_mobile/src/models/machine_mode.dart';
import 'package:lc_mobile/src/models/user_model.dart';

class HomeController extends GetxController {
  late StorageController _storageController;
  late ApiController _apiController;

  RxBool isError = false.obs;
  String errorMessage = '';

  RxBool isMachineLoading = false.obs;
  RxBool createMachine = false.obs;
  RxBool machineCreated = false.obs;
  RxBool machineCreateError = false.obs;
  RxList machines = [].obs;

  Rx<User> user =
      User(id: '', name: '', email: '', username: '', password: '').obs;
  HomeController() {
    _storageController = Get.find<StorageController>();
    _apiController = Get.find<ApiController>();
  }
  reset() {
    createMachine.value = false;
    machineCreateError.value = false;
    machineCreated.value = false;
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
      print('Error');
      rethrow;
    }
  }

  showError({required String message, required bool status}) {
    errorMessage = message;
    isError.value = status;
    return;
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

  createMachinePocess({required String name}) async {
    createMachine.value = true;
    try {
      Machine machine = await _apiController.createMachine(name: name);
      machines.add(machine);
      createMachine.value = false;
      machineCreated.value = true;
    } on HttpException catch (e) {
      createMachine.value = false;
      errorMessage = e.message;
      machineCreateError.value = true;
    } catch (e) {
      createMachine.value = false;
      errorMessage = e.toString();
      machineCreateError.value = true;
    }
  }

  getAllMachines() async {
    isMachineLoading.value = true;
    try {
      List machine = await _apiController.loadAllMachine(
          token: _storageController.token.value);
      machines.value = machine;
      isMachineLoading.value = false;
    } on HttpException catch (e) {
      isMachineLoading.value = false;
      throw HttpException(e.message);
    } catch (e) {
      isMachineLoading.value = false;
      rethrow;
    }
  }

  deleteMachine({required String id}) async {
    try {
      List n = [];
      final data = await _apiController.deleteMachine(
          id: id, token: _storageController.token.value);
      if (data == true) {
        machines.value.forEach((element) {
          if (element.id != id) {
            n.add(element);
          }
        });

        machines.value = [];
        machines.value = n;
      }
    } on HttpException catch (e) {
      throw HttpException(e.message);
    } catch (e) {
      rethrow;
    }
  }
}
