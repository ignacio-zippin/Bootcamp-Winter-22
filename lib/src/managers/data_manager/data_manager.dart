import 'dart:io';
import 'package:flutter/material.dart';
import 'package:playground_app/src/data_access/dummy_data_access/dummy_data_access.dart';
import 'package:playground_app/src/enums/culture.dart';
import 'package:playground_app/src/interfaces/i_data_access.dart';
import 'package:playground_app/utils/extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataManager {
  static final DataManager _instance = DataManager._constructor();
  late SharedPreferences prefs;
  late IDataAccess dataAccess;

  Culture selectedCulture = Culture.es;

  factory DataManager() {
    return _instance;
  }

  DataManager._constructor();

  init() async {
    dataAccess = DummyDataAccess();

    if (Platform.environment.containsKey('FLUTTER_TEST')) {
      dataAccess = DummyDataAccess();
    }
    prefs = await SharedPreferences.getInstance();
    //_dataAccess?.token = _getToken();
  }

  saveToken(String? token) async {
    try {
      await prefs.setString('token', token ?? "");
      dataAccess.token = token!;
    } catch (ex) {
      debugPrint(ex.toString());
    }
  }

  hasSession() {
    return hasToken() != null;
  }

  hasToken() {
    return prefs.getString('token') != null;
  }

  saveRemember(bool value) {
    prefs.setString('remember', value.toString());
  }

  saveUser(String value) {
    prefs.setString('savedUser', value);
  }

  bool getRemember() {
    String? remember = prefs.getString('remember');
    bool value = remember != null ? remember.parseBool() : false;
    return value;
  }

  String? getSavedUser() {
    return getRemember() ? prefs.getString('savedUser') : null;
  }

  //TODO: Check
  // _getToken() {
  //   return prefs.getString('token');
  // }

  void cleanData() async {
    await prefs.remove("token");
    await prefs.remove("currentProfile");
    await prefs.remove('notifications');
  }
}
