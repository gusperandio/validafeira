import 'dart:convert';
import 'dart:core';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:validasebrae/controllers/fetch_api.dart';

final SharedPreferencesAsync cache = SharedPreferencesAsync();

class ListPresent {
  Future<List<PresentRequest>> getPresents() async {
    try {
      List<String> presentList = await cache.getStringList('PresentList') ?? [];
      return presentList.map((el) => jsonStringToObject(el)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<bool> setPresents(PresentRequest data) async {
    try {
      List<String> presentList = await cache.getStringList('PresentList') ?? [];
      presentList.add(objectToJsonString(data));
      await cache.setStringList('qrList', presentList);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> deletePresents() async {
    await cache.remove('qrList');
  }

  PresentRequest jsonStringToObject(String jsonString) {
    return PresentRequest.fromJson(jsonDecode(jsonString));
  }

  String objectToJsonString(PresentRequest present) {
    return jsonEncode(present.toJson());
  }
}
