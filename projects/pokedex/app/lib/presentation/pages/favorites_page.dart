import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/providers/favorites_provider.dart';
import '../../domain/providers/pokemon_index_provider.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/pokemon_card.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteIds = ref.watch(favoritesProvider);
    final indexState = ref.watch(pokemonIndexProvider);

    if (favoriteIds.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('즐겨찾기'),
          backgroundColor: AppTheme.primary,
          foregroundColor: Colors.white,
        ),
        body: _buildEmpty(context),
      );
    }

    if (!indexState.isReady) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('즐겨찾기'),
          backgroundColor: AppTheme.primary,
          foregroundColor: Colors.white,
        ),
        body: _buildLoading(),
      );
    }

    final favoriteItems = indexState.allItems
        .where((item) => favoriteIds.contains(item.id))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('즐겨찾기'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
      ),
      body: favoriteItems.isEmpty
          ? _buildEmpty(context)
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemCount: favoriteItems.length,
              itemBuilder: (context, index) {
                return PokemonCard(item: favoriteItems[index]);
              },
            ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Opacity(
            opacity: 0.3,
            child: Icon(
              Icons.catching_pokemon,
              size: 80,
              color: AppTheme.outline,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '아직 즐겨찾기한 포켓몬이 없어요',
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: AppTheme.outline),
          ),
          const SizedBox(height: 8),
          Text(
            '하트를 눌러 추가해보세요 💕',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppTheme.outline),
          ),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('즐겨찾기 로딩 중...'),
        ],
      ),
    );
  }
}
