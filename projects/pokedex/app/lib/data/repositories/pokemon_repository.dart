import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/poke_api_client.dart';
import '../models/pokemon_list_item.dart';
import '../models/pokemon_detail.dart';
import '../models/pokemon_species.dart';
import '../models/evolution_chain.dart';
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

  /// 전체 포켓몬 인덱스 (이름 + URL) 한 번에 fetch
  /// PokeAPI /pokemon?limit=10000 → 현재 약 1302마리
  Future<List<PokemonListItem>> getFullPokemonIndex() async {
    final data = await _client.getPokemonList(limit: 10000, offset: 0);
    return (data['results'] as List)
        .map((e) => PokemonListItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

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

  Future<PokemonSpecies> getPokemonSpecies(int id) async {
    final data = await _client.getPokemonSpecies(id);
    return PokemonSpecies.fromJson(data);
  }

  /// Species → evolution-chain URL → 파싱
  Future<List<List<EvolutionNode>>> getEvolutionChain(int pokemonId) async {
    // 1. species에서 evolution_chain URL 획득
    final speciesData = await _client.getPokemonSpecies(pokemonId);
    final species = PokemonSpecies.fromJson(speciesData);

    if (species.evolutionChainUrl == null) return [];

    // 2. evolution-chain 데이터 획득
    final chainData =
        await _client.getEvolutionChainByUrl(species.evolutionChainUrl!);

    // 3. 파싱
    final root = EvolutionNode.fromChainJson(
        chainData['chain'] as Map<String, dynamic>);

    return root.toChains();
  }
}
