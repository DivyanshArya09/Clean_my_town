import 'package:app/core/constants/shared_pef_keys.dart';
import 'package:app/core/utils/shared_pf_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserHelpers {
  late SharedPreferences prefs;
  Future<void> setUid(String uid) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString(STRING_KEY_APPTOKEN, uid);
  }

  Future<String> getUid() async {
    prefs = await SharedPreferences.getInstance();
    return prefs.getString(STRING_KEY_APPTOKEN) ?? "";
  }
}
