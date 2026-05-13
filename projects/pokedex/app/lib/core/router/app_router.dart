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
            pageBuilder: (context, state) => _fadeTransition(
              state: state,
              child: const PokemonListPage(),
            ),
          ),
          GoRoute(
            path: '/favorites',
            name: 'favorites',
            pageBuilder: (context, state) => _fadeTransition(
              state: state,
              child: const FavoritesPage(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/pokemon/:id',
        name: 'pokemon-detail',
        pageBuilder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          final name = state.uri.queryParameters['name'] ?? '';
          return _slideUpTransition(
            state: state,
            child: PokemonDetailPage(pokemonId: id, pokemonName: name),
          );
        },
      ),
    ],
  );
});

/// FadeIn 트랜지션 (탭 전환용)
CustomTransitionPage<void> _fadeTransition({
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 200),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
        child: child,
      );
    },
  );
}

/// SlideUp + Fade 트랜지션 (상세 페이지용)
CustomTransitionPage<void> _slideUpTransition({
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final slide = Tween<Offset>(
        begin: const Offset(0, 0.05),
        end: Offset.zero,
      ).animate(CurveTween(curve: Curves.easeOut).animate(animation));

      return FadeTransition(
        opacity: animation,
        child: SlideTransition(position: slide, child: child),
      );
    },
  );
}
