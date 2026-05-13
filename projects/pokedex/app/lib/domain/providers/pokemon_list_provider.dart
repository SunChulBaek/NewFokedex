import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/pokemon_list_item.dart';
import '../../data/repositories/pokemon_repository.dart';

// 현재 로드된 포켓몬 목록 상태
class PokemonListState {
  final List<PokemonListItem> items;
  final bool isLoading;
  final bool hasMore;
  final String? error;
  final int currentPage;

  const PokemonListState({
    this.items = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.error,
    this.currentPage = 0,
  });

  PokemonListState copyWith({
    List<PokemonListItem>? items,
    bool? isLoading,
    bool? hasMore,
    String? error,
    int? currentPage,
  }) {
    return PokemonListState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      error: error,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

class PokemonListNotifier extends StateNotifier<PokemonListState> {
  final PokemonRepository _repository;

  PokemonListNotifier(this._repository) : super(const PokemonListState()) {
    loadMore();
  }

  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _repository.getPokemonList(page: state.currentPage);
      state = state.copyWith(
        items: [...state.items, ...result.items],
        isLoading: false,
        hasMore: result.hasMore,
        currentPage: state.currentPage + 1,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> refresh() async {
    state = const PokemonListState();
    await loadMore();
  }
}

final pokemonListProvider =
    StateNotifierProvider<PokemonListNotifier, PokemonListState>((ref) {
  return PokemonListNotifier(ref.read(pokemonRepositoryProvider));
});
