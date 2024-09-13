

import 'package:shared_preferences/shared_preferences.dart';

final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();


_toggle() async{
  await asyncPrefs.setStringList('items', <String>['Earth', 'Moon', 'Sun']);
}
