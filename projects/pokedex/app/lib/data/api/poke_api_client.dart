import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import '../../core/constants/app_constants.dart';

class PokeApiClient {
  late final Dio _dio;
  late final CacheStore _cacheStore;
  late final CacheOptions _cacheOptions;

  PokeApiClient() {
    // 인메모리 캐시 (앱 재시작 시 초기화 — MemCacheStore)
    // 영구 캐시 필요 시 HiveCacheStore / DbCacheStore 교체 가능
    _cacheStore = MemCacheStore(maxSize: 50 * 1024 * 1024); // 50MB

    _cacheOptions = CacheOptions(
      store: _cacheStore,
      policy: CachePolicy.forceCache,
      maxStale: const Duration(days: 7),
      priority: CachePriority.normal,
      cipher: null,
      keyBuilder: CacheOptions.defaultCacheKeyBuilder,
      allowPostMethod: false,
    );

    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));

    _dio.interceptors.addAll([
      DioCacheInterceptor(options: _cacheOptions),
      LogInterceptor(
        requestBody: false,
        responseBody: false,
        logPrint: (o) {}, // silent
      ),
    ]);
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

  Future<Map<String, dynamic>> getEvolutionChain(int chainId) async {
    final response = await _dio.get('/evolution-chain/$chainId');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getEvolutionChainByUrl(String url) async {
    // URL이 절대 경로이므로 baseUrl을 무시하고 직접 요청
    final response = await _dio.get(
      url,
      options: _cacheOptions.toOptions(),
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getPokemonByType(String type) async {
    final response = await _dio.get('/type/$type');
    return response.data as Map<String, dynamic>;
  }
}
