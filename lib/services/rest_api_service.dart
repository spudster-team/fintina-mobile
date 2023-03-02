import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class HttpRestApiService {
  Dio dio;

  HttpRestApiService(this.dio);

  Future<String> getHistory(){
    throw UnimplementedError();
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
      // return Right(res.data.toString());
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
      'titre': 'titre',
      'contenu': text,
    };

    if (algo != null) {
      data['choix'] = algo;
    }
    
    try {
      final res = await dio.post(
        '$baseUrl/api/user/fintino',
        data: data,
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
