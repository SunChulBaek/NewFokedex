import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import '../../data/models/pokemon_list_item.dart';
import '../../data/repositories/pokemon_repository.dart';

/// 전체 포켓몬 인덱스 상태 (이름 + id 목록)
/// 앱 시작 시 한 번 fetch → 검색에서 사용
class PokemonIndexState {
  final List<PokemonListItem> allItems;
  final bool isLoading;
  final String? error;

  const PokemonIndexState({
    this.allItems = const [],
    this.isLoading = false,
    this.error,
  });

  bool get isReady => !isLoading && allItems.isNotEmpty;
}

class PokemonIndexNotifier extends StateNotifier<PokemonIndexState> {
  final PokemonRepository _repository;

  PokemonIndexNotifier(this._repository) : super(const PokemonIndexState()) {
    _load();
  }

  Future<void> _load() async {
    state = const PokemonIndexState(isLoading: true);
    try {
      final items = await Future.any([
        _repository.getFullPokemonIndex(),
        Future.delayed(const Duration(seconds: 3), () => <PokemonListItem>[]),
      ]);
      state = PokemonIndexState(allItems: items);
    } catch (e) {
      state = PokemonIndexState(error: e.toString());
    } finally {
      FlutterNativeSplash.remove();
    }
  }
}

final pokemonIndexProvider =
    StateNotifierProvider<PokemonIndexNotifier, PokemonIndexState>((ref) {
  return PokemonIndexNotifier(ref.read(pokemonRepositoryProvider));
});
