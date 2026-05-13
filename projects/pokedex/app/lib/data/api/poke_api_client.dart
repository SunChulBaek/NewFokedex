import 'package:dio/dio.dart';
import '../constants/app_constants.dart';

class PokeApiClient {
  late final Dio _dio;

  PokeApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));

    _dio.interceptors.add(LogInterceptor(
      requestBody: false,
      responseBody: false,
    ));
  }

  Future<Map<String, dynamic>> getPokemonList({
    required int limit,
    required int offset,
  }) async {
    final response = await _dio.get(
      '/pokemon',
      queryParameters: {'limit': limit, 'offset': offset},
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getPokemonDetail(int id) async {
    final response = await _dio.get('/pokemon/$id');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getPokemonSpecies(int id) async {
    final response = await _dio.get('/pokemon-species/$id');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getPokemonByType(String type) async {
    final response = await _dio.get('/type/$type');
    return response.data as Map<String, dynamic>;
  }
}
