import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/evolution_chain.dart';
import '../../domain/providers/evolution_chain_provider.dart';
import '../../core/theme/app_theme.dart';

class EvolutionChainWidget extends ConsumerWidget {
  final int pokemonId;

  const EvolutionChainWidget({super.key, required this.pokemonId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chainAsync = ref.watch(evolutionChainProvider(pokemonId));

    return chainAsync.when(
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (e, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            '진화 정보를 불러올 수 없습니다',
            style: TextStyle(color: AppTheme.outline),
          ),
        ),
      ),
      data: (chains) {
        if (chains.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text('진화하지 않는 포켓몬입니다'),
            ),
          );
        }
        // 첫 번째 (주) 진화 경로 표시
        final mainChain = chains.first;
        if (mainChain.length <= 1) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text('진화하지 않는 포켓몬입니다'),
            ),
          );
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildChainRow(context, mainChain),
          ),
        );
      },
    );
  }

  List<Widget> _buildChainRow(
      BuildContext context, List<EvolutionNode> chain) {
    final widgets = <Widget>[];
    for (int i = 0; i < chain.length; i++) {
      final node = chain[i];
      final isCurrent = node.id == pokemonId;

      widgets.add(_PokemonEvoNode(
        node: node,
        isCurrent: isCurrent,
      ));

      if (i < chain.length - 1) {
        // 다음 노드의 진화 조건을 화살표 위에 표시
        final nextNode = chain[i + 1];
        widgets.add(_EvoArrow(trigger: nextNode.evolutionTrigger));
      }
    }
    return widgets;
  }
}

class _PokemonEvoNode extends StatelessWidget {
  final EvolutionNode node;
  final bool isCurrent;

  const _PokemonEvoNode({required this.node, required this.isCurrent});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!isCurrent) {
          context.push('/pokemon/${node.id}?name=${node.name}');
        }
      },
      child: SizedBox(
        width: 80,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: isCurrent
                    ? Border.all(color: AppTheme.primary, width: 2)
                    : null,
                color: const Color(0xFFF5F5F5),
              ),
              child: ClipOval(
                child: Hero(
                  tag: isCurrent
                      ? 'evo-current-${node.id}'
                      : 'pokemon-image-${node.id}',
                  child: CachedNetworkImage(
                    imageUrl: node.spriteUrl,
                    fit: BoxFit.contain,
                    placeholder: (_, __) => const Center(
                      child: CircularProgressIndicator(strokeWidth: 1.5),
                    ),
                    errorWidget: (_, __, ___) => const Icon(
                      Icons.catching_pokemon,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              node.displayName,
              textAlign: TextAlign.center,
              style: GoogleFonts.notoSansKr(
                fontSize: 12,
                fontWeight:
                    isCurrent ? FontWeight.w700 : FontWeight.w400,
                color: isCurrent
                    ? AppTheme.primary
                    : const Color(0xFF1C1B1F),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _EvoArrow extends StatelessWidget {
  final String? trigger;

  const _EvoArrow({this.trigger});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trigger != null)
            Text(
              trigger!,
              style: GoogleFonts.notoSansKr(
                fontSize: 10,
                color: AppTheme.outline,
              ),
            ),
          const SizedBox(height: 2),
          const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: AppTheme.outline,
          ),
        ],
      ),
    );
  }
}
