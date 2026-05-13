import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/pokemon_repository.dart';

/// 타입별 포켓몬 ID 캐시: typeName → Set<int>
/// 타입 필터 선택 시 /type/{name} API 한 번 호출 후 영구 캐시
class PokemonTypeIdsNotifier extends StateNotifier<Map<String, Set<int>>> {
  final PokemonRepository _repository;
  final Set<String> _fetching = {};

  PokemonTypeIdsNotifier(this._repository) : super({});

  bool isLoading(String type) => _fetching.contains(type);

  Future<void> fetchIfAbsent(String type) async {
    if (state.containsKey(type) || _fetching.contains(type)) return;
    _fetching.add(type);
    try {
      final ids = await _repository.getPokemonIdsByType(type);
      state = {...state, type: ids};
    } catch (_) {
      // 실패 시 빈 셋으로 캐시 → 재시도 방지
      state = {...state, type: <int>{}};
    } finally {
      _fetching.remove(type);
    }
  }
}

final pokemonTypeIdsProvider =
    StateNotifierProvider<PokemonTypeIdsNotifier, Map<String, Set<int>>>((ref) {
  return PokemonTypeIdsNotifier(ref.read(pokemonRepositoryProvider));
});
