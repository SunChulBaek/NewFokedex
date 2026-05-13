import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/poke_api_client.dart';
import '../models/pokemon_list_item.dart';
import '../models/pokemon_detail.dart';
import '../../core/constants/app_constants.dart';

final pokeApiClientProvider = Provider<PokeApiClient>((ref) {
  return PokeApiClient();
});

final pokemonRepositoryProvider = Provider<PokemonRepository>((ref) {
  return PokemonRepository(ref.read(pokeApiClientProvider));
});

class PokemonRepository {
  final PokeApiClient _client;

  PokemonRepository(this._client);

  Future<({List<PokemonListItem> items, bool hasMore})> getPokemonList({
    required int page,
  }) async {
    final offset = page * AppConstants.pageSize;
    final data = await _client.getPokemonList(
      limit: AppConstants.pageSize,
      offset: offset,
    );

    final results = (data['results'] as List)
        .map((e) => PokemonListItem.fromJson(e as Map<String, dynamic>))
        .toList();

    final total = data['count'] as int;
    final hasMore = offset + AppConstants.pageSize < total;

    return (items: results, hasMore: hasMore);
  }

  Future<PokemonDetail> getPokemonDetail(int id) async {
    final data = await _client.getPokemonDetail(id);
    return PokemonDetail.fromJson(data);
  }
}
