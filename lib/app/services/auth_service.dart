/*
 * File name: auth_service.dart
 * Last modified: 2022.10.16 at 12:23:16
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../models/user_model.dart';
import '../repositories/user_repository.dart';
import 'settings_service.dart';

class AuthService extends GetxService {
  final user = User().obs;
  final isLoggedIn = false.obs;
  late GetStorage _box;
  late UserRepository _usersRepo;

  AuthService() {
    _usersRepo = UserRepository();
    _box = GetStorage();
  }

  Future<AuthService> init() async {
    user.listen((User _user) {
      if (Get.isRegistered<SettingsService>()) {
        Get.find<SettingsService>().address.value.userId = _user.id;
      }
      // Always save user data when it changes
      _box.write('current_user', _user.toJson());
      Get.log('User data saved to storage: ${_user.email}');
    });
    await getCurrentUser();
    return this;
  }

  Future getCurrentUser() async {
    if (_box.hasData('current_user')) {
      user.value = User.fromJson(await _box.read('current_user'));
      user.value.auth = true;
      isLoggedIn.value = _box.read('isLoggedIn') ?? false;
      Get.log(
          'Restored user from storage: ${user.value.email}, isLoggedIn: ${isLoggedIn.value}');
    } else {
      user.value = User();
      user.value.auth = false;
      isLoggedIn.value = false;
      Get.log('No saved user found, starting fresh');
    }
  }

  Future setLoginState(bool loggedIn) async {
    isLoggedIn.value = loggedIn;
    await _box.write('isLoggedIn', loggedIn);
    Get.log('isLoggedIn saved to storage: $loggedIn');
  }

  Future removeCurrentUser() async {
    user.value = User();
    isLoggedIn.value = false;
    await _usersRepo.signOut();
    await _box.remove('current_user');
    await _box.remove('isLoggedIn');
  }

  Future deleteAccount() async {
    user.value = User();
    isLoggedIn.value = false;
    await _usersRepo.signOut();
    await _box.remove('current_user');
    await _box.remove('isLoggedIn');
  }

  Future isRoleChanged() async {
    try {
      var _user = await _usersRepo.getCurrentUser();
      if (_user.isSalonOwner != user.value.isSalonOwner) {
        return true;
      }
      return false;
    } catch (e) {
      Get.log('Error checking role: $e', isError: true);
      return false;
    }
  }

  bool get isAuth => user.value.auth ?? false;

  String get apiToken => (user.value.auth ?? false) ? user.value.apiToken : '';
}
