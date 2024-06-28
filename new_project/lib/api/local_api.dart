import 'dart:developer';
import 'package:hive/hive.dart';
import 'package:new_project/models/user_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalApi {
  LocalApi();
  late SharedPreferences sp;
  late Box<UserModel> userBox;
  String boxName = 'userBox';

  Future<void> init() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();

    Hive.init(appDocumentDir.path);
    !Hive.isAdapterRegistered(0)
        ? Hive.registerAdapter(UserModelAdapter())
        : null;

    userBox = await Hive.openBox<UserModel>(boxName);
  }

  UserModel? userModel;

  Future<void> initSp() async {
    sp = await SharedPreferences.getInstance();
  }

  Future<bool> saveKey(String key, String data) async {
    try {
      await sp.setString(key, data);
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<String?> getKey(String key) async {
    try {
      return sp.getString(key);
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<bool> deleteKey(String key) async {
    try {
      await sp.remove(key);
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> clearAll() async {
    try {
      await sp.clear();
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> saveUser(UserModel user) async {
    try {
      userModel = user;
      await userBox.put('currentUser', user);
      return true;
    } catch (e) {
      log('hive error: ${e.toString()}');
      return false;
    }
  }

  Future<UserModel?> getUser() async {
    try {
      final user = userBox.get('currentUser');
      userModel = user;
      return user;
    } catch (e) {
      log('hive error: ${e.toString()}');
      return null;
    }
  }

  Future<bool?> clearUser() async {
    try {
      await userBox.clear();

      return true;
    } catch (e) {
      return false;
    }
  }
}
