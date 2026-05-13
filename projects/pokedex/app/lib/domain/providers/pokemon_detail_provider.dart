import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/pokemon_detail.dart';
import '../../data/repositories/pokemon_repository.dart';

final pokemonDetailProvider =
    FutureProvider.family<PokemonDetail, int>((ref, id) async {
  final repository = ref.read(pokemonRepositoryProvider);
  return repository.getPokemonDetail(id);
});
