import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/evolution_chain.dart';
import '../../data/repositories/pokemon_repository.dart';

final evolutionChainProvider =
    FutureProvider.family<List<List<EvolutionNode>>, int>(
        (ref, pokemonId) async {
  final repository = ref.read(pokemonRepositoryProvider);
  return repository.getEvolutionChain(pokemonId);
});
