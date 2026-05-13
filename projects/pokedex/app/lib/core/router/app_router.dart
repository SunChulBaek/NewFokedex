import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/pages/pokemon_list_page.dart';
import '../../presentation/pages/pokemon_detail_page.dart';
import '../../presentation/pages/favorites_page.dart';
import '../../presentation/widgets/app_shell.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/pokedex',
    routes: [
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/pokedex',
            name: 'pokedex',
            builder: (context, state) => const PokemonListPage(),
          ),
          GoRoute(
            path: '/favorites',
            name: 'favorites',
            builder: (context, state) => const FavoritesPage(),
          ),
        ],
      ),
      GoRoute(
        path: '/pokemon/:id',
        name: 'pokemon-detail',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          final name = state.uri.queryParameters['name'] ?? '';
          return PokemonDetailPage(pokemonId: id, pokemonName: name);
        },
      ),
    ],
  );
});
