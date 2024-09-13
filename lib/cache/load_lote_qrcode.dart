import 'dart:core';
import 'package:shared_preferences/shared_preferences.dart';

final SharedPreferencesAsync cache = SharedPreferencesAsync();

class ListQRCODES {
  // Método público agora
  Future<List<String>> getReadQRs() async {
    List<String> empty = [];
    return await cache.getStringList('qrList') ?? empty;
  }

  Future<bool> setReadQRs(String data, List<String> added) async {
    try {  
      added.add(data);

      await cache.setStringList('qrList', added);
      return true;
    } catch (e) {
      return false;
    }
  }
}