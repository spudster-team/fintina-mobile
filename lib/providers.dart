import 'package:dio/dio.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'services/rest_api_service.dart';

final isLoggedProvider = FutureProvider((ref) async {
  final prefs = await SharedPreferences.getInstance();
  ref.read(isLoggedStateProvider.notifier).state =
      prefs.getBool('isLogged') ?? false;
});

final isLoggedStateProvider = StateProvider((ref) => false);

final userNameProvider = FutureProvider.autoDispose((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('username') ?? 'user not found';
});

final historyProvider = FutureProvider.autoDispose(
  (ref) async {
    final service = HttpRestApiService(Dio());
    return await service.getHistory();
  },
);
