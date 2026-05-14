import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/models/pokemon_list_item.dart';
import '../../domain/providers/favorites_provider.dart';
import '../../domain/providers/korean_names_provider.dart';
import '../../domain/providers/pokemon_types_provider.dart';
import '../../core/constants/type_colors.dart';
import '../../core/theme/app_theme.dart';
import 'type_badge.dart';

class PokemonCard extends ConsumerStatefulWidget {
  final PokemonListItem item;

  const PokemonCard({super.key, required this.item});

  @override
  ConsumerState<PokemonCard> createState() => _PokemonCardState();
}

class _PokemonCardState extends ConsumerState<PokemonCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _favController;
  late Animation<double> _favScale;

  @override
  void initState() {
    super.initState();
    _favController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _favScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(
      parent: _favController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _favController.dispose();
    super.dispose();
  }

  void _toggleFavorite() {
    HapticFeedback.lightImpact();
    _favController.forward(from: 0.0);
    ref.read(favoritesProvider.notifier).toggle(widget.item.id);
  }

  @override
  Widget build(BuildContext context) {
    final isFav = ref.watch(favoritesProvider).contains(widget.item.id);
    final koreanNames = ref.watch(koreanNamesProvider);
    final typesMap = ref.watch(pokemonTypesProvider);

    // Korean name lazy fetch
    final korName = koreanNames[widget.item.id];
    if (korName == null) {
      ref.read(koreanNamesProvider.notifier).requestIfAbsent(widget.item.id);
    }

    // Types lazy fetch
    final types = typesMap[widget.item.id];
    if (types == null) {
      ref.read(pokemonTypesProvider.notifier).requestIfAbsent(widget.item.id);
    }

    final displayName = korName ?? _capitalize(widget.item.name);

    // Background color based on primary type
    final bgColor = types != null && types.isNotEmpty
        ? TypeColors.getColor(types.first).withOpacity(0.15)
        : const Color(0xFFF5F5F5);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          context.push('/pokemon/${widget.item.id}?name=${widget.item.name}');
        },
        child: Stack(
          children: [
            // 카드 배경
            Positioned.fill(
              child: Container(color: bgColor),
            ),
            // 메인 콘텐츠
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Hero(
                    tag: 'pokemon-image-${widget.item.id}',
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: CachedNetworkImage(
                        imageUrl: widget.item.spriteUrl,
                        fit: BoxFit.contain,
                        placeholder: (context, url) => const Center(
                          child:
                              CircularProgressIndicator(strokeWidth: 2),
                        ),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.catching_pokemon,
                          size: 48,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(6, 0, 6, 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '#${widget.item.id.toString().padLeft(3, '0')}',
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(
                              color: const Color(0xFF757575),
                              fontFamily: 'Rajdhani',
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                            ),
                      ),
                      Text(
                        displayName,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1C1B1F),
                              fontSize: 11,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Type badges
                if (types != null && types.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(6, 0, 6, 6),
                    child: Row(
                      children: types
                          .map((t) => Padding(
                                padding: const EdgeInsets.only(right: 4),
                                child: TypeBadge(type: t, small: true),
                              ))
                          .toList(),
                    ),
                  )
                else
                  const SizedBox(height: 6),
              ],
            ),
            // 즐겨찾기 버튼
            Positioned(
              top: 2,
              right: 2,
              child: ScaleTransition(
                scale: _favScale,
                child: GestureDetector(
                  onTap: _toggleFavorite,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      isFav ? Icons.favorite : Icons.favorite_outline,
                      size: 14,
                      color: isFav ? AppTheme.primary : AppTheme.outline,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}
