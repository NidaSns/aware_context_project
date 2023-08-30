import '../../constants/app_enum.dart';
import 'local_service.dart';


mixin LocalManager {

  Future<bool> setLocationAddress(String token) async {
    await LocaleService.instance
        .setString(SharedPreferencesKey.locationAddress.toString(), token);
    return true;
  }

  String getLocationAddress() {
    return LocaleService.instance
        .getValue(SharedPreferencesKey.locationAddress.toString());
  }

  void removeLocationAddress() {
    LocaleService.instance.remove(SharedPreferencesKey.locationAddress.toString());
  }

  bool localStorageContainKey(String key) {
    return LocaleService.instance.containKey(key);
  }

  void clearLocalStorage() {
    LocaleService.instance.clear();
  }
}