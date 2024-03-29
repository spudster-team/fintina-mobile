import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  final SharedPreferences prefs;

  CacheService(this.prefs);

  Future<void> logout() async {
    await prefs.setBool('isLogged', false);
    await prefs.remove('username');
    await prefs.remove('token');
  }

  bool isLogged() {
    return prefs.getBool('isLogged') ?? false;
  }
}
