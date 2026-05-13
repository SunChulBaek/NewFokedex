import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/pokemon_species.dart';
import '../../data/repositories/pokemon_repository.dart';

final pokemonSpeciesProvider =
    FutureProvider.family<PokemonSpecies, int>((ref, id) async {
  final repository = ref.read(pokemonRepositoryProvider);
  return repository.getPokemonSpecies(id);
});
