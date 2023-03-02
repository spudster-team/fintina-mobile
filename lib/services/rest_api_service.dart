import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../models/history_item_model.dart';

class HttpRestApiService {
  Dio dio;

  HttpRestApiService(this.dio);

  Future<Either<String, List<HistoryItem>>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final headers = <String, dynamic>{};

    if (token != null) {
      headers['Authorization'] = 'Token $token';
    }

    try {
      final res = await dio.get(
        '$baseUrl/api/user/historique',
        options: Options(
          headers: headers,
        ),
      );

      final data = res.data['historique'];
      final List<HistoryItem> history = [];

      for (var historyItem in data) {
        history.add(HistoryItem.fromJson(historyItem));
      }
      return Right(history);
    } on DioError catch (e) {
      return Left(e.response?.data.toString() ?? e.toString());
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> login(
    String username,
    String password,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    try {
      final res = await dio.post('$baseUrl/api/user/auth', data: {
        'username': username,
        'password': password,
      });
      final token = res.data['token'];
      if (await prefs.setString('token', token) &&
          await prefs.setBool('isLogged', true)) {
        await prefs.setString('username', username);
        return const Right('Connexion réussie.');
      } else {
        return const Left('Problème lors de la connexion');
      }
    } on DioError catch (e) {
      return Left(e.response?.data.toString() ?? e.toString());
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> register(
    String username,
    String email,
    String password,
  ) async {
    try {
      final res = await dio.post(
        '$baseUrl/api/user/register',
        data: {
          'username': username,
          'email': email,
          'password': password,
        },
      );
      return const Right('Inscription réussie');
    } on DioError catch (e) {
      return Left(e.response?.data.toString() ?? e.toString());
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, List<String>>> getKeywords(
    String text, {
    String? algo,
    int? keywordsNumber,
  }) async {
    final data = {
      'contenu': text,
    };

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final headers = <String, dynamic>{};

    if (token != null) {
      headers['Authorization'] = 'Token $token';
    }

    if (algo != null) {
      data['choix'] = algo;
    }

    try {
      final res = await dio.post(
        '$baseUrl/api/user/fintino',
        data: jsonEncode(data),
        options: Options(
          headers: headers,
        ),
      );

      final keywords = <String>[];
      final Map<String, dynamic> parsedResponse = json.decode(res.data);
      
      for (var keyword in parsedResponse['result']) {
        keywords.add(keyword.toString());
      }
      
      return Right(keywords);
    } on DioError catch (e) {
      return Left(e.response?.data.toString() ?? e.toString());
    } catch (e) {
      return Left(e.toString());
    }
  }
}
