import 'package:firebase_core/firebase_core.dart';
import 'package:margadarshan/classes/yipliLocalStorage.dart';
import 'package:margadarshan/pages/a_pages_index.dart';
import 'package:margadarshan/services/dnyamic-link-service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class YipliAppInitializer {
  static Future<List> initialize() async {
    return Future.wait(
      [
        initializeFlutterFire(),
        initializeSharedPrefs(),
        DynamicLinkService().handleDynamicLinks()
      ],
      eagerError: true,
    );
  }

  static Future<FirebaseApp> initializeFlutterFire() async {
    // Wait for Firebase to initialize
    return Firebase.initializeApp();
  }

  static Future<void> initializeSharedPrefs() async {
    // Wait for Firebase to initialize
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    YipliAppLocalStorage.initialize(sharedPreferences);
    YipliAppLocalStorage.putData(YipliConstants.lastOpenedDateTime,
        DateTime.now().millisecondsSinceEpoch.toString());

    try {
      print("Calling ResetSharedPref from initializeSharedPrefs");
      await YipliUtils.ResetSharedPref('mat_add_skipped');
      await YipliUtils.ResetSharedPref('player_add_skipped');
    } catch (e) {
      print("Error in deleting SharedPref  $e");
    }
    return;
  }
}
