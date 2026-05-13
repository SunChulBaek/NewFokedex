import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/pokemon_repository.dart';

/// 전역 한국어 이름 캐시: id → koreanName
/// PokemonCard가 필요할 때 lazy하게 요청, 한 번 fetch 후 영구 캐시
class KoreanNamesNotifier extends StateNotifier<Map<int, String>> {
  final PokemonRepository _repository;
  final Set<int> _fetching = {};

  KoreanNamesNotifier(this._repository) : super({});

  /// 캐시에 없으면 fetch 요청 (비동기, 완료 시 state 갱신)
  void requestIfAbsent(int pokemonId) {
    if (state.containsKey(pokemonId) || _fetching.contains(pokemonId)) return;
    _fetching.add(pokemonId);
    _repository.getPokemonSpecies(pokemonId).then((species) {
      if (species.koreanName != null) {
        state = {...state, pokemonId: species.koreanName!};
      }
      _fetching.remove(pokemonId);
    }).catchError((_) {
      _fetching.remove(pokemonId);
    });
  }
}

final koreanNamesProvider =
    StateNotifierProvider<KoreanNamesNotifier, Map<int, String>>((ref) {
  return KoreanNamesNotifier(ref.read(pokemonRepositoryProvider));
});
