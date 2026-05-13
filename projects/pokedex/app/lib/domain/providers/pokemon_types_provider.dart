import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/pokemon_repository.dart';

/// 전역 포켓몬 타입 캐시: id → List<String> (type names)
/// PokemonCard가 필요할 때 lazy하게 요청
class PokemonTypesNotifier extends StateNotifier<Map<int, List<String>>> {
  final PokemonRepository _repository;
  final Set<int> _fetching = {};

  PokemonTypesNotifier(this._repository) : super({});

  void requestIfAbsent(int pokemonId) {
    if (state.containsKey(pokemonId) || _fetching.contains(pokemonId)) return;
    _fetching.add(pokemonId);
    _repository.getPokemonDetail(pokemonId).then((detail) {
      final types = detail.types.map((t) => t.type.name).toList();
      state = {...state, pokemonId: types};
      _fetching.remove(pokemonId);
    }).catchError((_) {
      _fetching.remove(pokemonId);
    });
  }
}

final pokemonTypesProvider =
    StateNotifierProvider<PokemonTypesNotifier, Map<int, List<String>>>((ref) {
  return PokemonTypesNotifier(ref.read(pokemonRepositoryProvider));
});
